module dot_prod #(parameter NROW = 16,
                  parameter NCOL = 16,
                  parameter QN   = 6,
                  parameter QM   = 11,
                  parameter DSP48_PER_ROW    = 4)
                 (weightRow, 
                  inputVector, 
                  clk,
                  reset,
                  dataReady,
                  colAddress,
                  outputVector);

    parameter BITWIDTH              = QN + QM + 1;
	parameter ADDR_BITWIDTH         = log2(NCOL);
    parameter LAYER_BITWIDTH        = BITWIDTH*NROW;
    parameter N_DSP48               = NROW/DSP48_PER_ROW;
    parameter DSP48_INPUT_BITWIDTH  = BITWIDTH*N_DSP48;
    parameter DSP48_OUTPUT_BITWIDTH = (2*BITWIDTH+1)*NROW;
    parameter MAC_BITWIDTH          = (2*BITWIDTH+1);
	parameter MUX_BITWIDTH          = log2(DSP48_PER_ROW);
	
	input signed      [LAYER_BITWIDTH-1:0] weightRow; 
	input signed      [BITWIDTH-1:0]       inputVector; 
	input         clk;
	input         reset;
	output reg    dataReady;
	output reg          [ADDR_BITWIDTH-1:0]  colAddress;
	output reg signed  [LAYER_BITWIDTH-1:0] outputVector;
	reg signed  [LAYER_BITWIDTH-1:0] outputVectorTEMP;
	
    // Internal register definition
    reg [MUX_BITWIDTH-1:0] rowMux;
    reg signed [DSP48_INPUT_BITWIDTH -1:0]  weightMAC;
    reg signed [DSP48_OUTPUT_BITWIDTH -1:0] outputMAC;
    reg signed [DSP48_OUTPUT_BITWIDTH -1:0] outputMAC_sum;
    integer i;

    // FSM Registers
    reg [1:0] state;
    reg [1:0] NEXTstate;
    reg [ADDR_BITWIDTH-1:0] NEXTcolAddress;
    reg [MUX_BITWIDTH-1:0] NEXTrowMux;
    reg outputEn;
    reg clearMAC;
    parameter IDLE = 2'd0;
    parameter CALC = 2'd1;
    parameter END  = 2'd2;

    // The MAC multiplexer that selects the appropriate weight row for the MAC
    always @(*) begin
        if (reset == 1'b1) 
            weightMAC = {DSP48_INPUT_BITWIDTH{1'b0}};
        else
            for(i = 0; i < N_DSP48; i = i + 1) begin
                weightMAC[i*BITWIDTH +: BITWIDTH] = weightRow[(i*DSP48_PER_ROW+rowMux)*BITWIDTH +: BITWIDTH];    
            end
    end
    
    always @(posedge clk) begin
		if(dataReady == 1'b0) begin
			for (i=0; i < N_DSP48; i = i + 1) begin
				outputMAC_sum[(i*DSP48_PER_ROW+rowMux)*MAC_BITWIDTH +: MAC_BITWIDTH] = $signed(outputMAC[(i*DSP48_PER_ROW+rowMux)*MAC_BITWIDTH +: MAC_BITWIDTH]);
			end
		end
		else begin
		
		    for (i=0; i < N_DSP48; i = i + 1) begin 
			     outputMAC_sum[(i*DSP48_PER_ROW+rowMux)*MAC_BITWIDTH +: MAC_BITWIDTH] = {MAC_BITWIDTH{1'b0}};
			end
		
		end
	end
    
	always @(posedge clk) begin
		if (reset == 1'b1)
            outputMAC <= {DSP48_OUTPUT_BITWIDTH{1'b0}};
        else
			if(outputEn == 1'b1) begin
				for (i=0; i < N_DSP48; i = i + 1) begin
					outputMAC[(i*DSP48_PER_ROW+rowMux)*MAC_BITWIDTH +: MAC_BITWIDTH] <= $signed(outputMAC_sum[(i*DSP48_PER_ROW+rowMux)*MAC_BITWIDTH +: MAC_BITWIDTH]) + ($signed(weightMAC[i*BITWIDTH +: BITWIDTH]) * $signed(inputVector));
				end	
			end
			else
			     outputMAC <= outputMAC;
			
    end
    
    
    // The output vector and adder
    always @(posedge dataReady or posedge reset) begin
		if (reset == 1'b1) begin
			outputVector <= {LAYER_BITWIDTH{1'b0}};
		end
		else begin
			for(i = 0; i < NROW; i = i + 1) begin
				outputVector[i*BITWIDTH +: BITWIDTH] <= ($signed(outputMAC[i*MAC_BITWIDTH +: MAC_BITWIDTH]) >>> QM);
			end
		end
    end

// The control signal FSM
    always @(posedge clk) begin
        if( reset == 1'b1) begin 
            state <= 2'd0;
            colAddress <= {ADDR_BITWIDTH{1'b0}};
            rowMux     <= {MUX_BITWIDTH{1'b0}};
        end
        else begin
            state      <= NEXTstate;
            colAddress <= NEXTcolAddress;
            rowMux     <= NEXTrowMux;
        end            
    end      
    
    // Combinational block that produces the next state 
    always @(*) begin
        case(state)
            IDLE : 
                NEXTstate = CALC;
            CALC :
                if (colAddress == NCOL-1 && rowMux == DSP48_PER_ROW-1)
                    NEXTstate = END;
                else
                    NEXTstate = CALC;
            END :
                NEXTstate = CALC;
            default:
                NEXTstate = IDLE;
        endcase   
    end

    // Combinational block that produces the control signals
    always @(*) begin
        case(state)
            IDLE : 
            begin
                dataReady      = 1'b0;
                NEXTcolAddress = {ADDR_BITWIDTH{1'b0}};      
                NEXTrowMux     = {MUX_BITWIDTH{1'b0}};     
                outputEn       = 1'b0;
                clearMAC       = 1'b1;
            end
            
            CALC :
            begin
                dataReady      = 1'b0;
                NEXTcolAddress = colAddress + 1; 
                if(colAddress == NCOL - 1) begin
                    NEXTrowMux = rowMux + 1;
                    clearMAC   = 1'b1;
                end
                else begin
                    NEXTrowMux = rowMux;
                    clearMAC   = 1'b0;
                end
                outputEn       = 1'b1;
            end
           
            END :
            begin
                dataReady      = 1'b1;
                NEXTcolAddress = {ADDR_BITWIDTH{1'b0}};      
                NEXTrowMux     = {MUX_BITWIDTH{1'b0}};      
                outputEn       = 1'b1;
                clearMAC       = 1'b0;
            end
            
            default:
            begin
                dataReady      = 1'b0;
                NEXTcolAddress = {ADDR_BITWIDTH{1'b0}};      
                NEXTrowMux     = {MUX_BITWIDTH{1'b0}};      
                outputEn       = 1'b0;
                clearMAC       = 1'b1;
            end
        endcase   
    end

    
function integer log2;
	input [31:0] argument;
	integer k;
	begin
		 log2 = -1;
		 k = argument;  
		 while( k > 0 ) begin
			log2 = log2 + 1;
			k = k >> 1;
		 end
	end
endfunction
    
endmodule

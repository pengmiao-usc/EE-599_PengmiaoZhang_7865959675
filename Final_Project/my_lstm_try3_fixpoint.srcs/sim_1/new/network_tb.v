`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2020 04:16:24 PM
// Design Name: 
// Module Name: network_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module tb_network;
    parameter BITWIDTH = 18;
    parameter INPUT_DIM = 48;
    parameter INPUT_SAMPLE=10;
    parameter OUTPUT_DIM = 16;
    
    parameter EM_IN=2;
    parameter EM_DIM=10;
    
    
    reg	clk;
    reg reset;
    reg [INPUT_DIM-1:0] MEM_Input [0:INPUT_SAMPLE-1];
    reg [BITWIDTH-1:0] MEM_Weight_EM [0:EM_IN*EM_DIM-1];
    reg [BITWIDTH*EM_DIM*EM_IN-1:0] Weight_EM_flat;
    
    //reg [BITWIDTH-1:0] MEM_Ouptut [0:OUTPUT_DIM-1];
    wire [BITWIDTH*INPUT_DIM*EM_DIM-1:0] MEM_Ouptut;
    
    integer k;
	integer j;
	integer i;
	integer fid_Wz;
	integer retVal;
    
    initial begin
		clk		=	0;
		forever	begin
			#5;
			clk	=	~clk;
		end
	end
	
	initial begin
		reset		=	1;
		#10;
		reset		=	0;
	end
	
	initial begin
        $readmemb("/home/pengmiao/Project/MEMSYS/my_ChampSim_Py/0501/Input_X.dat", MEM_Input);
        //$readmemb("/home/pengmiao/Project/MEMSYS/my_ChampSim_Py/0501/weight_Em.dat", MEM_Weight_EM);
        $readmemb("/home/pengmiao/Project/MEMSYS/my_ChampSim_Py/0501/weight_Em_fpb.dat", MEM_Weight_EM);
        for (i=0;i<EM_IN*EM_DIM;i=i+1) begin
            Weight_EM_flat[BITWIDTH*i +: BITWIDTH ]=MEM_Weight_EM[i];
        end
    end
    
    
    network#(.BITWIDTH(BITWIDTH),.INPUT_DIM(INPUT_DIM))
    NETWORK(
    .clk(clk),
    .reset(reset),
    .network_input(MEM_Input[0]),
 //   .Em_weight_0(Weight_EM_flat[BITWIDTH*EM_DIM*EM_IN/2-1:0]),
 //   .Em_weight_1(Weight_EM_flat[BITWIDTH*EM_DIM*EM_IN-1:BITWIDTH*EM_DIM*EM_IN/2]),
    .network_output(MEM_Ouptut)
    );
        
    initial begin
		fid_Wz = $fopen("/home/pengmiao/Project/MEMSYS/my_ChampSim_Py/0501/weight_Em_fpb.dat", "r");
		// -------------------------------- Loading the weight memory ------------------------------- //
		//for(i = 0; i < EM_IN; i = i + 1) begin
            for(j = 0; j < EM_DIM; j = j + 1) begin
                retVal = $fscanf(fid_Wz, "%b\n", NETWORK.WRAM_Em_0.RAM_matrix[0][j*BITWIDTH +: BITWIDTH]);
                retVal = $fscanf(fid_Wz, "%b\n", NETWORK.WRAM_Em_1.RAM_matrix[0][j*BITWIDTH +: BITWIDTH]);
            end
       // end
    end
endmodule

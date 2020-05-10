`timescale 1ns / 1ps
module network  #(parameter RAW_INPUT_BIT = 1,
                  parameter RAW_INPUT_SZ = 1,
                  parameter INPUT_SZ   =  8,
                  parameter HIDDEN_SZ  = 32,
                  parameter OUTPUT_SZ  =  1,//NUM_OUTPUT_SYMBOLS = 2,
                  parameter QN        =  6,
                  parameter QM        = 11,
                  parameter DSP48_PER_ROW_G = 4,
                  parameter DSP48_PER_ROW_M = 4,
                  parameter EM_IN  = 2,
                  parameter EM_DIM  = 8)
                 (inputVec,
        //          trainingFlag,
                  clock,
                  reset,
                  newSample,
                  data_lstm_Ready,
                  outputVec,
                  dense_enable,
                  data_result_Ready);

    // Dependent parameters
    parameter BITWIDTH           = QN + QM + 1;
    parameter INPUT_BITWIDTH     = BITWIDTH*INPUT_SZ;
    parameter LAYER_BITWIDTH     = BITWIDTH*HIDDEN_SZ;
    parameter MULT_BITWIDTH      = (2*BITWIDTH+2);
    parameter ELEMWISE_BITWIDTH  = MULT_BITWIDTH*HIDDEN_SZ;
    parameter OUTPUT_BITWIDTH    = OUTPUT_SZ * BITWIDTH; //log2(NUM_OUTPUT_SYMBOLS);
	parameter ADDR_BITWIDTH      = log2(HIDDEN_SZ);
	parameter ADDR_BITWIDTH_X    = log2(INPUT_SZ);
	parameter MUX_BITWIDTH		  = log2(DSP48_PER_ROW_M);  
	parameter N_DSP48            = HIDDEN_SZ/DSP48_PER_ROW_M; 
	parameter FINAL_SIZE = 16;
	
    // Input/Output definitions
    input [RAW_INPUT_BIT-1:0]       inputVec;
   // input                            trainingFlag;
    input                            clock;
    input                            reset;
    input                            newSample;
    output                        data_lstm_Ready;
    output  [FINAL_SIZE*BITWIDTH-1:0] outputVec;
    input dense_enable;
    output data_result_Ready;
    // ---------------------------------------------------------------- //
    
    wire [INPUT_BITWIDTH-1:0] embed_out;
    wire new_sample_emb;
    wire [LAYER_BITWIDTH-1:0]  lstm_out;
    wire dataReady_lstm;
    reg  [FINAL_SIZE*LAYER_BITWIDTH-1:0] W_DENSE_W;
    reg  [FINAL_SIZE*BITWIDTH-1:0] W_DENSE_B;
	//assign dataReady_lstm=dataReady;
    
    embedding #(RAW_INPUT_BIT,RAW_INPUT_SZ, INPUT_SZ, HIDDEN_SZ, OUTPUT_SZ, QN, QM, DSP48_PER_ROW_G, DSP48_PER_ROW_M,EM_IN,EM_DIM) 
    EMBEDDING_LAYER (inputVec, clock,reset, newSample,new_sample_emb, embed_out);
    
    lstm              #(INPUT_SZ, HIDDEN_SZ, OUTPUT_SZ, QN, QM, DSP48_PER_ROW_G, DSP48_PER_ROW_M) 
    LSTM_LAYER    (embed_out, clock, reset, new_sample_emb, data_lstm_Ready, lstm_out);
	
	
    dense #(INPUT_SZ,HIDDEN_SZ,OUTPUT_SZ,QN, QM, DSP48_PER_ROW_G, DSP48_PER_ROW_M,EM_IN,EM_DIM) 
    DENSE_LAYER (W_DENSE_W,W_DENSE_B,lstm_out, clock,reset, dense_enable, data_lstm_Ready, outputVec,data_result_Ready);		
			
			
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
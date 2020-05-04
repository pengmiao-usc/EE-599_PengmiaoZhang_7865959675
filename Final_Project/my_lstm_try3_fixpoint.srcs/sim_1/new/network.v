`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2020 08:57:20 PM
// Design Name: 
// Module Name: network
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


module network#(
    parameter BITWIDTH = 18,
    parameter INPUT_DIM = 48)
    (
    input clk,
    input reset,
    input [INPUT_DIM-1:0] network_input,
    
  //  input [BITWIDTH*EM_DIM-1:0] Em_weight_0,
  //  input [BITWIDTH*EM_DIM-1:0] Em_weight_1,
    
    output [BITWIDTH*INPUT_DIM*EM_DIM-1:0] network_output
    );
    parameter EM_IN=2;
    parameter EM_DIM=10;
    parameter ADDR_BITWIDTH_X    = log2(EM_IN);
    parameter LAYER_BITWIDTH     = BITWIDTH*EM_DIM;
    reg                          writeEn_=0;
    reg    [LAYER_BITWIDTH-1:0]  wZX_in;
    wire   [LAYER_BITWIDTH-1:0]  wEm_out0;
    wire   [LAYER_BITWIDTH-1:0]  wEm_out1;
    
    
    weightRAM  #(EM_DIM,  1, BITWIDTH)  WRAM_Em_0 (2'b0, 0, 0, clk, reset, wZX_in, wEm_out0);
    weightRAM  #(EM_DIM,  1, BITWIDTH)  WRAM_Em_1 (2'b0, 0, 0, clk, reset, wZX_in, wEm_out1);
    
    embedding #(
    .BITWIDTH(BITWIDTH),.INPUT_DIM(INPUT_DIM),.EM_IN(EM_IN),.EM_DIM(EM_DIM))
    Embedding_Layer(
    .clk(clk),
    .Em_weight_0(wEm_out0),
    .Em_weight_1(wEm_out1),
    .embedding_input(network_input),
    .Em_out(network_output)
    );
    
    
    
    
    
   
     
        
    
    //--------------------------------//
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

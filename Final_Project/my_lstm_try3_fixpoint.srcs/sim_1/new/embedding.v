`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2020 11:13:18 PM
// Design Name: 
// Module Name: Embedding
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


module embedding #(
    parameter BITWIDTH = 18,
    parameter INPUT_DIM = 48,
    parameter EM_IN=2,
    parameter EM_DIM=10)
    (
    input clk,
    input signed [INPUT_DIM-1:0] embedding_input,
    input signed [BITWIDTH*EM_DIM-1:0] Em_weight_0,
    input signed [BITWIDTH*EM_DIM-1:0] Em_weight_1,
    output reg signed [BITWIDTH*INPUT_DIM*EM_DIM-1:0] Em_out
    );
    integer i;
    integer j=0;
    reg [BITWIDTH-1:0] weight_test_reg[0:2];
    
    
    
    always @ (posedge clk)
    begin
        for (i=0;i<INPUT_DIM;i=i+1) begin
            if(embedding_input[i]==0)begin
                Em_out[BITWIDTH*EM_DIM*i +: BITWIDTH*EM_DIM]<=Em_weight_0;
               // weight_test_reg[0]<=Em_out[BITWIDTH-1:0];
               // j=j+1;
            end
            else begin
                Em_out[BITWIDTH*EM_DIM*i +: BITWIDTH*EM_DIM]<=Em_weight_1;
               // weight_test_reg[1]<=Em_weight_1[BITWIDTH-1:0];
                
            end
        
        end
    end
    
    
    
endmodule

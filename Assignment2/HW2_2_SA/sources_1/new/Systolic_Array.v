`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2020 06:51:57 PM
// Design Name: 
// Module Name: Systolic_Array
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


module Systolic_Array#(
    parameter BIT_WIDTH = 8,//k
    parameter N=16
    )
    (
    input clk,
    input reset,
    input enable,
    input [BIT_WIDTH*N-1:0] A,
    input [BIT_WIDTH*N-1:0] B,
    output [BIT_WIDTH*N*N-1:0] C
    );
    
    wire [BIT_WIDTH-1:0] in_a_pe [0:N-1][0:N-1];
    wire [BIT_WIDTH-1:0] out_a_pe [0:N-1][0:N-1]; 
    wire [BIT_WIDTH-1:0] in_b_pe [0:N-1][0:N-1];
    wire [BIT_WIDTH-1:0] out_b_pe [0:N-1][0:N-1];
    wire [BIT_WIDTH-1:0] out_c_pe [0:N-1][0:N-1]; 
  
    
    genvar m;
    generate //firt input
        for (m=0;m<N;m=m+1)begin
            assign in_a_pe[m][0]=A[(m+1)*BIT_WIDTH-1:m*BIT_WIDTH];
            assign in_b_pe[0][m]=B[(m+1)*BIT_WIDTH-1:m*BIT_WIDTH];
        end
    endgenerate
    
    
    genvar i,j;
    generate
        for (i=0;i<N;i=i+1)begin
            for(j=0;j<N;j=j+1)begin
                if(j>0)
                assign in_a_pe[i][j]=out_a_pe[i][j-1];
                if(i>0)
                assign in_b_pe[i][j]=out_b_pe[i-1][j];
                PE#( .BIT_WIDTH (BIT_WIDTH),//k
                .N(N))
                PE_i(
                .clk(clk),
                .reset(reset),
                .enable(enable),
                .in_a(in_a_pe[i][j]),
                .in_b(in_b_pe[i][j]),
                .out_a(out_a_pe[i][j]),
                .out_b(out_b_pe[i][j]),
                .out_c(out_c_pe[i][j])
                );
               assign C[(i*N+j+1)*BIT_WIDTH-1:(i*N+j)*BIT_WIDTH]=out_c_pe[i][j];
                
            end
        end
    endgenerate
    
    
endmodule


/*
module PE#(
    parameter BIT_WIDTH = 8,//k
    parameter N=4)
    (
    input clk,
    input [BIT_WIDTH-1:0] in_a,
    input [BIT_WIDTH-1:0] in_b,
    output reg [BIT_WIDTH-1:0] out_a,
    output reg [BIT_WIDTH-1:0] out_b,
    output reg [BIT_WIDTH-1:0] out_c
    );
    always @ (posedge clk)
    begin
        out_a<=in_a;
        out_b<=in_b;
        out_c<=out_c+in_a*in_b;
    end
    */
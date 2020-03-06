`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2020 12:01:57 AM
// Design Name: 
// Module Name: OE_Sort
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


module OE_Sort #(
     parameter BIT_WIDTH = 8,//k
     parameter N=128
     )
(
    input clk,
    input rst,
    input [BIT_WIDTH*N-1:0] list,
    output [BIT_WIDTH*N-1:0] sorted_list
    );

wire [BIT_WIDTH-1:0] list_mat [0:N][0:N-1];


//wire [BIT_WIDTH-1:0] w    [0:N*(N+1)-1];

genvar m;
generate
for(m=0;m<N;m=m+1) begin
    assign list_mat[0][m]= list[(m+1)*BIT_WIDTH-1:m*BIT_WIDTH]; //first line
end
endgenerate

genvar i,j;
generate
    for (i = 0;i < N;i = i + 1) //compare N times
    begin
        if (i[0] == 1'b0)
            begin // even
                for (j = 0;j < N;j = j + 2)
                    begin
                        Compare_and_Swap #(.BIT_WIDTH(8))CS1
                                           (.clk(clk),
                                           .a(list_mat[i][j]),
                                           .b(list_mat[i][j+1]),
                                           .big(list_mat[i+1][j]),
                                           .sme(list_mat[i+1][j+1]));
                    end            
            end 
      else
            begin // odd, lack of first and last, need to assign manually
                assign list_mat[i+1][0]=list_mat[i][0];
                for (j = 1;j < N-2;j = j + 2)
                    begin
                        Compare_and_Swap #(.BIT_WIDTH(8))CS2
                                           (.clk(clk),
                                           .a(list_mat[i][j]),
                                           .b(list_mat[i][j+1]),
                                           .big(list_mat[i+1][j]),
                                           .sme(list_mat[i+1][j+1]));
                    end        
                assign list_mat[i+1][N-1]=list_mat[i][N-1];    
            end
    end
    
endgenerate

for(m=0;m<N;m=m+1) begin
    assign sorted_list[(m+1)*BIT_WIDTH-1:m*BIT_WIDTH]=list_mat[N][m];
end


   // wire [BIT_WIDTH-1:0] res1;
   // wire [BIT_WIDTH-1:0] res2;
    
    
    
   /* No Delete, For Test
      Compare_and_Swap #(.BIT_WIDTH(8))CS1
       (.clk(clk),.a(list[BIT_WIDTH-1:0]),
       .b(list[BIT_WIDTH*2-1:BIT_WIDTH]),
       .big(res1),
       .sme(res2));
       */
endmodule

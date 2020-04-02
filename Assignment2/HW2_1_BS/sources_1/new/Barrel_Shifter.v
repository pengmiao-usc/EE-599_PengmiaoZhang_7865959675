`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2020 08:46:27 PM
// Design Name: 
// Module Name: Barrel_Shifter
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

module Barrel_Shifter#(
     parameter BIT_WIDTH = 8,//k
     parameter N=64)
     (
     input clk,
     input [BIT_WIDTH*N-1:0] IN,
     input [$clog2(N)-1:0] Shift,
     output [BIT_WIDTH*N-1:0] OUT
     );
     
     wire [BIT_WIDTH*N-1:0] IN_l [0:$clog2(N)-1]; //IN_layer
     wire [BIT_WIDTH*N-1:0] OUT_l [0:$clog2(N)-1]; //Out_layer
     wire [$clog2(N)-1:0] Shift_I[0:$clog2(N)-1];
     wire [$clog2(N)-1:0] Shift_O[0:$clog2(N)-1];
     
     genvar m;
     generate
	 for(m=0;m<$clog2(N);m=m+1) begin
	   if(m==0)begin
	       assign IN_l[m]=IN;
	       assign Shift_I[m]=Shift;
	       end
	   else
	       begin
	       assign IN_l[m]=OUT_l[m-1];
	       assign Shift_I[m]=Shift_O[m-1];
	       end
	   Layer#(
        .BIT_WIDTH (BIT_WIDTH),//k
        .N(N),
        .LAYER(m))
         Layer(
        .clk(clk),
        .IN(IN_l[m]),
        .Shift_I(Shift_I[m]),
        .OUT(OUT_l[m]),
        .Shift_O(Shift_O[m])
        );
	 end
	 assign OUT=OUT_l[$clog2(N)-1];
	 endgenerate
	
/*
   //  wire [BIT_WIDTH*N-1:0] OUT1;
     Layer#(
    .BIT_WIDTH (BIT_WIDTH),//k
    .N(N),
    .LAYER(2))
     Layer1(
    .clk(clk),
    .IN(IN),
    .SELECT(Shift[0]),
    .OUT(OUT)
    );
    
  //  always @(posedge clk) begin
  //  OUT<=OUT1;
  //  end
  */     

endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2020 08:47:08 PM
// Design Name: 
// Module Name: BS_tb
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


module BS_tb;
    parameter	BIT_WIDTH	=	8;
    parameter   N = 16;

	reg						clk;
	reg 					reset;
	reg	 [BIT_WIDTH*N-1:0]	IN;
	reg     [$clog2(N)-1:0]    Shift;
	wire     [BIT_WIDTH*N-1:0]	OUT;
	//reg     enable;
	
	initial begin
		clk		=	0;
	//	enable = 0;
		forever	begin
			#5;
			clk	=	~clk;
		end
	end

	initial begin
		reset		=	1;
		#10;
	//	enable = 1;
		reset		=	0;
		#20000;
	end
	
    Barrel_Shifter#(
    .BIT_WIDTH (BIT_WIDTH),//k
    .N(N))
     Barrel_Shifter1(
     .clk(clk),
     .IN(IN),
     .Shift(Shift),
     .OUT(OUT)
     );
          
	
	integer k;
	integer j;
	always @(posedge clk) begin
        if(reset == 0)
        begin
            for (k = 0;k < BIT_WIDTH*N;k = k + 1) 
                begin
                   IN[k] <= $random();
                  // enable <= 0;
                end       
            for (j = 0;j < $clog2(N);j = j + 1) 
                begin
                   Shift[j] <= $random();
                  // enable <= 0;
                end                       
        end
    end
   
    
   /*
   module Barrel_Shifter#(
     parameter BIT_WIDTH = 8,//k
     parameter N=8)
     (
     input clk,
     input [BIT_WIDTH*N-1:0] IN,
     input [$clog2(N)-1:0] Shift,
     output [BIT_WIDTH*N-1:0] OUT
     );
     */
	//assign IN[7:0] =8'b11111111;
//	assign IN[15:8] =8'b00000000;
//	assign Shift[3:0] =3'b010;
    /*
    Barrel_Shifter#(
        .BIT_WIDTH (BIT_WIDTH),//k
        .N(N))
         (
         .clk(clk),
         .IN(IN),
         .Shift(Shift2),
         .OUT(OUT)
         );
      */
    

    
       
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2020 12:06:09 AM
// Design Name: 
// Module Name: OE_Sort_tb
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


module OE_Sort_tb;

    parameter	BIT_WIDTH	=	8;
    parameter   N = 32;

	reg						clk;
	reg 					reset;
	reg		[BIT_WIDTH*N-1:0]	list;
	reg     enable;
	
	wire [BIT_WIDTH*N-1:0] list_vec;
	
	OE_Sort#(
	.BIT_WIDTH(BIT_WIDTH),
	.N(N)
	)
	OE_Sort1(
	.clk(clk),
	.rst(reset),
	.list(list),
	.sorted_list(list_vec)
	);
	
	initial begin
		clk		=	0;
		enable = 0;
		forever	begin
			#5;
			clk	=	~clk;
		end
	end

	initial begin
		reset		=	1;
		#10;
		enable = 1;
		reset		=	0;
		#20000;
	end
	
	integer k;
	always @(posedge clk) begin
        if(enable == 1)
        begin
            for (k = 0;k < BIT_WIDTH*N;k = k + 1) //only set lower 3 bit, otherwise may overflow
                begin
                   list[k] <= $random();
                   enable <= 0;
                end                          
        end
    end
     
	
endmodule

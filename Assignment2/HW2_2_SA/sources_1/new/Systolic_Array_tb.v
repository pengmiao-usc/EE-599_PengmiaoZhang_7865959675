`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2020 09:37:11 PM
// Design Name: 
// Module Name: Systolic_Array_tb
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


module Systolic_Array_tb;
    parameter	BIT_WIDTH	=	8;
    parameter   N = 16;

	reg						clk;
	reg 					reset;
	reg                     enable;
	reg	    [BIT_WIDTH-1:0] A_mat [0:N-1][0:N-1];
	reg     [BIT_WIDTH-1:0] B_mat [0:N-1][0:N-1];
	reg     [BIT_WIDTH-1:0] C_mat [0:N-1][0:N-1];
	
	reg     [BIT_WIDTH-1:0] A_mat_ex [0:N-1][0:2*N-2];
	reg     [BIT_WIDTH-1:0] B_mat_ex [0:2*N-2][0:N-1];
	
	wire     [BIT_WIDTH*N*N-1:0] C_out;
	reg     [BIT_WIDTH*N-1:0] A_in;
	reg     [BIT_WIDTH*N-1:0] B_in;
	
	integer k;
	integer j;
	integer i;
	integer count;

    reg [2:0] state;
    
    localparam
    INI=3'b001,
    CALC=3'b010,
    END=3'b100;
    
	always @(posedge clk) begin
        if(reset == 1)
        begin
            count=0;
            for (k = 0;k < N;k = k + 1) begin
                for (j = 0;j < N;j = j + 1) begin
                    //for(i)
                        begin // initiate matrices
                       //    A_mat[k][j][BIT_WIDTH-1:0] <= $random();//$urandom_range(0,10);
                       //    B_mat[k][j][BIT_WIDTH-1:0] <= $random();//$urandom_range(0,10);
                             A_mat[k][j][BIT_WIDTH-1:0] <= $urandom_range(0,10);
                             B_mat[k][j][BIT_WIDTH-1:0] <= $urandom_range(0,10);
                          // enable <= 0;
                        end                         
                end
            end
            for (k = 0;k < 2*N-1;k = k + 1) begin
                for (j = 0;j < N;j = j + 1) begin
                         A_mat_ex[j][k][BIT_WIDTH-1:0] <= 0;
                         B_mat_ex[k][j][BIT_WIDTH-1:0] <= 0;
                      //   A_in[BIT_WIDTH*N-1:0] <=0;
                      //   B_in[BIT_WIDTH*N-1:0] <=0;                      
                end
            end
            state<=INI;
        end
        else
        begin
            case(state)
                INI:
                    begin
                        for (i = 0;i < N;i = i + 1) begin
                            for(k = 0;k < N;k = k + 1) begin
                                A_mat_ex[i][i+k][BIT_WIDTH-1:0]<=A_mat[i][k][BIT_WIDTH-1:0];
                                B_mat_ex[i+k][i][BIT_WIDTH-1:0]<=B_mat[k][i][BIT_WIDTH-1:0];
                            end
                        end
                        
                        state<=CALC;
                    end
                CALC:
                    begin
                    //    if(count==1)
                     //   enable<=1;
                        for(i=0;i<N;i=i+1)begin
                            for(k = 0;k < BIT_WIDTH;k = k + 1) begin
                                A_in[i*BIT_WIDTH+k]<=A_mat_ex[i][count][k];
                                B_in[i*BIT_WIDTH+k]<=B_mat_ex[count][i][k];
                       //     B_in[(i+1)*BIT_WIDTH-1:i*BIT_WIDTH]<=B_mat_ex[count][i][BIT_WIDTH-1:0];
                            end
                        end
                        count<=count+1;
                        state<=CALC;
                        if (count>2*N-2)
                            state<=END;
                    end
                 END:
                    begin
                    A_in<=0;
                    B_in<=0;
                    state<=END;
                    end
             endcase
        end       
    end
	
	
	
		
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
		#1000;
	end
	
	Systolic_Array#(
	.BIT_WIDTH(BIT_WIDTH),
	.N(N))
	SA(
	.clk(clk),
	.reset(reset),
	.enable(enable),
	.A(A_in),
	.B(B_in),
	.C(C_out)
	);
		/*
module Systolic_Array#(
    parameter BIT_WIDTH = 8,//k
    parameter N=4
    )
    (
    input clk,
    input [BIT_WIDTH*N-1:0] A,
    input [BIT_WIDTH*N-1:0] B
//    output [BIT_WIDTH*N-1:0] C
    );*/
endmodule

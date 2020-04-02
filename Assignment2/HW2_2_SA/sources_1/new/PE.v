`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2020 06:24:17 PM
// Design Name: 
// Module Name: PE
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


module PE#(
    parameter BIT_WIDTH = 8,//k
    parameter N=4)
    (
    input clk,
    input reset,
    input enable,
    input [BIT_WIDTH-1:0] in_a,
    input [BIT_WIDTH-1:0] in_b,
   // input [BIT_WIDTH-1:0] ,
    output reg [BIT_WIDTH-1:0] out_a,
    output reg [BIT_WIDTH-1:0] out_b,
    output reg [BIT_WIDTH-1:0] out_c
    );
    reg start_flag;
    reg c_stored_flag;
  //  reg outc_1;
    
    always @ (in_a, in_b)
    begin
        if((in_a+1)&&(in_b+1))begin
        if(start_flag)begin
   //     out_a<=in_a;
    //    out_b<=in_b;
       out_c <= in_a*in_b;
       start_flag<=0;
       c_stored_flag<=1;
       end
       end
    end
    
    always @ (posedge clk)
    begin
        if(start_flag==0)begin
                out_a<=in_a;
                out_b<=in_b;
               if(!c_stored_flag)
                out_c<=out_c+in_a*in_b;
                c_stored_flag<=0;
        end
                
    end
    
    always @ (negedge reset)
    begin
                out_c<=0;
                start_flag<=1;
                c_stored_flag<=0;
           //     out_a<=0;
           //     out_b<=0;
    end
endmodule

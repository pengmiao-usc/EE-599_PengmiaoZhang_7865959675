`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2020 11:56:19 PM
// Design Name: 
// Module Name: Compare_and_Swap
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


module Compare_and_Swap #(
    parameter BIT_WIDTH = 8 
    )
(
    input clk,
    input  [BIT_WIDTH-1:0] a,
    input  [BIT_WIDTH-1:0] b,
    output reg [BIT_WIDTH-1:0] big,
    output reg [BIT_WIDTH-1:0] sme
 );
 
// always@(posedge clk)
// begin
//                big <= b;
//                sme <= a;
// end
generate
     begin
       always @(posedge clk)
        begin
            if (a < b)
            begin
                big <= b;
                sme <= a;
            end
            else
            begin
                big <= a;
                sme <= b;
            end
           // big <= a_is_bigger ? a : b;
           // sme <= a_is_bigger ? b : a;      
        end
    end
endgenerate

endmodule   

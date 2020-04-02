`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2020 09:37:17 PM
// Design Name: 
// Module Name: MUX
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


module MUX#(    
    parameter BIT_WIDTH = 8,//k
    parameter N=8)
    (
    input [BIT_WIDTH-1:0] IN_0,
    input [BIT_WIDTH-1:0] IN_1,
    input SELECT,
    output [BIT_WIDTH-1:0] OUT
    );
    assign OUT = (SELECT)?IN_1:IN_0;
    
endmodule

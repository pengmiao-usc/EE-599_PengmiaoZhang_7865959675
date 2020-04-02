`timescale 1ns / 1ps

module Layer#(    
    parameter BIT_WIDTH = 8,//k
    parameter N=8,
    parameter LAYER=0)
    (
    input clk,
    input [BIT_WIDTH*N-1:0] IN,
    input [$clog2(N)-1:0] Shift_I,
    output reg [BIT_WIDTH*N-1:0] OUT,
    output reg [$clog2(N)-1:0] Shift_O
    );
    wire [BIT_WIDTH*N-1:0] OUT1;
   // wire offset= 2**(LAYER);
    wire [BIT_WIDTH-1:0] IN0_arr [0:N-1];
    wire [BIT_WIDTH-1:0] IN1_arr [0:N-1];
    wire [BIT_WIDTH-1:0] OUT_arr [0:N-1];

    genvar m;
    generate
    for(m=0;m<N;m=m+1) begin
        assign IN0_arr[m]= IN[(m+1)*BIT_WIDTH-1:m*BIT_WIDTH]; //first line
        if((m+2**(LAYER))< N)begin
            assign IN1_arr[m+2**(LAYER)]= IN[(m+1)*BIT_WIDTH-1:m*BIT_WIDTH];
        end
        else begin
            assign IN1_arr[m+2**(LAYER)-N]= IN[(m+1)*BIT_WIDTH-1:m*BIT_WIDTH];
        end
        
    end
    endgenerate

    genvar i;
    generate
        for (i=0;i<N;i=i+1)begin
             MUX#(
            .BIT_WIDTH (BIT_WIDTH),//k
            .N(N))
            MUX1(
            .IN_0(IN0_arr[i]),
            .IN_1(IN1_arr[i]),
            .SELECT(Shift_I[LAYER]),
            .OUT(OUT1[(i+1)*BIT_WIDTH-1:i*BIT_WIDTH])
            );
            assign OUT_arr[i]=OUT1[(i+1)*BIT_WIDTH-1:i*BIT_WIDTH];
        end
     endgenerate
     
    always @(posedge clk)
    begin
        OUT <= OUT1;
        Shift_O<=Shift_I;
    end
//wire [BIT_WIDTH-1:0] w    [0:N*(N+1)-1];
/*
    genvar m;
    generate
    for(m=0;m<N;m=m+1) begin
        assign IN0_arr[m]= IN[(m+1)*BIT_WIDTH-1:m*BIT_WIDTH]; //first line
        assign IN1_arr[m]= IN[(m+1)*BIT_WIDTH-1:m*BIT_WIDTH];
    end
    endgenerate
*/


    /*
    MUX#(
    .BIT_WIDTH (8),//k
    .N(8))
    MUX1(
    .IN_0(IN[BIT_WIDTH-1:0]),
    .IN_1(IN[BIT_WIDTH*2-1:BIT_WIDTH]),
    .SELECT(select),
    .OUT(OUT)
    );
    */
    
endmodule
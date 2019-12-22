`include "lib/hvsync_generator.v"

module video_scaler #(
    parameter FACTOR = 4
)(
    input clk, 
    input reset, 
    output hsync, 
    output vsync, 
    output display_on, 
    output [9-$clog2(FACTOR):0] hpos, 
    output [8-$clog2(FACTOR):0] vpos);

    wire [9:0] hpos_abs;
    wire [8:0] vpos_abs;

    assign hpos = hpos_abs[9:$clog2(FACTOR)];
    assign vpos = vpos_abs[8:$clog2(FACTOR)];    

    hvsync_generator vga(
        .clk (clk),
        .reset (reset), 
        .hsync (hsync), 
        .vsync (vsync), 
        .display_on (display_on), 
        .hpos (hpos_abs), 
        .vpos (vpos_abs)
    );
endmodule

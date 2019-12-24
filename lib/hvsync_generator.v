/*  VESA Signal 1280 x 1024 @ 60 Hz timing (positive sync) 

    parameter H_DISPLAY     = 1280;  // horizontal display width
    parameter H_BACK        =  248;  // horizontal left border (back porch)
    parameter H_FRONT       =   48;  // horizontal right border (front porch)
    parameter H_SYNC        =  112;  // horizontal sync width
    parameter V_DISPLAY     = 1024;  // vertical display height
    parameter V_TOP         =   38;  // vertical top border
    parameter V_BOTTOM      =    1;  // vertical bottom border
    parameter V_SYNC        =    3;  // vertical sync # lines
    parameter SYNC_POL      =    0; // 1 = Negative, 0 = Positive
*/

module hvsync_generator #(
    parameter H_DISPLAY = 640, // horizontal display width
    parameter H_BACK    =  48, // horizontal left border (back porch)
    parameter H_FRONT   =  16, // horizontal right border (front porch)
    parameter H_SYNC    =  96, // horizontal sync width
    parameter V_DISPLAY = 480, // vertical display height
    parameter V_TOP     =  33, // vertical top border
    parameter V_BOTTOM  =  10, // vertical bottom border
    parameter V_SYNC    =   2, // vertical sync # lines
    parameter SYNC_POL  =   1  // 1 = Negative, 0 = Positive
)(
    input clk, 
    input reset, 
    output reg hsync, 
    output reg vsync, 
    output display_on, 
    output reg [9:0] hpos, 
    output reg [8:0] vpos);

    localparam H_SYNC_START = H_DISPLAY + H_FRONT;
    localparam H_SYNC_END   = H_DISPLAY + H_FRONT + H_SYNC - 1;
    localparam H_MAX        = H_DISPLAY + H_BACK + H_FRONT + H_SYNC - 1;
    localparam V_SYNC_START = V_DISPLAY + V_BOTTOM;
    localparam V_SYNC_END   = V_DISPLAY + V_BOTTOM + V_SYNC - 1;
    localparam V_MAX        = V_DISPLAY + V_TOP + V_BOTTOM + V_SYNC - 1;

    wire hsync_region = (hpos >= H_SYNC_START && hpos <= H_SYNC_END);
    wire vsync_region = (vpos >= V_SYNC_START && vpos <= V_SYNC_END);
    wire hmaxxed = (hpos == H_MAX) || reset;	
    wire vmaxxed = (vpos == V_MAX) || reset;	

    assign display_on = (hpos < H_DISPLAY) && (vpos < V_DISPLAY);
    
    always @(posedge clk) begin
        if (SYNC_POL) hsync <= ~hsync_region;
        else hsync <= hsync_region;
        hpos <= hmaxxed ? 0 : hpos + 1;
    end

    always @(posedge clk) begin
        if (SYNC_POL) vsync <= ~vsync_region;
        else vsync <= vsync_region;
        if (hmaxxed) vpos <= vmaxxed ? 0 : vpos + 1;
    end    
endmodule
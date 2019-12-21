module hvsync_generator(
    input clk, 
    input reset, 
    output reg hsync, 
    output reg vsync, 
    output display_on, 
    output reg [9:0] hpos, 
    output reg [8:0] vpos);

    parameter H_DISPLAY     = 640; // horizontal display width
    parameter H_BACK        =  48; // horizontal left border (back porch)
    parameter H_FRONT       =  16; // horizontal right border (front porch)
    parameter H_SYNC        =  96; // horizontal sync width
    parameter V_DISPLAY     = 480; // vertical display height
    parameter V_TOP         =  33; // vertical top border
    parameter V_BOTTOM      =  10; // vertical bottom border
    parameter V_SYNC        =   2; // vertical sync # lines
    parameter SYNC_POL      =   1; // 1 = Negative, 0 = Positive

    /* VESA Signal 1280 x 1024 @ 60 Hz timing (positive sync) 

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

    localparam H_SYNC_START = H_DISPLAY + H_FRONT;
    localparam H_SYNC_END   = H_DISPLAY + H_FRONT + H_SYNC - 1;
    localparam H_MAX        = H_DISPLAY + H_BACK + H_FRONT + H_SYNC - 1;
    localparam V_SYNC_START = V_DISPLAY + V_BOTTOM;
    localparam V_SYNC_END   = V_DISPLAY + V_BOTTOM + V_SYNC - 1;
    localparam V_MAX        = V_DISPLAY + V_TOP + V_BOTTOM + V_SYNC - 1;

    wire hmaxxed = (hpos == H_MAX) || reset;	// set when hpos is maximum
    wire vmaxxed = (vpos == V_MAX) || reset;	// set when vpos is maximum
    
    // horizontal position counter
    always @(posedge clk)
    begin
        hsync <= (hpos >= H_SYNC_START && hpos <= H_SYNC_END) ^ SYNC_POL;
        hpos <= hmaxxed ? 0 : hpos + 1;
    end

    // vertical position counter
    always @(posedge clk)
    begin
        vsync <= (vpos >= V_SYNC_START && vpos <= V_SYNC_END) ^ SYNC_POL;
        if (hmaxxed) vpos <= vmaxxed ? 0 : vpos + 1;
    end
    
    // display_on is set when beam is in "safe" visible frame
    assign display_on = (hpos < H_DISPLAY) && (vpos < V_DISPLAY);
endmodule
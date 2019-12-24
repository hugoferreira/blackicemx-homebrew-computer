`include "lib/video_scaler.v"
`include "lib/hex_font.v"

module videotext #(
    parameter A = 10,
    parameter D = 8
  ) (
    input  clk, 
    input  [D-1:0] dout,
    output [A-1:0] vaddr,
    output hsync, 
    output vsync, 
    output pixel
  );

  wire [7:0] hpos; 
  wire [6:0] vpos;
  wire display_on;

  video_scaler vga (
    .clk (~clk),
    .reset (1'b0), 
    .hsync (hsync), 
    .vsync (vsync), 
    .display_on (display_on), 
    .hpos (hpos), 
    .vpos (vpos)
  );

  wire [9:0] vaddr = (hpos >> 2) + ((vpos >> 3) * 'd40);
  wire [3:0] bits;

  digits_to_bitmap decoder(
    .digit(dout),
    .line(vpos[2:0]),
    .bits(bits)
  ); 

  wire pixel = (bits[~hpos[2:0]]) && display_on;
endmodule
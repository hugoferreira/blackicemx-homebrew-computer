`include "lib/video_scaler.v"
`include "lib/ascii_to_bitmap.v"

module videotext #(
    parameter COLUMNS = 40,
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

  wire [9:0] vaddr = (hpos >> 2) + ((vpos >> 3) * COLUMNS);
  wire [3:0] bits;

  ascii_to_bitmap font(
    .clk(clk),
    .digit(dout),
    .line(vpos[2:0]),
    .bits(bits)
  ); 

  // The whitespace in the end of the font is allowing us the necessary cycles
  // to display the font from memory without artifacts, at the cost of a slight 
  // misaslignment. But, for an 8x8 font to work, we would need proper 
  // pipelining of RAM access.
  wire pixel = bits[4-hpos[3:0]] & display_on;
endmodule
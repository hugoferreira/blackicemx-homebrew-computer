`include "hvsync_generator.v"
`include "seven_segment.v"

module chip (input clk, output hsync, output vsync, output rgb);
  assign rgb = pixel & display_on;

  wire pixel;
  wire [9:0] hpos; 
  wire [8:0] vpos;

  hvsync_generator vga(
    .clk (clk),
    .reset (1'b0), 
    .hsync (hsync), 
    .vsync (vsync), 
    .display_on (display_on), 
    .hpos (hpos), 
    .vpos (vpos)
  );

  wire [3:0] digit = vpos[6:3];
  wire [2:0] xofs = hpos[2:0];
  wire [2:0] yofs = vpos[2:0];
  wire [4:0] bits;
  wire [6:0] segments;
  
  seven_segment_decoder decoder(
    .digit(digit),
    .segments(segments)
  );
  
  segments_to_bitmap numbers(
    .segments(segments),
    .line(yofs),
    .bits(bits)
  );

  assign pixel = bits[xofs] & hpos[3:0] < 5;
endmodule

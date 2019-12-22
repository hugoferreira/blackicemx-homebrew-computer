`include "lib/hvsync_generator.v"
`include "lib/seven_segment.v"

module chip (input clk, output hsync, output vsync, output rgb);
  assign rgb = pixel & display_on & (vpos_abs >= voffset) & (hpos_abs >= hoffset);

  localparam voffset = 2;
  localparam hoffset = 2;

  wire pixel;
  wire [8:0] vpos_abs;
  wire [9:0] hpos_abs;
  wire [9:0] hpos = (hpos_abs < hoffset) ? 0 : (hpos_abs - hoffset); 
  wire [8:0] vpos = (vpos_abs < voffset) ? 0 : (vpos_abs - voffset);

  hvsync_generator vga(
    .clk (clk),
    .reset (1'b0), 
    .hsync (hsync), 
    .vsync (vsync), 
    .display_on (display_on), 
    .hpos (hpos_abs), 
    .vpos (vpos_abs)
  );

  wire [3:0] digit = vpos >> 3;
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

  assign pixel = (bits[xofs] & hpos[3:0] < 5); /* |
                 (hpos == 0) | (vpos == 0) | 
                 (hpos == 639) | (vpos == 479); */

endmodule

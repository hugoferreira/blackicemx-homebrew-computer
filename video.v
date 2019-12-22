`include "lib/video_scaler.v"
`include "lib/hex_font.v"

module chip (input clk, output hsync, output vsync, output rgb);
  assign rgb = pixel & display_on;

  wire [7:0] hpos; 
  wire [6:0] vpos;

  video_scaler vga (
    .clk (clk),
    .reset (1'b0), 
    .hsync (hsync), 
    .vsync (vsync), 
    .display_on (display_on), 
    .hpos (hpos), 
    .vpos (vpos)
  );

  wire [3:0] digit = hpos >> 2;
  wire [2:0] xofs = hpos[2:0];
  wire [2:0] yofs = vpos[2:0];
  wire [3:0] bits;
  
  digits_to_bitmap decoder(
    .digit(digit),
    .line(yofs),
    .bits(bits)
  ); 

  wire pixel = (bits[~xofs]);
          // | (hpos == 0) | (vpos == 0) 
          // | (hpos == 639) | (vpos == 479); 
endmodule

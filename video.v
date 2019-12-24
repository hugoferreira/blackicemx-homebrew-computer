`include "lib/videotext.v"
`include "lib/text_ram.v"

module chip (input clk, output hsync, output vsync, output rgb);
  wire [7:0] dout;
  wire [7:0] din;
  wire [9:0] vaddr;

  videotext vtext(
    .clk (clk), 
    .dout (dout),
    .vaddr (vaddr),
    .hsync (hsync), 
    .vsync (vsync), 
    .pixel (rgb)
  );

  text_ram vram(
    .clk (clk),
    .we (1'b0),
    .addr (vaddr),
    .din (din), 
    .dout (dout)
  );
endmodule

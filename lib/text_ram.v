module text_ram #(
    parameter A = 10,
    parameter D = 8
  ) (
    input  clk,
    input  we,
    input  [A-1:0] addr,
    input  [D-1:0] din,
    output reg [D-1:0] dout
  );

  reg [D-1:0] vram [0:(1<<A)-1];   // 2^A memory spaces of D bits

  initial
    $readmemh("lib/video.hex", vram, 0, 1024);

  always @(posedge clk) begin
    if (we) vram[addr] <= din;
    dout <= vram[addr];
  end
endmodule
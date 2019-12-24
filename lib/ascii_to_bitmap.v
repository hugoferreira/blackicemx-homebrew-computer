module ascii_to_bitmap #(
    parameter FONT_ROM_FILENAME = "lib/pico8-hexadecimal.hex")  
   (input clk,
    input [7:0] digit,
    input [2:0] line,
    output reg [3:0] bits);

    reg [3:0] font [0:2048];

    initial
        $readmemh(FONT_ROM_FILENAME, font);

    always @(posedge clk) 
        bits <= font[{ digit, line }];
endmodule
module digits_to_bitmap #(
    parameter FONT_ROM_FILENAME = "lib/pico8-hexadecimal.hex")  
   (input [3:0] digit,
    input [2:0] line,
    output reg [3:0] bits);

    reg [3:0] font [0:127];

    initial
        $readmemh(FONT_ROM_FILENAME, font);

    always @(*) 
        bits = font[{ digit, line }];
endmodule
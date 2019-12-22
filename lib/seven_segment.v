module seven_segment_decoder(
    input [3:0] digit,
    output reg [6:0] segments);

    reg [6:0] map [0:15];
    
    initial
        $readmemh("lib/segments.hex", map);
    
    always @(*) 
        segments = map[digit];
endmodule

module digits_to_bitmap(
    input [3:0] digit,
    input [2:0] line,
    output reg [4:0] bits);

    reg [4:0] font [0:127];

    initial
        $readmemh("lib/pico8.font.hex", font);

    always @(*) 
        bits = font[{ digit, line }];
endmodule

module segments_to_bitmap(
  input [6:0] segments,
  input [2:0] line,
  output reg [4:0] bits);

  always @(*)
    case (line)
      0: bits = (segments[6] ? 5'b11111 : 0) 
              ^ (segments[5] ? 5'b10000 : 0) 
              ^ (segments[1] ? 5'b00001 : 0);

      1: bits = (segments[1] ? 5'b00001 : 0) 
              ^ (segments[5] ? 5'b10000 : 0);

      2: bits = (segments[0] ? 5'b11111 : 0) 
              ^ (|segments[5:4] ? 5'b10000 : 0) 
              ^ (|segments[2:1] ? 5'b00001 : 0);

      3: bits = (segments[2] ? 5'b00001 : 0) 
              ^ (segments[4] ? 5'b10000 : 0);

      4: bits = (segments[3] ? 5'b11111 : 0) 
              ^ (segments[4] ? 5'b10000 : 0) 
              ^ (segments[2] ? 5'b00001 : 0);
      default: bits = 0;
    endcase  
endmodule
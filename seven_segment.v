module seven_segment_decoder(
  input [3:0] digit,
  output reg [6:0] segments);

  always @(*)
    case(digit)
      0: segments = 7'b1111110;
      1: segments = 7'b0110000;
      2: segments = 7'b1101101;
      3: segments = 7'b1111001;
      4: segments = 7'b0110011;
      5: segments = 7'b1011011;
      6: segments = 7'b1011111;
      7: segments = 7'b1110000;
      8: segments = 7'b1111111;
      9: segments = 7'b1111011;
      default: segments = 7'b0000000;
    endcase  
endmodule

module segments_to_bitmap(
  input [6:0] segments,
  input [2:0] line,
  output reg [4:0] bits);

  always @(*)
    case (line)
      0:bits = (segments[6] ? 5'b11111:0) 
             ^ (segments[5] ? 5'b10000:0) 
             ^ (segments[1] ? 5'b00001:0);

      1:bits = (segments[1] ? 5'b00001:0) 
             ^ (segments[5] ? 5'b10000:0);

      2:bits = (segments[0] ? 5'b11111:0) 
             ^ (|segments[5:4] ? 5'b10000:0) 
             ^ (|segments[2:1] ? 5'b00001:0);

      3:bits = (segments[2] ? 5'b00001:0) 
             ^ (segments[4] ? 5'b10000:0);

      4:bits = (segments[3] ? 5'b11111:0) 
             ^ (segments[4] ? 5'b10000:0) 
             ^ (segments[2] ? 5'b00001:0);
      default: bits = 0;
    endcase  
endmodule
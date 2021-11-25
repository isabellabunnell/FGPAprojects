// seg7 takes in a 4-bit value for bcd and outputs a 7-bit value for leds, which correspond to the decimal representation of the bcd binary number on a HEX display.
module seg7 (bcd, leds);
	input logic [3:0] bcd;
	output logic [6:0] leds;
	
	always_comb begin 	case 
	(bcd)
	// 					Light: 6543210
	4'b0000: leds = 7'b1000000; // 0
	4'b0001: leds = 7'b1111001; // 1
	4'b0010: leds = 7'b0100100; // 2
	4'b0011: leds = 7'b0110000; // 3
	4'b0100: leds = 7'b0011001; // 4
	4'b0101: leds = 7'b0010010; // 5
	4'b0110: leds = 7'b0000010; // 6
	4'b0111: leds = 7'b1111000; // 7
	4'b1000: leds = 7'b0000000; // 8
	4'b1001: leds = 7'b0010000; // 9
   endcase
	end
endmodule
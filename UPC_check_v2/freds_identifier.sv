// freds_identifier takes in a 4-bit value for bcd and outputs a 7-bit value for leds5, leds4, leds3, leds2, leds1  and leds0
// which correspond to an alphebetical representation of an item on each HEX display.
module freds_identifier (bcd, leds5, leds4, leds3, leds2, leds1, leds0);
	input logic [3:0] bcd;
	output logic [6:0] leds5, leds4, leds3, leds2, leds1, leds0;
	
	always_comb begin 	
	case (bcd)
	// 					Light: 6543210
	4'b0000: begin
				leds5 = 7'b0010010; //S
				leds4 = 7'b0001011; //H
				leds3 = 7'b1000000; //O
				leds2 = 7'b0000110; //E
				leds1 = 7'b1111111;
				leds0 = 7'b1111111;
				end
	
	4'b0001: begin
				leds5 = 7'b0001100; //P
				leds4 = 7'b0000110; //E
				leds3 = 7'b0101011; //n
				leds2 = 7'b1111111;
				leds1 = 7'b1111111;
				leds0 = 7'b1111111;
				end
	
	4'b0011: begin
				leds5 = 7'b1000110; //C
				leds4 = 7'b0010001; //y
				leds3 = 7'b1000110; //C
				leds2 = 7'b1000111; //L
				leds1 = 7'b0000110; //E
				leds0 = 7'b1111111;
				end
	
	4'b0100: begin
				leds5 = 7'b0010010; //S
				leds4 = 7'b1100011; //u
				leds3 = 7'b1101111; //I
				leds2 = 7'b0000111; //t
				leds1 = 7'b1111111;
				leds0 = 7'b1111111;
				end
	
	4'b0101: begin
				leds5 = 7'b1000110; //C
				leds4 = 7'b1000000; //O
				leds3 = 7'b0001000; //A
				leds2 = 7'b0000111; //t
				leds1 = 7'b1111111;
				leds0 = 7'b1111111;
				end
	
	4'b0110: begin
				leds5 = 7'b0101111; //r
				leds4 = 7'b0000110; //E
				leds3 = 7'b1000110; //C
				leds2 = 7'b1000000; //O
				leds1 = 7'b0101111; //r
				leds0 = 7'b0100001; //D
				end
	
	// when not any of the above cases, the HEX lights are driven off.
	default: begin
				leds5 = 7'b1111111;
				leds4 = 7'b1111111;
				leds3 = 7'b1111111;
				leds2 = 7'b1111111;
				leds1 = 7'b1111111;
				leds0 = 7'b1111111;
				end
	endcase
	end
endmodule
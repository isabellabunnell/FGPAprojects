// initialFrame takes in a 1-bit signal for whether the output should be random and a 2-bit
// signal for a preloaded pattern choice, where the logic for what is currently outputted replicates
// the logic from the initialFrame module. The output is an short phrase intended for the HEX displays 
// in 5 7-bit signals.
module display (random, pattern, leds5, leds4, leds3, leds2, leds1, leds0);
	input logic random;
	input logic [1:0] pattern;
	output logic [6:0] leds5, leds4, leds3, leds2, leds1, leds0;
	
	always_comb begin 	
		// 			Light: 6543210
		if (random) begin
						leds5 = 7'b0101111; //r
						leds4 = 7'b0001000; //A
						leds3 = 7'b0101011; //n
						leds2 = 7'b0100001; //D
						leds1 = 7'b1111111;
						leds0 = 7'b1111111;
		end
		else begin
			if (pattern == 2'b01) begin
					leds5 = 7'b0000011; //b
					leds4 = 7'b0000110; //E
					leds3 = 7'b0000110; //E
					leds2 = 7'b1111111;
					leds1 = 7'b1111111;
					leds0 = 7'b1111111;
					end
		
			else if (pattern == 2'b10) begin
					leds5 = 7'b0000111; //t
					leds4 = 7'b1000000; //O
					leds3 = 7'b0001000; //A
					leds2 = 7'b0100001; //D
					leds1 = 7'b1111111;
					leds0 = 7'b1111111;
					end
		
			else begin
					leds5 = 7'b0010010; //S
					leds4 = 7'b0001011; //H
					leds3 = 7'b1101111; //I
					leds2 = 7'b0001100; //P
					leds1 = 7'b1111111;
					leds0 = 7'b1111111;
					end
		end
	end
endmodule
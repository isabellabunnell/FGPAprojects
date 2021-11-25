// initialFrame takes in a 1-bit signal for whether the output should be random, a 2-bit
// signal for a preloaded pattern choice, a 32-bit sequence that is randombly generated (LFSRval),
// and outputs a 16x16 sequence that  gets used as an initial starting pattern for Conway's Game of Life.
module initialFrame(random, patternChoice, LFSRval, initPixels);
	input logic random;
	input logic [1:0] patternChoice;
	input logic [31:0] LFSRval;
	output logic [15:0][15:0] initPixels;
	
	always_comb begin
		if (random) begin
			for (integer i = 0; i < 16; i++) begin // way of randomly choosing a configuration for the cells
				initPixels[i] = {LFSRval[(i + 7)],
									  LFSRval[(i + 7)-1],
									  LFSRval[(i + 7)+1], 
									  LFSRval[(i + 7)-2],
									  LFSRval[(i + 7)+2],
									  LFSRval[(i + 7)-3],
									  LFSRval[(i + 7)+3],
									  LFSRval[(i + 7)-4],
									  LFSRval[(i + 7)+4],
									  LFSRval[(i + 7)-5],
									  LFSRval[(i + 7)+5],
									  LFSRval[(i + 7)-6],
									  LFSRval[(i + 7)+6],
									  LFSRval[(i + 7)-7],
									  LFSRval[(i + 7)+7]};
			end
		end
		
		else begin
			if (patternChoice == 2'b01) begin 
				// beehive
				initPixels[0]  = 16'b0000000000000000;
				initPixels[1]  = 16'b0000000000000000;
				initPixels[2]  = 16'b0000000000000000;
				initPixels[3]  = 16'b0000000000000000;
				initPixels[4]  = 16'b0000000000000000;
				initPixels[5]  = 16'b0000000000000000;
				initPixels[6]  = 16'b0000000000000000;
				initPixels[7]  = 16'b0000000110000000;
				initPixels[8]  = 16'b0000001001000000;
				initPixels[9]  = 16'b0000000110000000;
				initPixels[10] = 16'b0000000000000000;
				initPixels[11] = 16'b0000000000000000;
				initPixels[12] = 16'b0000000000000000;
				initPixels[13] = 16'b0000000000000000;
				initPixels[14] = 16'b0000000000000000;
				initPixels[15] = 16'b0000000000000000;
			end
			else if (patternChoice == 2'b10) begin
				// two period toad
				initPixels[0]  = 16'b0000000000000000;
				initPixels[1]  = 16'b0000000000000000;
				initPixels[2]  = 16'b0000000000000000;
				initPixels[3]  = 16'b0000000000000000;
				initPixels[4]  = 16'b0000000000000000;
				initPixels[5]  = 16'b0000000000000000;
				initPixels[6]  = 16'b0000000000000000;
				initPixels[7]  = 16'b0000000111000000;
				initPixels[8]  = 16'b0000001110000000;
				initPixels[9]  = 16'b0000000000000000;
				initPixels[10] = 16'b0000000000000000;
				initPixels[11] = 16'b0000000000000000;
				initPixels[12] = 16'b0000000000000000;
				initPixels[13] = 16'b0000000000000000;
				initPixels[14] = 16'b0000000000000000;
				initPixels[15] = 16'b0000000000000000;
			end
			else begin
				// middleweight spaceship
				initPixels[0]  = 16'b0000000000000000;
				initPixels[1]  = 16'b0000000000000000;
				initPixels[2]  = 16'b0000000000000000;
				initPixels[3]  = 16'b0000000000000000;
				initPixels[4]  = 16'b0000000000000000;
				initPixels[5]  = 16'b0000000000000000;
				initPixels[6]  = 16'b0000000100000000;
				initPixels[7]  = 16'b0000010001000000;
				initPixels[8]  = 16'b0000000000100000;
				initPixels[9]  = 16'b0000010000100000;
				initPixels[10] = 16'b0000001111100000;
				initPixels[11] = 16'b0000000000000000;
				initPixels[12] = 16'b0000000000000000;
				initPixels[13] = 16'b0000000000000000;
				initPixels[14] = 16'b0000000000000000;
				initPixels[15] = 16'b0000000000000000;
			end
		end
	end
	
endmodule
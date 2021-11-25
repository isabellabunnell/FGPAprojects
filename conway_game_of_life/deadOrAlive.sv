// This module takes in a clock, reset and load signal as well as an initial pixel value
// and an 8 bit value that corresponds to the cell's neighbors, and whether they are alive or not.
// the output is a 1-bit value for whether the cell is alive or dead.
module deadOrAlive (clk, reset, load, initialPixel, neighbors, alive);
	input logic clk, reset, load;
	input logic initialPixel;
	input logic [7:0] neighbors;
	output logic alive;
	
	integer neighborCount;
	
	always_comb begin // count how many neighbors are alive
		neighborCount = neighbors[0]+neighbors[1]+neighbors[2]+neighbors[3]+neighbors[4]+neighbors[5]+neighbors[6]+neighbors[7];
	end
	
	enum {S0, S1} ps, ns; // Present state, next state

	//Next state logic
	always_comb begin
		case (ps)
			S0: if (~initialPixel && load) ns = S0;
				 else if (neighborCount == 3 || (initialPixel && load)) ns = S1;
				 else ns = S0;
			S1: if (~initialPixel && load) ns = S0;
				 else if (neighborCount == 2 || neighborCount == 3 || (initialPixel && load)) ns = S1;
				 else ns = S0;
		endcase
	end
			
	always_comb begin	
		case(ps)
			 S0: alive = 1'b0; // dead
			 S1: alive = 1'b1; // alive
			 default: alive = 1'b0;
		endcase
	end
	
	//sequential logic (DFFs)
	always_ff @(posedge clk) begin
		if (reset)
			ps <= S0;
		else
			ps <= ns;
	end	
	
endmodule

// testbench module for deadOrAlive. Expected output is commented.
module deadOrAlive_testbench();

	logic clk, reset, load, initialPixel, alive;
	logic [7:0] neighbors;
	
	deadOrAlive dut (.clk, .reset, .load, .initialPixel, .neighbors, .alive);
	
	//clock setup
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
				
	end
	
	initial begin
		reset <= 0; load <=0; initialPixel<=0; neighbors<=8'b00000000; @(posedge clk); // dead
						
						load <=1; initialPixel<=1; neighbors<=8'b00000000; @(posedge clk); // alive
						load <=0; initialPixel<=0; neighbors<=8'b01010100; @(posedge clk); // alive
						load <=0; initialPixel<=0; neighbors<=8'b00100010; @(posedge clk); // alive
						load <=0; initialPixel<=0; neighbors<=8'b00000001; @(posedge clk); // dead
						
						load <=1; initialPixel<=0; neighbors<=8'b01001010; @(posedge clk); // dead
						load <=0; initialPixel<=0; neighbors<=8'b11111000; @(posedge clk); // dead
						load <=0; initialPixel<=1; neighbors<=8'b00000000; @(posedge clk); // dead
						load <=0; initialPixel<=0; neighbors<=8'b01001001; @(posedge clk); // alive
						load <=0; initialPixel<=1; neighbors<=8'b00101100; @(posedge clk); // alive
						load <=0; initialPixel<=1; neighbors<=8'b11110111; @(posedge clk); // dead
						load <=0; initialPixel<=1; neighbors<=8'b00010011; @(posedge clk); // alive
		
		reset <= 1;												  						@(posedge clk); // dead
		reset <= 0; load <=0; initialPixel<=0; neighbors<=8'b00000000; @(posedge clk); // dead
						
						load <=1; initialPixel<=1; neighbors<=8'b00000000; @(posedge clk); // alive
						load <=0; initialPixel<=0; neighbors<=8'b00000111; @(posedge clk); // alive
															neighbors<=8'b01000010; @(posedge clk); // alive
															neighbors<=8'b11111111; @(posedge clk); // dead
																							@(posedge clk);
		$stop; //end simulation							
						
	end
		
endmodule
// LFSR takes in a 1-bit clock and reset, and outputs a 10-bit sequence that acts as a random number in decimal.
module LFSR(clk, reset, out);
	input logic clk, reset;
	output logic [9:0] out;
	
	// once per clock cycle, a new random number will be generated.
	always_ff @(posedge clk) begin
		if (reset)
			out <= 10'b0000000000; //reset back to all 0's in bit sequence
		else begin
			out <= out << 1; //shift bit sequence to left
			out[0] <= ~(out[6] ^ out[9]); //according to table, XNOR the 10th and 7th index (9 and 6 accounting for 0 indexing)
		end
	end	
	
endmodule

// Testbench for LFSR. Refer to table for expected output with associated row.
module LFSR_testbench();

	logic clk, reset;
	logic [9:0] out;
	
	LFSR dut (.clk, .reset, .out);
	
	//clock setup
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
				
	end
	
	initial begin
		reset <=1;	 @(posedge clk);
		reset <=0;   @(posedge clk); //row 1
		reset <=0;   @(posedge clk); //row 2
		reset <=0;   @(posedge clk); //row 3
		reset <=0;   @(posedge clk); //row 4
		reset <=0;   @(posedge clk); //row 5
		reset <=0;   @(posedge clk); //row 6
		reset <=0;   @(posedge clk); //row 7
		reset <=0;   @(posedge clk); //row 8
		reset <=0;   @(posedge clk); //row 9
		reset <=0;   @(posedge clk); //row 10
		reset <=0;   @(posedge clk); //row 11
		reset <=0;   @(posedge clk); //row 12
		reset <=0;   @(posedge clk); //row 13
		reset <=0;   @(posedge clk); //row 14
		reset <=0;   @(posedge clk); //row 15
		reset <=0;   @(posedge clk); //row 16
		reset <=0;   @(posedge clk); //row 17
		reset <=0;   @(posedge clk); //row 18
		$stop; //end simulation							
						
	end
		
endmodule		
// LFSR takes in a 1-bit clock and reset, and outputs a 32-bit pseudorandom sequence.
module LFSR(clk, reset, out);
	input logic clk, reset;
	output logic [31:0] out;
	
	// once per clock cycle, a new random number will be generated.
	always_ff @(posedge clk) begin
		if (reset)
			out <= '0; //reset back to all 0's in bit sequence
		else begin
			out <= out << 1; //shift bit sequence to left
			out[0] <= ~(out[31] ^ out[22] ^ out[2] ^ out[1]); //according to table, XNOR index 32, 22, 2, 1 (31, 21, 1, 0 accounting for 0 indexing)
		end
	end	
	
endmodule

// Testbench for LFSR. Refer to table for expected output with associated row.
module LFSR_testbench();

	logic clk, reset;
	logic [15:0] out;
	
	LFSR dut (.clk, .reset, .out);
	
	//clock setup
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
				
	end
	
	initial begin
		reset <=1;	 @(posedge clk);
		reset <=0;   @(posedge clk);
		reset <=0;   @(posedge clk);
		reset <=0;   @(posedge clk);
		reset <=0;   @(posedge clk);
		reset <=0;   @(posedge clk);
		$stop; //end simulation							
						
	end
		
endmodule		
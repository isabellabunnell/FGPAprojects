// Comparator takes in tw 10-bit values A and B and returns a 1-bit true/false value of whether A > B.
module comparator(A, B, result);
	input logic [9:0] A, B;
	output logic result;
	
	// always keep checking and outputting the reseult for the current values of A and B
	always_comb begin
		if (A > B)
			result = 1;
		else
			result = 0;
	end
	
endmodule

// Testbench for comparator.
module comparator_testbench();

	logic [9:0] A,B;
	logic result;
	
	comparator dut (.A, .B, .result);
	
	initial begin
		// test cases:
			A=10'b0000000000; B=10'b0000000000; #10; // result = 0;
			A=10'b1111111111; B=10'b0000000000; #10; // result = 1;
			A=10'b0000000001; B=10'b0000000010; #10; // result = 0;
			A=10'b0000000010; A=10'b0000000001; #10; // result = 1;
			A=10'b0001000001; A=10'b0001000000; #10; // result = 1;
			A=10'b0001000000; A=10'b0001000001; #10; // result = 0;
	end						
		
endmodule		
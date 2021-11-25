// UPCcheck takes in a 1 bit value for U, P, C and a the secret mark and returns a 1 bit value for whether the item was
// stolen and discounted.
module UPCcheck (U, P, C, mark, discounted, stolen);
	
	input logic U, P, C, mark;
	output logic discounted, stolen;

	// Derivation for these equations shown on Lab Report 2
	assign discounted = P | (U & C);
	assign stolen = !(P | mark) & (!C | U);

endmodule

// UPCcheck_testbench tests all relevant values on the truth table (not testing "don't cares" as well as when non-expensive items have the
// secret mark).
module UPCcheck_testbench();

	logic U, P, C, mark, discounted, stolen;
	
	UPCcheck dut (U, P, C, mark, discounted, stolen);
	
		initial begin
		// test cases:
			U=1'b0; P=1'b0; C=1'b0; mark=1'b0; #10; // discounted=false, stolen=true
			U=1'b0; P=1'b0; C=1'b0; mark=1'b1; #10; // discounted=false, stolen=false
			U=1'b0; P=1'b0; C=1'b1; mark=1'b0; #10; // discounted=false, stolen=false
			U=1'b0; P=1'b1; C=1'b1; mark=1'b0; #10; // discounted=true, stolen=false
			U=1'b1; P=1'b0; C=1'b0; mark=1'b0; #10; // discounted=false, stolen=true
			U=1'b1; P=1'b0; C=1'b0; mark=1'b1; #10; // discounted=false, stolen=false
			U=1'b1; P=1'b0; C=1'b1; mark=1'b0; #10; // discounted=true, stolen=true
			U=1'b1; P=1'b0; C=1'b1; mark=1'b1; #10; // discounted=true, stolen=false
			U=1'b1; P=1'b1; C=1'b0; mark=1'b0; #10; // discounted=true, stolen=false
		end
		
endmodule
// Takes in 2 1-bit binary numbers (A and B) along with a 1-bit Carry in number (cin)
// Outputs a 1-bit sum of the numbers with a 1-bit carry out (cout) number.
module fullAdder (A,B, cin, sum, cout);

	input logic A,B, cin;
	output logic sum, cout;
	
	// minterms (derived from truth table)
	assign sum = A ^ B ^ cin;
	assign cout = A&B | cin & (A^B);

endmodule

//Test for 1-bit full adder.
module fullAdder_testbench();

		logic A, B, cin, sum, cout;
		
		fullAdder dut (A, B, cin, sum, cout);
		
		integer i;
		initial begin
		
			for(i=0; i<2**3;i++) begin
				{A, B, cin} = i; #10;
			end //for loop
		
		end //initial
		
endmodule
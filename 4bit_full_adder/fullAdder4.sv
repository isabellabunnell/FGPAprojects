// Adds two four-bit numbers together, in accordance with schematic.
// Outputs a 4 bit number that is the addition of 4 bit numbers A and B (and 1 bit number Cin) as sum,
// and a 1 bit number Cout to account for overflow. 
module fullAdder4 (A, B, cin, sum, cout);

	input logic [3:0] A;
	input logic [3:0] B;
	input logic cin;
	
	output logic [3:0] sum;
	output logic cout;
	
	logic c0, c1, c2;
	
	fullAdder FA0 (.A(A[0]), .B(B[0]), .cin(cin), .sum(sum[0]), .cout(c0));
	fullAdder FA1 (.A(A[1]), .B(B[1]), .cin(c0), .sum(sum[1]), .cout(c1));
	fullAdder FA2 (.A(A[2]), .B(B[2]), .cin(c1), .sum(sum[2]), .cout(c2));
	fullAdder FA3 (.A(A[3]), .B(B[3]), .cin(c2), .sum(sum[3]), .cout(cout));
	
endmodule

// Test for 4 bit full adder. 
module fullAdder4_testbench();

		logic [3:0] A;
		logic [3:0] B;
		logic [3:0] sum;
		logic cin;
		logic cout;
		
		fullAdder4 dut (.A, .B, .cin, .sum, .cout);
		
		initial begin
		// test cases:
			A=4'b0000; B=4'b0000; cin=1'b0; #10;// expected: sum=0000, cout=0 
			A=4'b0001; B=4'b0001; cin=1'b0; #10;// expected: sum=0010, cout=0
			A=4'b0100; B=4'b1000; cin=1'b0; #10;// expected: sum=1100, cout=0
			A=4'b0111; B=4'b0111; cin=1'b0; #10;// expected: sum=1110, cout=0
			A=4'b1111; B=4'b1111; cin=1'b0; #10;// expected: sum=1110, cout=1
			A=4'b1111; B=4'b1111; cin=1'b1; #10;// expected: sum=1111, cout=1
		end

		
endmodule
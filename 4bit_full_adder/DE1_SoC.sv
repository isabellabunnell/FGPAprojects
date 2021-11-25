// Maps a 4-bit full adder to the input switches on the DE1-SoC.
// Outputs the sum and Cout to the LEDS on the DE1-SoC.
// Assigns 7 bit values to the HEX lights to display the word ADDING.
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);

	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	fullAdder4 FA (.A(SW[4:1]), .B(SW[8:5]), .cin(SW[0]), .sum(LEDR[3:0]), .cout(LEDR[9]));
	
	// Assign all HEX lights a letter.
	assign HEX0 = 7'b0010000; //"g"
	assign HEX1 = 7'b1001000; //"n"
	assign HEX2 = 7'b1001111; //"i"
	assign HEX3 = 7'b0100001; //"d"
	assign HEX4 = 7'b0100001; //"d"
	assign HEX5 = 7'b0001000; //"A"

endmodule

// Test for DE1-SoC. 
module DE1_SoC_testbench();

	logic [5:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	
	initial begin
	SW[4:1] = 4'b0000; SW[8:5] = 4'b0000; SW[0] = 1'b0; #10;
	//expected: LEDR[3]=0, LEDR[2]=0. LEDR[1]=0, LEDR[0]=0, LEDR[9]=0
	SW[4:1] = 4'b0001; SW[8:5] = 4'b0001; SW[0] = 1'b0; #10;
	//expected: LEDR[3]=0, LEDR[2]=0. LEDR[1]=1, LEDR[0]=0, LEDR[9]=0
	SW[4:1] = 4'b0100; SW[8:5] = 4'b1000; SW[0] = 1'b0; #10;
	//expected: LEDR[3]=1, LEDR[2]=1. LEDR[1]=0, LEDR[0]=0, LEDR[9]=0
	SW[4:1] = 4'b0111; SW[8:5] = 4'b0111; SW[0] = 1'b0; #10;
	//expected: LEDR[3]=1, LEDR[2]=1. LEDR[1]=1, LEDR[0]=0, LEDR[9]=0
	SW[4:1] = 4'b1111; SW[8:5] = 4'b1111; SW[0] = 1'b0; #10;
	//expected: LEDR[3]=1, LEDR[2]=1. LEDR[1]=1, LEDR[0]=0, LEDR[9]=1
	SW[4:1] = 4'b1111; SW[8:5] = 4'b1111; SW[0] = 1'b1; #10;
	//expected: LEDR[3]=1, LEDR[2]=1. LEDR[1]=1, LEDR[0]=1, LEDR[9]=1
	end
	
endmodule
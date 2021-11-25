// DE1_SoC takes a 3-bit KEY and 10-bit SW as inputs and returs a 7-bit HEX0, HEX1, HEX2, HEX3, HEx4, HEX5 and 10-bit LEDR as outputs.
// The seven segment HEX displays are driven off, discounted T/F value is displayed on LEDR[9] and the stolen T/F value is displayed on LEDR[0].
// This serves as the top-level module for the UPC checker system implemented in Lab 2, Task 1.
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);

	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	// UPCcheck upc takes SW[9], SW[8], SW[7] and SW[0] as inputs to parameters U, P, C, and mark
	// and returns discounted and stolen as LEDR[9] and LEDR[0] respectively.
	UPCcheck upc (.U(SW[9]), .P(SW[8]), .C(SW[7]), .mark(SW[0]), .discounted(LEDR[9]), .stolen(LEDR[0]));
	
	// HEX0-HEX5 are driven off in the following assignments:
	assign HEX0 = 7'b1111111;
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;

endmodule

// DE1_SoC_testbench tests all the behavior on the truth table in the specification to verify that we are getting the correct outputs 
// should an expensive item not have a secret mark, whether the item is discounted, etc.
module DE1_SoC_testbench();

	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	
	initial begin
			SW[9]=1'b0; SW[8]=1'b0; SW[7]=1'b0; SW[0]=1'b0; #10; // LEDR[9]=false, LEDR[0]=true
			SW[9]=1'b0; SW[8]=1'b0; SW[7]=1'b0; SW[0]=1'b1; #10; // LEDR[9]=false, LEDR[0]=false
			SW[9]=1'b0; SW[8]=1'b0; SW[7]=1'b1; SW[0]=1'b0; #10; // LEDR[9]=false, LEDR[0]=false
			SW[9]=1'b0; SW[8]=1'b1; SW[7]=1'b1; SW[0]=1'b0; #10; // LEDR[9]=true, LEDR[0]=false
			SW[9]=1'b1; SW[8]=1'b0; SW[7]=1'b0; SW[0]=1'b0; #10; // LEDR[9]=false, LEDR[0]=true
			SW[9]=1'b1; SW[8]=1'b0; SW[7]=1'b0; SW[0]=1'b1; #10; // LEDR[9]=false, LEDR[0]=false
			SW[9]=1'b1; SW[8]=1'b0; SW[7]=1'b1; SW[0]=1'b0; #10; // LEDR[9]=true, LEDR[0]=true
			SW[9]=1'b1; SW[8]=1'b0; SW[7]=1'b1; SW[0]=1'b1; #10; // LEDR[9]=true, LEDR[0]=false
			SW[9]=1'b1; SW[8]=1'b1; SW[7]=1'b0; SW[0]=1'b0; #10; // LEDR[9]=true, LEDR[0]=false
	end
	
endmodule
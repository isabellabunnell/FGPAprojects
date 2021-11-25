// freds_DE1_SoC takes a 3-bit KEY and 10-bit SW as inputs and returs a 7-bit HEX0, HEX1, HEX2, HEX3, HEx4, HEX5 and 10-bit LEDR as outputs.
// The seven segment HEX displays are used to display a descripting of the object's allocated UPC code, 
// discounted T/F value is displayed on LEDR[9] and the stolen T/F value is displayed on LEDR[0].
// This serves as the top-level module for the UPC checker system implemented in Lab 2, Task 3.
module freds_DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);

	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	// freds_identifier fred takes SW[8], SW[7], SW[6] as inputs to parameter bcd and returns the assigned inputs for HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 to display on the board.
	freds_identifier fred (.bcd(SW[8:6]), .leds5(HEX5[6:0]), .leds4(HEX4[6:0]), .leds3(HEX3[6:0]), .leds2(HEX2[6:0]), .leds1(HEX1[6:0]), .leds0(HEX0[6:0]));
	// UPCcheck upc takes SW[8], SW[7], SW[6] and SW[0] as inputs to parameters U, P, C, and mark
	// and returns discounted and stolen as LEDR[9] and LEDR[0] respectively.
	UPCcheck upc (.U(SW[8]), .P(SW[7]), .C(SW[6]), .mark(SW[0]), .discounted(LEDR[9]), .stolen(LEDR[0]));

endmodule

// DE1_SoC_testbench tests all the behavior on the truth table in the specification to verify that we are getting the correct outputs 
// should an expensive item not have a secret mark, whether the item is discounted, etc.
module freds_DE1_SoC_testbench();

	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	freds_DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	
	initial begin
			SW[8]=1'b0; SW[7]=1'b0; SW[6]=1'b0; SW[0]=1'b0; #10; // LEDR[9]=false, LEDR[0]=true
		                                                        // HEX5 = 7'b0010010; //S
																				  // HEX4 = 7'b0001011; //H
																				  // HEX3 = 7'b1000000; //O
																				  // HEX2 = 7'b0000110; //E
																				  // HEX1 = 7'b1111111;
																				  // HEX0 = 7'b1111111;
			SW[8]=1'b0; SW[7]=1'b0; SW[6]=1'b0; SW[0]=1'b1; #10; // LEDR[9]=false, LEDR[0]=false
		                                                        // HEX5 = 7'b0010010; //S
																				  // HEX4 = 7'b0001011; //H
																				  // HEX3 = 7'b1000000; //O
																				  // HEX2 = 7'b0000110; //E
																				  // HEX1 = 7'b1111111;
																				  // HEX0 = 7'b1111111;
			SW[8]=1'b0; SW[7]=1'b0; SW[6]=1'b1; SW[0]=1'b0; #10; // LEDR[9]=false, LEDR[0]=false
					                                               // HEX5 = 7'b0001100; //P
																				  // HEX4 = 7'b0000110; //E
																				  // HEX3 = 7'b0101011; //n
																				  // HEX2 = 7'b1111111;
																				  // HEX1 = 7'b1111111;
																				  // HEX0 = 7'b1111111;
			SW[8]=1'b0; SW[7]=1'b1; SW[6]=1'b1; SW[0]=1'b0; #10; // LEDR[9]=true, LEDR[0]=false
					                                               // HEX5 = 7'b1000110; //C
																				  // HEX4 = 7'b0010001; //y
																				  // HEX3 = 7'b1000110; //C
																				  // HEX2 = 7'b1000111; //L
																				  // HEX1 = 7'b0000110; //E
																				  // HEX0 = 7'b1111111;
			SW[8]=1'b1; SW[7]=1'b0; SW[6]=1'b0; SW[0]=1'b0; #10; // LEDR[9]=false, LEDR[0]=true
					                                               // HEX5 = 7'b0010010; //S
																				  // HEX4 = 7'b1100011; //u
																				  // HEX3 = 7'b1001111; //I
																				  // HEX2 = 7'b0000111; //t
																				  // HEX1 = 7'b1111111;
																				  // HEX0 = 7'b1111111;
			SW[8]=1'b1; SW[7]=1'b0; SW[6]=1'b0; SW[0]=1'b1; #10; // LEDR[9]=false, LEDR[0]=false
					                                               // HEX5 = 7'b0010010; //S
																				  // HEX4 = 7'b1100011; //u
																				  // HEX3 = 7'b1001111; //I
																				  // HEX2 = 7'b0000111; //t
																				  // HEX1 = 7'b1111111;
																				  // HEX0 = 7'b1111111;
			SW[8]=1'b1; SW[7]=1'b0; SW[6]=1'b1; SW[0]=1'b0; #10; // LEDR[9]=true, LEDR[0]=true
					                                               // HEX5 = 7'b1000110; //C
																				  // HEX4 = 7'b1000000; //O
																				  // HEX3 = 7'b0001000; //A
																				  // HEX2 = 7'b0000111; //t
																				  // HEX1 = 7'b1111111;
																				  // HEX0 = 7'b1111111;
			SW[8]=1'b1; SW[7]=1'b0; SW[6]=1'b1; SW[0]=1'b1; #10; // LEDR[9]=true, LEDR[0]=false
					                                               // HEX5 = 7'b1000110; //C
																				  // HEX4 = 7'b1000000; //O
																				  // HEX3 = 7'b0001000; //A
																				  // HEX2 = 7'b0000111; //t
																				  // HEX1 = 7'b1111111;
																				  // HEX0 = 7'b1111111;
			SW[8]=1'b1; SW[7]=1'b1; SW[6]=1'b0; SW[0]=1'b0; #10; // LEDR[9]=true, LEDR[0]=false
					                                               // HEX5 = 7'b0001000; //R
																				  // HEX4 = 7'b0000110; //E
																				  // HEX3 = 7'b1000110; //C
																				  // HEX2 = 7'b1000000; //O
																				  // HEX1 = 7'b0001000; //R
																				  // HEX0 = 7'b0100001; //D
	end
	
endmodule
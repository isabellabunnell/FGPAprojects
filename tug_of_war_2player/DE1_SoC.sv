// DE1_SoC takes a 3-bit KEY and 10-bit SW as inputs and returns a 7-bit HEX0, HEX1, HEX2, HEX3, HEx4, HEX5 and 10-bit LEDR as outputs.
// This serves as the top-level module for the tug-of-war game.
// The seven segment HEX displays are driven off (Except for HEX0), the winner of the tug-of-war game is displayed on HEX0 and 
// the current status of the game is displayed on LEDRs 1-9.
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	
	input logic CLOCK_50; // 50MHz clock
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY; // Active low property
	input logic [9:0] SW;

	logic [31:0] clk;
	logic Linput, Lpull, Rinput, Rpull;

	logic reset;  // configure reset

	assign reset = ~KEY[1]; // Reset when KEY[1] is pressed
	
	// metastability modules, treat the raw KEY inputs to get rid of random behavior.
	// meta metaL takes CLOCK_50, reset (KEY[1]), KEY[3] as inputs and returns the 1-bit treated input Linput to feed into the userInput module.
	meta metaL(.clk(CLOCK_50), .reset(reset), .d1(~KEY[3]), .q2(Linput));
	// meta metaL takes CLOCK_50, reset (KEY[1]), KEY[0] as inputs and returns the 1-bit treated input Rinput to feed into the userInput module.
	meta metaR(.clk(CLOCK_50), .reset(reset), .d1(~KEY[0]), .q2(Rinput));
	
	// userInput UiL takes CLOCK_50, reset (KEY[1]), Linput as inputs and returns the 1-bit value Lpull that gets inputted to the rest of the FSMs.
	userInput UiL (.clk(CLOCK_50), .reset(reset), .press(Linput), .pull(Lpull));
	// userInput UiR takes CLOCK_50, reset (KEY[1]), Rinput as inputs and returns the 1-bit value Rpull that gets inputted to the rest of the FSMs.
	userInput UiR (.clk(CLOCK_50), .reset(reset), .press(Rinput), .pull(Rpull));
	
	// normalLight l1 takes CLOCK_50, reset (KEY[1]), Lpull and Rpull, whether LEDR[2] is on for the Next Left and the value 0 for NR (as there is no Next Right) 
	// as inputs and returns the 1-bit value lightOn which controls if LEDR[1] is on.
	normalLight l1 (.clk(CLOCK_50), .reset(reset), .L(Lpull), .R(Rpull), .NL(LEDR[2]), .NR(0), .lightOn(LEDR[1]));
	// normalLight l2 takes CLOCK_50, reset (KEY[1]), Lpull and Rpull, whether LEDR[3] is on for the Next Left and whether LEDR[1] is on for NR
	// as inputs and returns the 1-bit value lightOn which controls if LEDR[2] is on.
	normalLight l2 (.clk(CLOCK_50), .reset(reset), .L(Lpull), .R(Rpull), .NL(LEDR[3]), .NR(LEDR[1]), .lightOn(LEDR[2]));
	// normalLight l3 takes CLOCK_50, reset (KEY[1]), Lpull and Rpull, whether LEDR[4] is on for the Next Left and whether LEDR[2] is on for NR
	// as inputs and returns the 1-bit value lightOn which controls if LEDR[3] is on.
	normalLight l3 (.clk(CLOCK_50), .reset(reset), .L(Lpull), .R(Rpull), .NL(LEDR[4]), .NR(LEDR[2]), .lightOn(LEDR[3]));
	// normalLight l4 takes CLOCK_50, reset (KEY[1]), Lpull and Rpull, whether LEDR[5] is on for the Next Left and whether LEDR[3] is on for NR
	// as inputs and returns the 1-bit value lightOn which controls if LEDR[4] is on.
	normalLight l4 (.clk(CLOCK_50), .reset(reset), .L(Lpull), .R(Rpull), .NL(LEDR[5]), .NR(LEDR[3]), .lightOn(LEDR[4]));
	// centerLight l5 takes CLOCK_50, reset (KEY[1]), Lpull and Rpull, whether LEDR[6] is on for the Next Left and whether LEDR[4] is on for NR
	// as inputs and returns the 1-bit value lightOn which controls if LEDR[5] is on.
	centerLight l5 (.clk(CLOCK_50), .reset(reset), .L(Lpull), .R(Rpull), .NL(LEDR[6]), .NR(LEDR[4]), .lightOn(LEDR[5]));
	// normalLight l6 takes CLOCK_50, reset (KEY[1]), Lpull and Rpull, whether LEDR[7] is on for the Next Left and whether LEDR[5] is on for NR
	// as inputs and returns the 1-bit value lightOn which controls if LEDR[6] is on.
	normalLight l6 (.clk(CLOCK_50), .reset(reset), .L(Lpull), .R(Rpull), .NL(LEDR[7]), .NR(LEDR[5]), .lightOn(LEDR[6]));
	// normalLight l7 takes CLOCK_50, reset (KEY[1]), Lpull and Rpull, whether LEDR[8] is on for the Next Left and whether LEDR[6] is on for NR
	// as inputs and returns the 1-bit value lightOn which controls if LEDR[7] is on.
	normalLight l7 (.clk(CLOCK_50), .reset(reset), .L(Lpull), .R(Rpull), .NL(LEDR[8]), .NR(LEDR[6]), .lightOn(LEDR[7]));
	// normalLight l8 takes CLOCK_50, reset (KEY[1]), Lpull and Rpull, whether LEDR[9] is on for the Next Left and whether LEDR[7] is on for NR
	// as inputs and returns the 1-bit value lightOn which controls if LEDR[8] is on.
	normalLight l8 (.clk(CLOCK_50), .reset(reset), .L(Lpull), .R(Rpull), .NL(LEDR[9]), .NR(LEDR[7]), .lightOn(LEDR[8]));
	// normalLight l9 takes CLOCK_50, reset (KEY[1]), Lpull and Rpull, the value 0 for NL (as there is no Next Left) and whether LEDR[8] is on for 
	// the Next Right as inputs and returns the 1-bit value lightOn which controls if LEDR[1] is on.
	normalLight l9 (.clk(CLOCK_50), .reset(reset), .L(Lpull), .R(Rpull), .NL(0), .NR(LEDR[8]), .lightOn(LEDR[9]));
	
	// winCondition win takes takes CLOCK_50, reset (KEY[1]), Lpull and Rpull, and whther LEDR[9] and LEDR[1] is on and outputs a 7-bit value to display
	// on HEX0 that shows who has won the current round of tug-of-war.
	winCondition win (.clk(CLOCK_50), .reset(reset), .L(Lpull), .R(Rpull), .leftOn(LEDR[9]), .rightOn(LEDR[1]), .playerWin(HEX0[6:0]));
	
	// Driving off all other hex displays.
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;

endmodule

// DE1_SoC_testbench tests the behavior of the board by simulating a tug-of-war game. Expected output is below.
module DE1_SoC_testbench();
	logic CLOCK_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY; // Active low property
	logic [9:0] SW;
	
	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	
	//clock setup
	parameter clock_period = 100;
	
	initial begin
		CLOCK_50 <= 0;
		forever #(clock_period /2) CLOCK_50 <= ~CLOCK_50;
				
	end //initial

	initial begin
		KEY[3]=1'b1; KEY[0]=1'b1; @(posedge CLOCK_50); // LEDR[5]=true, all other LEDRs false otherwise, HEX0[6:0] = 7'b1111111 (0)
		KEY[3]=1'b0; KEY[0]=1'b1; @(posedge CLOCK_50); // LEDR[6]=true, all other LEDRs false otherwise, HEX0[6:0] = 7'b1111111 (0)
		KEY[3]=1'b0; KEY[0]=1'b1; @(posedge CLOCK_50); // LEDR[6]=true, all other LEDRs false otherwise, HEX0[6:0] = 7'b1111111 (0)
		KEY[3]=1'b0; KEY[0]=1'b0; @(posedge CLOCK_50); // LEDR[6]=true, all other LEDRs false otherwise, HEX0[6:0] = 7'b1111111 (0)
		KEY[3]=1'b1; KEY[0]=1'b0; @(posedge CLOCK_50); // LEDR[5]=true, all other LEDRs false otherwise, HEX0[6:0] = 7'b1111111 (0)
		KEY[3]=1'b1; KEY[0]=1'b0; @(posedge CLOCK_50); // LEDR[4]=true, all other LEDRs false otherwise, HEX0[6:0] = 7'b1111111 (0)
		KEY[3]=1'b1; KEY[0]=1'b0; @(posedge CLOCK_50); // LEDR[3]=true, all other LEDRs false otherwise, HEX0[6:0] = 7'b1111111 (0)
		KEY[3]=1'b1; KEY[0]=1'b0; @(posedge CLOCK_50); // LEDR[2]=true, all other LEDRs false otherwise, HEX0[6:0] = 7'b1111111 (0)
		KEY[3]=1'b1; KEY[0]=1'b0; @(posedge CLOCK_50); // LEDR[1]=true, all other LEDRs false otherwise, HEX0[6:0] = 7'b1111111 (0)
		KEY[3]=1'b1; KEY[0]=1'b0; @(posedge CLOCK_50); // LEDR[1]=false, all other LEDRs false otherwise, HEX0[6:0] = 7'b1111001 (1)
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		$stop; //end simulation	
	end
	
endmodule

// DE1_SoC takes a 3-bit KEY and 10-bit SW as inputs and returns a 7-bit HEX0, HEX1, HEX2, HEX3, HEx4, HEX5 and 10-bit LEDR as outputs.
// This serves as the top-level module for the tug-of-war game with a cyberplayer.
// The seven segment HEX displays are driven off (Except for HEX0 and HEX5), and 
// the current status of the game is displayed on LEDRs 1-9.
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	
	input logic CLOCK_50; // 50MHz clock
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY; // Active low property
	input logic [9:0] SW;

	logic [31:0] clk;
	
	parameter whichClock = 15;

	clock_divider cdiv (CLOCK_50, clk);
	
	logic Linput, Lpull, Rinput, Rpull, Lreset, Rreset, reset, computerInput;
	logic [9:0] LFSRoutput;
	
	// LFSR lfsr takes the chosen clock cycle speed, no reset, and outputs a 10-bit values LFSRoutput, which is a randomly generated number.
	LFSR lfsr(.clk(clk[whichClock]), .reset(0), .out(LFSRoutput));
	// comparator compare takes in the input from Switches 8-0 as a 10 bit number and the randomly generated number from the LFSR and returns a true/false value of whether the computer
	// has an input for that clock cycle.
	comparator compare(.A({1'b0, SW[8:0]}), .B(LFSRoutput), .result(computerInput));
	
	
	// resethandler r takes the chosen clock cycle speed, a 1-bit signal from the winCounter Lplayer and Rplayer as well as a hard reset signal from KEY[1]. It
	// returns a one-bit signal "reset" which is what is passed in to the normalLight and centerLight modules to reset the tug-of-war game.
	resetHandler r (.clk(clk[whichClock]), .Lreset(Lreset), .Rreset(Rreset),.hardReset(~KEY[1]), .reset(reset));
	
	// metastability modules, treat the raw KEY inputs to get rid of random behavior.
	// metaL will now take the computers input, rather than a humans.
	meta metaL(.clk(clk[whichClock]), .reset(~KEY[1]), .d1(computerInput), .q2(Linput));
	// meta metaL takes the chosen clock cycle speed, reset (KEY[1]), KEY[0] as inputs and returns the 1-bit treated input Rinput to feed into the userInput module.
	meta metaR(.clk(clk[whichClock]), .reset(~KEY[1]), .d1(~KEY[0]), .q2(Rinput));
	
	// userInput UiL takes the chosen clock cycle speed, reset (KEY[1]), Linput as inputs and returns the 1-bit value Lpull that gets inputted to the rest of the FSMs.
	userInput UiL (.clk(clk[whichClock]), .reset(~KEY[1]), .press(Linput), .pull(Lpull));
	// userInput UiR takes the chosen clock cycle speed, reset (KEY[1]), Rinput as inputs and returns the 1-bit value Rpull that gets inputted to the rest of the FSMs.
	userInput UiR (.clk(clk[whichClock]), .reset(~KEY[1]), .press(Rinput), .pull(Rpull));
	
	// winCounter Lplayer takes in the chosen clock cycle speed, a reset signal from KEY[1], the input from the cyberplayer and a true/false value of whether the leftmost LED is on
	// and outputs a 7-bit display sequence for HEX5 and a 1-bit reset signal to the resetHandler.
	winCounter Lplayer (.clk(clk[whichClock]), .hardReset(~KEY[1]), .correctInput(Lpull), .lightOn(LEDR[9]), .reset(Lreset), .display(HEX5[6:0]));
	// winCounter Rplayer takes in the chosen clock cycle speed, a reset signal from KEY[1], the input from the human player and a true/false value of whether the rightmost LED is on
	// and outputs a 7-bit display sequence for HEX0 and a 1-bit reset signal to the resetHandler.
	winCounter Rplayer (.clk(clk[whichClock]), .hardReset(~KEY[1]), .correctInput(Rpull), .lightOn(LEDR[1]), .reset(Rreset), .display(HEX0[6:0]));
	
	// normalLight l1 takes the chosen clock cycle speed, reset (KEY[1]), Lpull and Rpull, whether LEDR[2] is on for the Next Left and the value 0 for NR (as there is no Next Right) 
	// as inputs and returns the 1-bit value lightOn which controls if LEDR[1] is on.
	normalLight l1 (.clk(clk[whichClock]), .reset(reset), .L(Lpull), .R(Rpull), .NL(LEDR[2]), .NR(0), .lightOn(LEDR[1]));
	// normalLight l2 takes the chosen clock cycle speed, reset (KEY[1]), Lpull and Rpull, whether LEDR[3] is on for the Next Left and whether LEDR[1] is on for NR
	// as inputs and returns the 1-bit value lightOn which controls if LEDR[2] is on.
	normalLight l2 (.clk(clk[whichClock]), .reset(reset), .L(Lpull), .R(Rpull), .NL(LEDR[3]), .NR(LEDR[1]), .lightOn(LEDR[2]));
	// normalLight l3 takes the chosen clock cycle speed, reset (KEY[1]), Lpull and Rpull, whether LEDR[4] is on for the Next Left and whether LEDR[2] is on for NR
	// as inputs and returns the 1-bit value lightOn which controls if LEDR[3] is on.
	normalLight l3 (.clk(clk[whichClock]), .reset(reset), .L(Lpull), .R(Rpull), .NL(LEDR[4]), .NR(LEDR[2]), .lightOn(LEDR[3]));
	// normalLight l4 takes the chosen clock cycle speed, reset (KEY[1]), Lpull and Rpull, whether LEDR[5] is on for the Next Left and whether LEDR[3] is on for NR
	// as inputs and returns the 1-bit value lightOn which controls if LEDR[4] is on.
	normalLight l4 (.clk(clk[whichClock]), .reset(reset), .L(Lpull), .R(Rpull), .NL(LEDR[5]), .NR(LEDR[3]), .lightOn(LEDR[4]));
	// centerLight l5 takes the chosen clock cycle speed, reset (KEY[1]), Lpull and Rpull, whether LEDR[6] is on for the Next Left and whether LEDR[4] is on for NR
	// as inputs and returns the 1-bit value lightOn which controls if LEDR[5] is on.
	centerLight l5 (.clk(clk[whichClock]), .reset(reset), .L(Lpull), .R(Rpull), .NL(LEDR[6]), .NR(LEDR[4]), .lightOn(LEDR[5]));
	// normalLight l6 takes the chosen clock cycle speed, reset (KEY[1]), Lpull and Rpull, whether LEDR[7] is on for the Next Left and whether LEDR[5] is on for NR
	// as inputs and returns the 1-bit value lightOn which controls if LEDR[6] is on.
	normalLight l6 (.clk(clk[whichClock]), .reset(reset), .L(Lpull), .R(Rpull), .NL(LEDR[7]), .NR(LEDR[5]), .lightOn(LEDR[6]));
	// normalLight l7 takes the chosen clock cycle speed, reset (KEY[1]), Lpull and Rpull, whether LEDR[8] is on for the Next Left and whether LEDR[6] is on for NR
	// as inputs and returns the 1-bit value lightOn which controls if LEDR[7] is on.
	normalLight l7 (.clk(clk[whichClock]), .reset(reset), .L(Lpull), .R(Rpull), .NL(LEDR[8]), .NR(LEDR[6]), .lightOn(LEDR[7]));
	// normalLight l8 takes the chosen clock cycle speed, reset (KEY[1]), Lpull and Rpull, whether LEDR[9] is on for the Next Left and whether LEDR[7] is on for NR
	// as inputs and returns the 1-bit value lightOn which controls if LEDR[8] is on.
	normalLight l8 (.clk(clk[whichClock]), .reset(reset), .L(Lpull), .R(Rpull), .NL(LEDR[9]), .NR(LEDR[7]), .lightOn(LEDR[8]));
	// normalLight l9 takes the chosen clock cycle speed, reset (KEY[1]), Lpull and Rpull, the value 0 for NL (as there is no Next Left) and whether LEDR[8] is on for 
	// the Next Right as inputs and returns the 1-bit value lightOn which controls if LEDR[1] is on.
	normalLight l9 (.clk(clk[whichClock]), .reset(reset), .L(Lpull), .R(Rpull), .NL(0), .NR(LEDR[8]), .lightOn(LEDR[9]));
		
	// Driving off all other hex displays.
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;

endmodule

// clock_divider takes a frequency and generates an output signal as an array of smaller frequencies.
// These frequencies can then be referenced by index as an input to "clk" in the FInite State Machine.
// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (clock, divided_clocks);
	input logic clock;
	output logic [31:0] divided_clocks;

	initial begin
		divided_clocks <= 0;
	end

	always_ff @(posedge clock) begin
	// at each positive edge of the original, divided_clocks gets updated
		divided_clocks <= divided_clocks + 1;
   end

endmodule
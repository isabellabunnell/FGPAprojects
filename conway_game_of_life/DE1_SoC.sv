// DE1_SoC takes a 3-bit KEY and 10-bit SW as inputs and returns a 7-bit HEX0, HEX1, HEX2, HEX3, HEx4, HEX5 and 10-bit LEDR as outputs,
// as well as the 16x16 LED array when it is in.
// This serves as the top-level module for the Conway's Game of Life simulator.
// The seven segment HEX displays are driven off (Except for HEX0), and 
// the game is displayed on the 16x16 LED array.
module DE1_SoC (CLOCK_50,HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, GPIO_1, SW);
	input logic CLOCK_50;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [35:0] GPIO_1;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	logic [31:0] clk;

	parameter whichClock = 25;

	clock_divider cdiv (CLOCK_50, clk);
	
   logic [15:0][15:0] GrnPixels; // 16x16 array of green LEDs
	logic [15:0][15:0] initPixels;
	logic [31:0] randValue;
	
	// this module takes in a clock and reset signal and outputs a 32 bit pseudorandom value.
	LFSR(.clk(clk[whichClock]), .reset(~KEY[3]), .out(randValue));
	
	// this module will output a 16x16 bit sequence that gets passed into the gameboard to use as an initial sequence for the pixels.
	// it takes in the 32-bit pseudorandom value from the LFSR as welll as the user choice for what initial cell configuration that
	// they want to load in.
	initialFrame(.random(SW[0]), .patternChoice(SW[2:1]), .LFSRval(randValue), .initPixels(initPixels));
	
	// this module will generate all relevant modules for each pixel to find if it should be on or off
   //	and output the 16x16 pixel array for the driver.
	gameboard(.clk(clk[whichClock]), .reset(~KEY[3]), .load(~KEY[0]), .initialPixels(initPixels), .pixels(GrnPixels));
	
	// driver for the LED array (not made by me)
	// redpixels and reset are set to 0 because I did not need them.
	LEDDriver(.GPIO_1(GPIO_1), .RedPixels('0), .GrnPixels(GrnPixels), .EnableCount(1), .CLK(clk[5]), .RST(0));
	
	// this module takes in the user choice for what initial cell configuration they want to load in and outputs
	// a short phrase on the HEX displays (this was just for my benefit, so I did not get confused on what I was about to load in)
	display(.random(SW[0]), .pattern(SW[2:1]), .leds5(HEX5), .leds4(HEX4), .leds3(HEX3), .leds2(HEX2), .leds1(HEX1), .leds0(HEX0));

endmodule

// clock_divider takes a frequency and generates an output signal as an array of smaller frequencies.
// These frequencies can then be referenced by index as an input to "clk" in the Finite State Machine.
// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (clock, divided_clocks);
	input logic clock;
	output logic [31:0] divided_clocks;

	// initialization
	initial begin
		divided_clocks <= 0;
	end

	always_ff @(posedge clock) begin
		// at each positive edge of the original, divided_clocks gets updated
		divided_clocks <= divided_clocks + 1;
   end

endmodule
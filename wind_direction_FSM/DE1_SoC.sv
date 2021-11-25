// DE1_SoC takes a 3-bit KEY and 10-bit SW as inputs and returns a 7-bit HEX0, HEX1, HEX2, HEX3, HEx4, HEX5 and 10-bit LEDR as outputs.
// The clock is displayed on LEDR5 while LEDR0, LEDR1 and LEDR2 shows the a sequence of lights, and it uses KEY0 as the reset and SW0 and SW1 as the input for the wind direction.
// Between clock cycles, LEDs 0-3 will change light sequences in a way that represents the wind direction as specified in the specification.
// This serves as the top-level module for the Finite State Machine implemented in Lab 3, Task 1.
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	
	input logic CLOCK_50; // 50MHz clock
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY; // Active low property
	input logic [9:0] SW;

	// Generate clk off of CLOCK_50, whichClock picks rate.

	logic [31:0] clk;

	parameter whichClock = 25;

	clock_divider cdiv (CLOCK_50, clk);

	logic reset;  // configure reset

	assign reset = ~KEY[0]; // Reset when KEY[0] is pressed
	
	assign LEDR[5] = clk[whichClock];
	
	// fsm f1 takes clk[whichClock], ~KEY[0] and SW[0], SW[1] as inputs
	// and outputs the clock cycle on LEDR[5], and the LED sequence on LEDR[0], LEDR[1] and LEDR[2].
	fsm f1 (.clk(clk[whichClock]), .reset(reset), .w(SW[1:0]), .out(LEDR[2:0]));

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
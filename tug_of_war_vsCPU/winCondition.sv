// centerLight takes in a 1 bit clock cycle, reset, L, R, leftOn, Righton and ouputs a 7-bit value for playerWin that can be fed in to a HEX display
// to show the winner of the tug-of-war game according to the win condition (leftmost light on and L button press or rightmost light on and R button press).
module winCondition (clk, reset, L, R, leftOn, rightOn, playerWin);

	// L is true when left key is pressed, R is true when the right key 
	// is pressed, NL is true when the light on the left is on, and NR
	// is true when the light on the right is on.   
	input logic clk, reset, L, R, leftOn, rightOn; 
	// when lightOn is true, the center light should be on.
	output logic [6:0] playerWin;

	enum {S0, S1, S2} ps, ns; // Present state, next state

	//Next state logic
	always_comb begin
		case (ps)
			S0: if (rightOn & R) ns = S1;
				 else if (leftOn & L) ns = S2;
				 else ns = S0;
			S1: if (leftOn & L) ns = S2;
				 else ns = S1;
			S2: if (rightOn & R) ns = S1;
				 else ns = S2;
		endcase
	end
	
	// Maps each state in the FSM to a HEX display sequence.
	always_comb begin
		case(ps)
			 S0: playerWin = 7'b1111111; // driven off
			 S1: playerWin = 7'b1111001; // 1
			 S2: playerWin = 7'b0100100; // 2
			 default: playerWin = 7'b1111111;
		endcase
	 end

	//sequential logic (DFFs)
	always_ff @(posedge clk) begin
		if (reset)
			ps <= S0;
		else
			ps <= ns;
	end	
	
endmodule

// winCondition_testbench tests the behavior of the FSM by inputting values to L, R, leftOn and rightOn. Expected output is commented below.
module winCondition_testbench();

	logic clk, reset, L, R, leftOn, rightOn;
	logic [6:0] playerWin;
	
	winCondition dut (.clk, .reset, .L, .R, .leftOn, .rightOn, .playerWin);
	
	//clock setup
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
				
	end //initial
	
	initial begin
	
		reset <= 1;         										@(posedge clk); // playerWin = 7'b1111111
		reset <= 0; L<=0; R<=0; leftOn<=0; rightOn<=0;  @(posedge clk); // S0, playerWin = 7'b1111111
						L<=0; R<=1; leftOn<=0; rightOn<=0;  @(posedge clk); // S0, playerWin = 7'b1111111
						L<=0; R<=1; leftOn<=0; rightOn<=1;  @(posedge clk); // S1, playerWin = 7'b1111001
						L<=0; R<=1; leftOn<=0; rightOn<=0;  @(posedge clk); // S1, playerWin = 7'b1111001
						L<=1; R<=0; leftOn<=0; rightOn<=0;  @(posedge clk); // S1, playerWin = 7'b1111001
						L<=1; R<=0; leftOn<=1; rightOn<=0;  @(posedge clk); // S2, playerWin = 7'b0100100
		$stop; //end simulation							
						
	end //initial
		
endmodule		
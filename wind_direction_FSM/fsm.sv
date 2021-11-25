// fsm takes a 1-bit clock (clk), reset and 2-bit w (representing the wind status) and outputs a 3-bit value "out" of the current sequence.
module fsm (clk, reset, w, out);

	input logic clk, reset;
	input logic [1:0] w;
	output logic [2:0] out;

	// Each enumerable represents a state, which carries with it its present state and it's next state
	enum logic [1:0] {S0, S1, S2, S3} ps, ns; // Present state, next state
	
	// S0 = 010
	// S1 = 101
	// S2 = 001
	// S3 = 100

	//Next state logic
	//Refer to state diagram for full picture.
	always_comb begin
		case (ps) // look at the present state, and then look for the input from w. Whatever the input from w is dictates what the nest state should be
			S0: if (w == 2'b00) ns = S1;
				 else if (w == 2'b10) ns = S2;
				 else ns = S3;
			S1: if (w == 2'b00) ns = S0;
				 else ns = S2;
			S2: if (w == 2'b00) ns = S1;
				 else if (w == 2'b10) ns = S3;
				 else ns = S0;
			S3: if (w == 2'b00) ns = S1;
				 else if (w == 2'b10) ns = S0;
				 else ns = S2;
		endcase
	end
	
	// Maps each state in the FSM to a 3-bit sequence, intended for the LEDs.
	always_comb begin
		case(ps)
			 S0: out = 3'b010;
			 S1: out = 3'b101;
			 S2: out = 3'b001;
			 S3: out = 3'b100;
			 default: out = 3'b000;
		endcase
	 end
		
	//sequential logic (DFFs)
	always_ff @(posedge clk) begin
		if (reset)
			ps <= S0; // if reset is turned on, FSM goes back to state 0 at the next positive edge of the clock
		else
			ps <= ns;
	end	
endmodule


// fsm_testbench tests the behaviour of the FSM, checking many inputs of w to make sure that it ends up in the correct state and that output is correct. 
module fsm_testbench();

		logic clk, reset;
		logic [1:0] w;
		logic [2:0] out;
		
		fsm dut (.clk, .reset, .w, .out);
		
		//clock setup
		parameter clock_period = 100;
		
		initial begin
			clk <= 0;
			forever #(clock_period /2) clk <= ~clk;
					
		end //initial
		
		// test cases:
		initial begin
			reset <= 1;         @(posedge clk);
			reset <= 0; w<=2'b00;   @(posedge clk);
									  @(posedge clk);
			                    @(posedge clk);	
			                    @(posedge clk);	
			            w<=2'b01;   @(posedge clk);	
							w<=2'b10;   @(posedge clk);	
							w<=2'b01;   @(posedge clk);	
									  @(posedge clk);	
			                    @(posedge clk);	
			                    @(posedge clk);	
							w<=2'b10;   @(posedge clk);	
									  @(posedge clk);	
									  @(posedge clk);	
									  @(posedge clk);
							w<=2'b00;   @(posedge clk);	
									  @(posedge clk);	
									  @(posedge clk);	
									  @(posedge clk);
									  @(posedge clk);
			$stop; //end simulation							
							
		end //initial
endmodule
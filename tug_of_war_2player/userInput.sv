// userInput takes in a 1 bit clock cycle, reset, and button press as input and outputs a t/f value "pull"
// because a user can have their finger pressed on the button for many clock cycles, this module ensures that the press only counts as a "pull" for one clock cycle.
module userInput (clk, reset, press, pull);

	input  logic  clk, reset, press;
	output logic  pull;

	enum {S0, S1} ps, ns; // Present state, next state

	//Next state logic
	always_comb begin
		case (ps)
			S0: if (press) ns = S1;
					else ns = S0;
			S1: if (press) ns = S1;
					else ns = S0;
		endcase
	end
			
	assign pull = (ps == S0) & press;
	
	//sequential logic (DFFs)
	always_ff @(posedge clk) begin
		if (reset)
			ps <= S0;
		else
			ps <= ns;
	end	
	
endmodule

// testbench for userInput. expected outcome is that when press=1, pull=1 for only one clock cycle before pull goes to 0. in every other case, pull equals 0.  
module userInput_testbench();

	logic clk, reset, press, pull;
	
	userInput dut (.clk, .reset, .press, .pull);
	
	//clock setup
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
				
	end //initial
	
	initial begin
		reset <= 1;         @(posedge clk);
		reset <= 0; press<=0;  @(posedge clk);
						press<=0;  @(posedge clk);
						press<=0;  @(posedge clk);	
						press<=1;  @(posedge clk);		
						press<=1;  @(posedge clk);	
						press<=1;  @(posedge clk);	
						press<=1;  @(posedge clk);	
						press<=1;  @(posedge clk);	
						press<=0;  @(posedge clk);	
						press<=0;  @(posedge clk);	
						press<=1;  @(posedge clk);	
						press<=1;  @(posedge clk);
						press<=1;  @(posedge clk);	
						press<=0;  @(posedge clk);
						press<=0;  @(posedge clk);
		$stop; //end simulation							
						
	end //initial
		
endmodule		
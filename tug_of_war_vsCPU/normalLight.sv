// normalLight takes in a 1 bit clock cycle, reset, L, R, NL, NR and ouputs a 1-bit value for if the light is on or off.
module normalLight (clk, reset, L, R, NL, NR, lightOn);

	// L is true when left key is pressed, R is true when the right key 
	// is pressed, NL is true when the light on the left is on, and NR
	// is true when the light on the right is on.   
	input logic clk, reset, L, R, NL, NR; 
	// when lightOn is true, the center light should be on.
	output logic lightOn;

	enum {S0, S1} ps, ns; // Present state, next state

	//Next state logic
	always_comb begin
		case (ps)
			S0: if ((NR & L) ^ (NL & R))
					if (R ^ L)
						ns = S1;
					else
						ns = S0;
				 else ns = S0;
			S1: if (R ^ L) ns = S0;
					else ns = S1;
		endcase
	end
			
	always_comb begin	
		case(ps)
			 S0: lightOn = 1'b0; // on
			 S1: lightOn = 1'b1; // off
			 default: lightOn = 1'b0;
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

// normalLight_testbench tests the behavior of the FSM by inputting values to L, R, NL and NR. Expected output is commented below.
module normalLight_testbench();

	logic clk, reset, L, R, NL, NR, lightOn;
	
	normalLight dut (.clk, .reset, .L, .R, .NL, .NR, .lightOn);
	
	//clock setup
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
				
	end //initial
	
	initial begin
	
		reset <= 1;         							@(posedge clk); // lightOn = false (S0)
		reset <= 0; L<=0; R<=0; NL<=0; NR<=0;  @(posedge clk); // lightOn = false (S0)
						L<=1; R<=1; NL<=0; NR<=0;  @(posedge clk); // lightOn = false (S0)
						L<=1; R<=0; NL<=0; NR<=0;  @(posedge clk); // lightOn = false (S0)
						L<=0; R<=1; NL<=0; NR<=0;	@(posedge clk); // lightOn = false (S0)
						L<=0; R<=1; NL<=1; NR<=0;  @(posedge clk); // lightOn = true (S1)
						L<=1; R<=1; NL<=0; NR<=0;  @(posedge clk); // lightOn = true (S1)
						L<=0; R<=0; NL<=0; NR<=0;  @(posedge clk); // lightOn = true (S1)
						L<=0; R<=1; NL<=0; NR<=0;  @(posedge clk); // lightOn = false (S0)
						L<=0; R<=0; NL<=0; NR<=0;	@(posedge clk); // lightOn = false (S0)
						L<=1; R<=0; NL<=0; NR<=1;  @(posedge clk); // lightOn = true (S1)
						L<=0; R<=0; NL<=0; NR<=0;  @(posedge clk); // lightOn = true (S1)

		$stop; //end simulation							
						
	end //initial
		
endmodule		
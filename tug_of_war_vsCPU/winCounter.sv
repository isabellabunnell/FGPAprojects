// winCounter takes in a 1 bit clock cycle, hardReset (the button input from the board), correctInput and lightOn 
// and ouputs a 7-bit value for allocated HEX display as well as a 1 bit true or false signal from the counter if the rest of the system should be reset
// "hardReset" resets the counter diplay, while the output "reset" will reset the rest of the board.
module winCounter (clk, hardReset, correctInput, lightOn, reset, display);

	// correctInput is true when the allocated KEY is pressed, 
	// lightOn is true when the allocated LEDR is on. 
	input logic clk, hardReset, correctInput, lightOn;
	output logic [6:0] display;
	output logic reset;

	enum {S0, S1, S2, S3, S4, S5, S6, S7} ps, ns; // Present state, next state

	//Next state logic
	always_comb begin
		case (ps)
			S0: if (lightOn & correctInput) ns = S1;
				 else ns = S0;
			S1: if (lightOn & correctInput) ns = S2;
				 else ns = S1;
			S2: if (lightOn & correctInput) ns = S3;
				 else ns = S2;
			S3: if (lightOn & correctInput) ns = S4;
				 else ns = S3;
			S4: if (lightOn & correctInput) ns = S5;
				 else ns = S4;
			S5: if (lightOn & correctInput) ns = S6;
				 else ns = S5;
			S6: if (lightOn & correctInput) ns = S7;
				 else ns = S6;
			S7: ns = S7;		 
		endcase
	end
	
	// rest of system is reset when the counter goes up, or when hardReset is pressed.
	assign reset = (lightOn & correctInput) || (hardReset);
	
	// Maps each state in the FSM to a HEX display sequence.
	always_comb begin
		case(ps)
			 S0: display = 7'b1000000; // 0
			 S1: display = 7'b1111001; // 1
			 S2: display = 7'b0100100; // 2
			 S3: display = 7'b0110000; // 3
			 S4: display = 7'b0011001; // 4
			 S5: display = 7'b0010010; // 5
			 S6: display = 7'b0000010; // 6
			 S7: display = 7'b1111000; // 7
			 default: display = 7'b1111111; // driven off
		endcase
	 end

	//sequential logic (DFFs)
	always_ff @(posedge clk) begin
		if (hardReset)
			ps <= S0;
		else
			ps <= ns;
	end	
	
endmodule

// winCondition_testbench tests the behavior of the FSM by inputting values to hardReset, lightOn, and correctInput. Expected output is commented below.
module winCounter_testbench();

	logic clk, hardReset, lightOn, correctInput, reset;
	logic [6:0] display;
	
	winCounter dut (.clk, .hardReset, .correctInput, .lightOn, .reset, .display);
	
	//clock setup
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
				
	end //initial
	
	initial begin
		hardReset <= 1;         					  @(posedge clk); // display = 7'b1000000, reset = 1;
		hardReset <= 0; 
						correctInput<=0; lightOn<=0; @(posedge clk); // S0, display = 7'b1000000, reset = 0;
						correctInput<=0; lightOn<=1; @(posedge clk); // S0, display = 7'b1000000, reset = 0;
						correctInput<=1; lightOn<=0; @(posedge clk); // S0, display = 7'b1000000, reset = 0;
						
						correctInput<=1; lightOn<=1; @(posedge clk); // S1, display = 7'b1111001, reset = 1;
						correctInput<=0; lightOn<=1; @(posedge clk); // S1, display = 7'b1111001, reset = 0;
						correctInput<=1; lightOn<=0; @(posedge clk); // S1, display = 7'b1111001, reset = 0;

						correctInput<=1; lightOn<=1; @(posedge clk); // S2, display = 7'b0100100, reset = 1;
						correctInput<=0; lightOn<=1; @(posedge clk); // S2, display = 7'b0100100, reset = 0;
						correctInput<=1; lightOn<=0; @(posedge clk); // S2, display = 7'b0100100, reset = 0;
						
						correctInput<=1; lightOn<=1; @(posedge clk); // S3, display = 7'b0110000, reset = 1;
						correctInput<=0; lightOn<=0; @(posedge clk); // S3, display = 7'b0110000, reset = 0;
						
						correctInput<=1; lightOn<=1; @(posedge clk); // S4, display = 7'b0011001, reset = 1;
						correctInput<=0; lightOn<=0; @(posedge clk); // S4, display = 7'b0011001, reset = 0;
						
						correctInput<=1; lightOn<=1; @(posedge clk); // S5, display = 7'b0010010, reset = 1;
						correctInput<=0; lightOn<=0; @(posedge clk); // S5, display = 7'b0010010, reset = 0;
						
						correctInput<=1; lightOn<=1; @(posedge clk); // S6, display = 7'b0000010, reset = 1;
						correctInput<=0; lightOn<=0; @(posedge clk); // S6, display = 7'b0000010, reset = 0;
						
						correctInput<=1; lightOn<=1; @(posedge clk); // S7, display = 7'b1111000, reset = 1;
						correctInput<=0; lightOn<=0; @(posedge clk); // S7, display = 7'b1111000, reset = 0;

						correctInput<=1; lightOn<=1; @(posedge clk); // S0, display = 7'b1000000, reset = 1;
						correctInput<=0; lightOn<=0; @(posedge clk); // S0, display = 7'b1000000, reset = 0;						
		$stop; //end simulation							
						
	end //initial
		
endmodule		
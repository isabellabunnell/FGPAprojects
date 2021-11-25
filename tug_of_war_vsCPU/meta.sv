// meta takes in a 1 bit clock cycle, reset, and button press as input (d1) and outputs a 1-bit value q2.
// This is a treated version of he button press input from the user to handle metastability.
module meta (clk, reset, d1, q2);

	input  logic  clk, reset, d1;
	output logic  q2;
	
	logic q1;
	//sequential logic (DFFs)
	always_ff @(posedge clk) begin
		if (reset) begin
			q1 <= 0;
			q2 <= 0;
		end
		else begin
			q1 <= d1;
			q2 <= q1;
		end
	end	
	
endmodule

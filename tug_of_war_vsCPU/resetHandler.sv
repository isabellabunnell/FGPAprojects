// resetHandler takes in a 1 bit clock cycle, Lreset and Rreset that comes from the two winCounter modules.
// It outputs a 1-bit true/false value of reset, which gets passed in to the rest of the board to know if it should be reset or not.
module resetHandler (clk, Lreset, Rreset, hardReset, reset);

	input  logic  clk, Lreset, Rreset, hardReset;
	output logic  reset;
	
	always_ff @(posedge clk) begin
		// if either of the winCounter modules calls for a reset, then the board is reset.
		if (Lreset || Rreset || hardReset)
			reset = 1;
		else
			reset = 0;
	end	
	
endmodule
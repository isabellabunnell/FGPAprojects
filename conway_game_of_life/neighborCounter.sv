module neighborCounter(neighbors, aliveCount);
	input logic [7:0] neighbors;
	output integer aliveCount;
	
	// count how many of the 8 neighbors are alive whenever the value of neighbors changes
	always @(neighbors) begin
		aliveCount = 0;
		for (integer i=0; i < 8; i++) begin
			if (neighbors[i] == 1'b1)
				aliveCount = aliveCount + 1;
		end
	end
	
endmodule
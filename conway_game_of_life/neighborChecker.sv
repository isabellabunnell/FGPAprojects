module neighborChecker(topLeft, topCenter, topRight, centerLeft, centerRight, bottomLeft, bottomCenter, bottomRight, neighborCount);
	input logic topLeft, topCenter, topRight, centerLeft, centerRight, bottomLeft, bottomCenter, bottomRight;
	output integer neighborCount;
	
	logic [7:0] neighbors;
	assign neighbors = {topLeft, topCenter, topRight, centerLeft, centerRight, bottomLeft, bottomCenter, bottomRight};
	
	// count how many of the 8 neighbors are alive whenever the value of neighbors changes
	always@(neighbors) begin
		neighborCount = 0;
		neighborCount = neighbors[0]+neighbors[1]+neighbors[2]+neighbors[3]+neighbors[4]+neighbors[5]+neighbors[6]+neighbors[7];
	end
	
endmodule

module neighborChecker_testbench();
	logic topLeft, topCenter, topRight, centerLeft, centerRight, bottomLeft, bottomCenter, bottomRight;
	integer neighborCount;
	
	neighborChecker dut(.topLeft, .topCenter, .topRight, .centerLeft, .centerRight, .bottomLeft, .bottomCenter, .bottomRight, .neighborCount);
	
	initial begin
		// test cases:
			topLeft = 0; topCenter = 0; topRight = 0; centerLeft = 0; centerRight = 0; bottomLeft = 0; bottomCenter = 0; bottomRight = 0; #10; // count = 0;
			topLeft = 1; topCenter = 0; topRight = 0; centerLeft = 0; centerRight = 0; bottomLeft = 0; bottomCenter = 0; bottomRight = 0; #10; // count = 1;
			topLeft = 0; topCenter = 1; topRight = 0; centerLeft = 0; centerRight = 1; bottomLeft = 0; bottomCenter = 0; bottomRight = 0; #10; // count = 2;
			topLeft = 0; topCenter = 1; topRight = 0; centerLeft = 0; centerRight = 1; bottomLeft = 0; bottomCenter = 1; bottomRight = 0; #10; // count = 3;
			topLeft = 1; topCenter = 0; topRight = 1; centerLeft = 0; centerRight = 0; bottomLeft = 1; bottomCenter = 0; bottomRight = 1; #10; // count = 4;
			topLeft = 1; topCenter = 1; topRight = 1; centerLeft = 1; centerRight = 1; bottomLeft = 0; bottomCenter = 0; bottomRight = 0; #10; // count = 5;
			topLeft = 1; topCenter = 1; topRight = 1; centerLeft = 1; centerRight = 1; bottomLeft = 1; bottomCenter = 0; bottomRight = 0; #10; // count = 6;
			topLeft = 1; topCenter = 1; topRight = 1; centerLeft = 1; centerRight = 1; bottomLeft = 1; bottomCenter = 1; bottomRight = 0; #10; // count = 7;
			topLeft = 1; topCenter = 1; topRight = 1; centerLeft = 1; centerRight = 1; bottomLeft = 1; bottomCenter = 1; bottomRight = 1; #10; // count = 8;
	end
endmodule	
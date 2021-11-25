// This module generates all relevant modules for each "cell"/pixel.
// it takes in a clock, reset and load signal to get passed into the modules that
// get generated as well as the entier 16x16 intialPixels input to pass in the individual
// corresponding value to each generated module.
// The output is a 16x16 entire display that gets passed in to the LED driver.
module gameboard(clk, reset, load, initialPixels, pixels);
	input logic clk, reset, load;
	input logic [15:0][15:0] initialPixels;
	output logic [15:0][15:0] pixels;
	
	genvar i,j;
	generate 
		for (i = 0; i < 16; i++) begin: genRows
			for (j = 0; j < 16; j++) begin: genCols				
				// this module takes in the count of neighbors and ouputs whether the current cell should be alive or not.
				// if load is triggered, the status of alive or dead is not dictated by the neighbors but by the initial pixel pattern.
				//deadOrAlive(.clk(clk), .reset(reset), .load(load), .initialPixel(initialPixels[i][j]), .neighborCount(neighborCount), .alive(pixels[i][j]));
				deadOrAlive(.clk(clk), .reset(reset), .load(load), .initialPixel(initialPixels[i][j]), 
								.neighbors({pixels[(i == 0) ? 15 : i - 1][(j == 0) ? 15 : j - 1], 
												pixels[(i == 0) ? 15 : i - 1][j], 
												pixels[(i == 0) ? 15 : i - 1][(j == 15) ? 0 : j + 1], 
												pixels[i][(j == 0) ? 15 : j - 1], 
												pixels[i][(j == 15) ? 0 : j + 1], 
												pixels[(i == 15) ? 0 : i + 1][(j == 0) ? 15 : j - 1], 
												pixels[(i == 15) ? 0 : i + 1][j], 
												pixels[(i == 15) ? 0 : i + 1][(j == 15) ? 0 : j + 1]}), 
								.alive(pixels[i][j]));
			end
		end
	endgenerate
	
endmodule
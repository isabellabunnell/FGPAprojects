//This test code was adapted from the LED driver example code provided by Prof. Scott Hauck

module LED_test(RST, RedPixels, GrnPixels);
    input logic               RST;
    output logic [15:0][15:0] RedPixels; // 16x16 array of red LEDs
    output logic [15:0][15:0] GrnPixels; // 16x16 array of green LEDs
	 
	 always_comb 
	 begin
		
		// Reset - Turn off all LEDs 
		if (RST)
		begin
			RedPixels = '0;
			GrnPixels = '0;
		end
		
	  // Display a pattern
		else
		begin
		  //                  FEDCBA9876543210
		  RedPixels[00] = 16'b1111111111111111;
		  RedPixels[01] = 16'b1111111111111110;
		  RedPixels[02] = 16'b1111111111111100;
		  RedPixels[03] = 16'b1111111111111000;
		  RedPixels[04] = 16'b1111111111110000;
		  RedPixels[05] = 16'b1111111111100000;
		  RedPixels[06] = 16'b1111111111000000;
		  RedPixels[07] = 16'b1111111110000000;
		  RedPixels[08] = 16'b1111111100000000;
		  RedPixels[09] = 16'b1111111000000000;
		  RedPixels[10] = 16'b1111110000000000;
		  RedPixels[11] = 16'b1111100000000000;
		  RedPixels[12] = 16'b1111000000000000;
		  RedPixels[13] = 16'b1110000000000000;
		  RedPixels[14] = 16'b1100000000000000;
		  RedPixels[15] = 16'b1000000000000000;
		  
		  //                  FEDCBA9876543210
		  GrnPixels[00] = 16'b0000000000000000;
		  GrnPixels[01] = 16'b0000000000000001;
		  GrnPixels[02] = 16'b0000000000000011;
		  GrnPixels[03] = 16'b0000000000000111;
		  GrnPixels[04] = 16'b0000000000001111;
		  GrnPixels[05] = 16'b0000000000011111;
		  GrnPixels[06] = 16'b0000000000111111;
		  GrnPixels[07] = 16'b0000000001111111;
		  GrnPixels[08] = 16'b0000000011111111;
		  GrnPixels[09] = 16'b0000000111111111;
		  GrnPixels[10] = 16'b0000001111111111;
		  GrnPixels[11] = 16'b0000011111111111;
		  GrnPixels[12] = 16'b0000111111111111;
		  GrnPixels[13] = 16'b0001111111111111;
		  GrnPixels[14] = 16'b0011111111111111;
		  GrnPixels[15] = 16'b0111111111111111;
		end
	end

endmodule


module LED_test_testbench();

	logic RST;
	logic [15:0][15:0] RedPixels, GrnPixels;
	
	LED_test dut (.RST, .RedPixels, .GrnPixels);
	
	initial begin
	RST = 1'b1; #10;
	RST = 1'b0; #10;
	end
	
endmodule
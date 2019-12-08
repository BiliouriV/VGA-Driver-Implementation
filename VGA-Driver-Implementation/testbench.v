`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   05:32:07 11/28/2018
// Design Name:   vga_controller
// Module Name:   C:/Users/Victoria Biliouris/Desktop/lab3_2138/lab3_2138_partC/testbench_partC.v
// Project Name:  lab3_2138_partC
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vga_controller
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench;

	// Inputs
	reg reset;
	reg clk;

	// Outputs
	wire VGA_RED;
	wire VGA_GREEN;
	wire VGA_BLUE;
	wire VGA_HSYNC;
	wire VGA_VSYNC;

	// Instantiate the Unit Under Test (UUT)
	vga_controller uut (
		.reset(reset), 
		.clk(clk), 
		.VGA_RED(VGA_RED), 
		.VGA_GREEN(VGA_GREEN), 
		.VGA_BLUE(VGA_BLUE), 
		.VGA_HSYNC(VGA_HSYNC), 
		.VGA_VSYNC(VGA_VSYNC)
	);

	initial begin
		// Initialize Inputs
		reset = 0;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#10;
      reset = 1;
		 
		#50 reset = 0;
		// Add stimulus here

	end

	always
		#10 clk = ~clk;

endmodule


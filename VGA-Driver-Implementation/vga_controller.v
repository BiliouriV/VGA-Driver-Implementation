`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:24:15 11/28/2018 
// Design Name: 
// Module Name:    vga_controller 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vga_controller(reset, clk, VGA_RED, VGA_GREEN, VGA_BLUE, VGA_HSYNC, VGA_VSYNC);

input clk, reset;

output VGA_RED, VGA_GREEN, VGA_BLUE;
output VGA_HSYNC, VGA_VSYNC;


wire VGA_RED;
wire VGA_GREEN;
wire VGA_BLUE;
wire VGA_HSYNC;
wire VGA_VSYNC;

wire [6:0] pixel_haddr;
wire [6:0] pixel_vaddr;
wire [13:0] pixel_address;
wire sync_reset;
wire haddr_enable;
wire vaddr_enable;

assign pixel_address = {pixel_vaddr, pixel_haddr};

reset_synchronizer reset_synchronizerINSTANCE(.clk(clk),
															 .reset(reset),
															 .sync_reset(sync_reset)
															 );

hsync_controller hsync_controllerINSTANCE (.clk(clk),
														 .reset(sync_reset),
														 .pixel_haddr(pixel_haddr),
														 .HSYNC(VGA_HSYNC),
														 .haddr_enable(haddr_enable)
														 );

vsync_controller vsync_controllerINSTANCE (.clk(clk),
														 .reset(sync_reset),
														 .pixel_vaddr(pixel_vaddr),
														 .VSYNC(VGA_VSYNC),
														 .vaddr_enable(vaddr_enable)
														 );

VRAM VRAMINSTANCE (.clk(clk),
						 .reset(reset),
						 .pixel_addr(pixel_address),
						 .haddr_enable(haddr_enable),
						 .vaddr_enable(vaddr_enable),
						 .red_colour(VGA_RED),
						 .green_colour(VGA_GREEN),
						 .blue_colour(VGA_BLUE)
						 );




endmodule

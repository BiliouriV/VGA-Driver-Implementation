`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:09:29 11/28/2018 
// Design Name: 
// Module Name:    vsync_controller 
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
module vsync_controller(clk, reset, pixel_vaddr, VSYNC, vaddr_enable);

input clk, reset;

output pixel_vaddr;
output VSYNC;
output vaddr_enable;

reg VSYNC;
reg [6:0] pixel_vaddr;
reg [10:0] line_counter;
reg [3:0] pixel_revision_counter;
reg [6:0] current_pixel;
reg [19:0] period_counter;
reg [1:0] state;
reg vaddr_enable;

always @(posedge clk or posedge reset)
begin
	if (reset)
	begin
		period_counter = 20'b0;
		pixel_revision_counter = 4'b0;
		current_pixel = 7'b0000000;
		pixel_vaddr = 7'b0000000;
		state = 2'b00;
		VSYNC = 1;
		line_counter = 11'b0;
		vaddr_enable = 0;
	end
	else 
	begin
		case (state)
			2'b00:
			begin
				if (period_counter == 20'b00000000000000000000)			//Period P
				begin
					VSYNC = 0;
					pixel_vaddr = 7'b0;
					period_counter = period_counter + 11'd1;
					vaddr_enable = 0;
				end
				else if (period_counter == 20'd3199)			//Period Q
				begin
					VSYNC = 1;
					period_counter = 20'b00000000000000000000;
					state = state + 2'b01;
					vaddr_enable = 0;
				end
				else
				begin
					period_counter = period_counter + 20'b00000000000000000001;
					vaddr_enable = 0;
				end
			end
			2'b01:
			begin
				if (period_counter == 20'd46400)		//Period R
				begin
					vaddr_enable = 1;						//vram signal
					if (line_counter == 11'd1599)			//if a full line is displayed
					begin
						line_counter = 11'b0;
						if (pixel_revision_counter == 4'b0100)
						begin
							pixel_vaddr = current_pixel;
							pixel_revision_counter = 4'b0000;
							if (current_pixel == 7'd95)
							begin
								period_counter = 20'b00000000000000000000;
								state = state + 2'b01;
								current_pixel = 7'b0000000;
								pixel_vaddr = current_pixel;
								vaddr_enable = 0;
							end
							else 
							begin
								current_pixel = current_pixel + 7'b0000001;
							end
						end
						else
						begin
							pixel_revision_counter = pixel_revision_counter + 4'b0001;
							pixel_vaddr = current_pixel;
						end
					end
					else
					begin
						pixel_vaddr = current_pixel;
						line_counter = line_counter + 1;
					end
				end
				else 
				begin
					period_counter = period_counter + 20'b00000000000000000001;
				end
			end
			default:
			begin
				if (period_counter == 20'd15999)				//return
				begin
					current_pixel = 7'b0000000;
					period_counter = 20'b00000000000000000000;
					state = 2'b00;
					vaddr_enable = 0;
				end
				else
				begin
					period_counter = period_counter + 20'b00000000000000000001;
					pixel_vaddr = 7'b0;
					vaddr_enable = 0;
				end
			end
		endcase
	end
end






endmodule

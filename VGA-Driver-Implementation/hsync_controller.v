`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:42:45 11/28/2018 
// Design Name: 
// Module Name:    hsync_controller 
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
module hsync_controller(clk, reset, pixel_haddr, HSYNC, haddr_enable);

input clk, reset;

output pixel_haddr;
output HSYNC;
output haddr_enable;

reg HSYNC;
reg [6:0] pixel_haddr;
reg [3:0] pixel_revision_counter;
reg [6:0] current_pixel;
reg [10:0] period_counter;
reg [1:0] state;
reg haddr_enable;

always @(posedge clk or posedge reset)
begin
	if (reset)
	begin
		period_counter = 11'b0;
		pixel_revision_counter = 4'b0;
		current_pixel = 7'b0000000;
		pixel_haddr = 7'b0000000;
		state = 2'b00;
		HSYNC = 1;
		haddr_enable = 0;
	end
	else 
	begin
		case (state)
			2'b00:
			begin
				if (period_counter == 11'b00000000000)
				begin
					HSYNC = 0;
					pixel_haddr = 7'b0000000;
					period_counter = period_counter + 11'd1;
					haddr_enable = 0;
				end
				else if (period_counter == 11'd191)			//Period B
				begin
					HSYNC = 1;
					period_counter = 11'b00000000000;
					state = state + 2'b01;
					haddr_enable = 0;
				end
				else
				begin
					period_counter = period_counter + 11'b00000000001;
					haddr_enable = 0;
				end
			end
			2'b01:
			begin
				if (period_counter == 11'd96)		//Period C & D
				begin
					haddr_enable = 1;					//vram signal
					if (pixel_revision_counter == 4'b1001)
					begin
						pixel_haddr = current_pixel;
						pixel_revision_counter = 4'b0000;
						if (current_pixel == 7'b1111111)		//last pixel
						begin
							period_counter = 11'b00000000000;
							state = state + 2'b01;
							current_pixel = 7'b0000000;
							pixel_haddr = 7'b0000000;
							haddr_enable = 0;
						end
						else 
						begin
							current_pixel = current_pixel + 7'b0000001;
							pixel_haddr = current_pixel;
						end
					end
					else
					begin
						pixel_haddr = current_pixel;
						pixel_revision_counter = pixel_revision_counter + 4'b0001;
					end
				end
				else 
				begin
					period_counter = period_counter + 11'b00000000001;
				end
			end
			default:
			begin
				if (period_counter == 11'd31)				//return
				begin
					current_pixel = 7'b0000000;
					period_counter = 11'b00000000000;
					state = 2'b00;
					haddr_enable = 0;
				end
				else
				begin
					period_counter = period_counter + 11'b00000000001;
					pixel_haddr = 7'b0000000;
					haddr_enable = 0;
				end
			end
		endcase
	end
end


endmodule

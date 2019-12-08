`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:25:31 12/03/2018 
// Design Name: 
// Module Name:    reset_synchronizer 
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
module reset_synchronizer(clk, reset, sync_reset);

input clk, reset;
output sync_reset;
reg sync_reset, tmp_reset;

always @(posedge clk)
begin
	tmp_reset = reset;
end

always @(posedge clk)
begin
	sync_reset = tmp_reset;
end



endmodule

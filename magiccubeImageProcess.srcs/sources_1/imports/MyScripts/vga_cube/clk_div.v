`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/05 11:15:51
// Design Name: 
// Module Name: clk_div
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clk_div(
    input clk,
    output clk25,
    output clk1Hz
    );
reg [23:0]state;
always@(posedge clk)
begin
  state <= state+1'b1;
end
assign clk25=state[1];
assign clk1Hz=state[20];
endmodule

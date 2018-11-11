`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/05 15:33:07
// Design Name: 
// Module Name: vga_top
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


module vga_top(
input clk,//100M
input [26:0]front_in,
input [26:0]left_in,
input [26:0]right_in,
input [26:0]back_in,
input [26:0]above_in,
input [26:0]below_in,
output [3:0] vga_red,
output [3:0] vga_green,
output [3:0] vga_blue,
output vga_hsync,
output vga_vsync
    );
wire clk25;
wire [107:0]front_out;
wire [107:0]left_out;
wire [107:0]right_out;
wire [107:0]back_out;
wire[107:0]above_out;
wire [107:0]below_out;

reg [26:0]front;
reg [26:0]left;
reg [26:0]right;
reg [26:0]back;
reg [26:0]above;
reg [26:0]below;

clk_div(.clk(clk),.clk25(clk25));

input_trans(.front_in(front),.left_in(left),.right_in(right),.back_in(back),.above_in(above),.below_in(below),
            .front_out(front_out),.left_out(left_out),.right_out(right_out),
            .back_out(back_out),.above_out(above_out),.below_out(below_out));
vga_cube(.clk25(clk25),.front(front_out),.left(left_out),
         .right(right_out),.back(back_out),.above(above_out),.below(below_out),
         .vga_red(vga_red),.vga_green(vga_green),.vga_blue(vga_blue),
         .vga_hsync(vga_hsync),.vga_vsync(vga_vsync));
endmodule

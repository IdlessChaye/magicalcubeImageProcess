`timescale 1ns / 1ps
 /* 
    Copyright (C) 2018 Tongtong, github IdlessChaya

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/


module vga_top(
input clk,//100M
input en,
input rst,
input button,
//input [549:0]trans,

input [26:0]front,
input [26:0]left,
input [26:0]right,
input [26:0]back,
input [26:0]above,
input [26:0]below,
output [3:0] vga_red,
output [3:0] vga_green,
output [3:0] vga_blue,
output vga_hsync,
output vga_vsync,
output [16:0] frame_addr,
input [15:0] frame_pixel,
output[18:0] frame_addr_reader,
input[15:0] frame_pixel_reader
    );
wire clk25;
wire clk1Hz;
wire [107:0]front_out;
wire [107:0]left_out;
wire [107:0]right_out;
wire [107:0]back_out;
wire[107:0]above_out;
wire [107:0]below_out;

wire [26:0]front_1;
wire [26:0]left_1;
wire [26:0]right_1;
wire [26:0]back_1;
wire [26:0]above_1;
wire [26:0]below_1;
wire [4:0]state;
/*reg [26:0]front;
reg [26:0]left;
reg [26:0]right;
reg [26:0]back;
reg [26:0]above;
reg [26:0]below;*/
wire [549:0]trans_test;

/*initial
begin
  front = 27'b000_000_000_000_000_000_000_000_000;
  left  = 27'b011_011_011_011_011_011_011_011_011;
  right = 27'b010_010_010_010_010_010_010_010_010;
  back  = 27'b001_001_001_001_001_001_001_001_001 ;
  above = 27'b101_101_101_101_101_101_101_101_101;
  below = 27'b100_100_100_100_100_100_100_100_100;
end*/
  assign trans_test[89:0] = 90'b10110_10101_10100_10010_10001_10000_01110_01101_01100_01010_01001_01000_00110_00101_00100_00010_00001_00000;
  assign trans_test[549:90] = ~0;

clk_div(.clk(clk),.clk25(clk25),.clk1Hz(clk1Hz)
  );

cube_trans(.en(en),.rst(rst),.button_in(button),.clk(clk),.clk1Hz(clk1Hz),.trans(trans_test),
.front_in(front),.left_in(left),.right_in(right),.back_in(back),.above_in(above),.below_in(below),.state(state),
.front(front_1),.left(left_1),.right(right_1),.above(above_1),.below(below_1),.back(back_1)
);

input_trans(.front_in(front_1),.left_in(left_1),.right_in(right_1),.back_in(back_1),.above_in(above_1),.below_in(below_1),
            .front_out(front_out),.left_out(left_out),.right_out(right_out),
            .back_out(back_out),.above_out(above_out),.below_out(below_out)
            );

vga_cube(.clk25(clk25),.rst(rst),.front(front_out),.left(left_out),.state(state),
         .right(right_out),.back(back_out),.above(above_out),.below(below_out),
         .vga_red(vga_red),.vga_green(vga_green),.vga_blue(vga_blue),
         .vga_hsync(vga_hsync),.vga_vsync(vga_vsync),
          .frame_addr(frame_addr),
         .frame_pixel(frame_pixel),
         .frame_addr_reader(frame_addr_reader),
         .frame_pixel_reader(frame_pixel_reader)
         );
endmodule

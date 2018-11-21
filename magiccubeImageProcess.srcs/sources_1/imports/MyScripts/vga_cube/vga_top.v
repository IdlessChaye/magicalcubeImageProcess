 /* this program is the main part of vga module
    Copyright (C) 2018 Tongtong

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

`timescale 1ns / 1ns

module vga_top(
input clk25,
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
output vga_vsync,
output [16:0] frame_addr,
input [15:0] frame_pixel,
output[18:0] frame_addr_reader,
input[15:0] frame_pixel_reader
    );
wire [107:0]front_out;
wire [107:0]left_out;
wire [107:0]right_out;
wire [107:0]back_out;
wire[107:0]above_out;
wire [107:0]below_out;

input_trans(.front_in(front_in),.left_in(left_in),.right_in(right_in),.back_in(back_in),.above_in(above_in),.below_in(below_in),
            .front_out(front_out),.left_out(left_out),.right_out(right_out),
            .back_out(back_out),.above_out(above_out),.below_out(below_out));
vga_cube(.clk25(clk25),.front(front_out),.left(left_out),
         .right(right_out),.back(back_out),.above(above_out),.below(below_out),
         .vga_red(vga_red),.vga_green(vga_green),.vga_blue(vga_blue),
         .vga_hsync(vga_hsync),.vga_vsync(vga_vsync),
         .frame_addr(frame_addr),
         .frame_pixel(frame_pixel),
         .frame_addr_reader(frame_addr_reader),
         .frame_pixel_reader(frame_pixel_reader)
         );
endmodule

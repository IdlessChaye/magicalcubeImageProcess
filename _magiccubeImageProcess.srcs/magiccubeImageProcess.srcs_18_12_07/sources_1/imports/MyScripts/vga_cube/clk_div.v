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


module clk_div(
    input clk,
    output clk25,
    output clk1Hz
    );
reg [27:0]state;
always@(posedge clk)
begin
  state <= state+1'b1;
end
assign clk25=state[1];
assign clk1Hz=state[26];
endmodule

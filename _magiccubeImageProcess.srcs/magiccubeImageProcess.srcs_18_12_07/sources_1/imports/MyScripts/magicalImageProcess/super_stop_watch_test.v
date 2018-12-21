 /* this program is a interface of seven segments LED
    Copyright (C) 2018 IdlessChaye

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
module super_stop_watch_test(
        output[3:0] en0,en1,
        output[7:0] sseg0,sseg1,
        input[31:0] show_data,
        input clk
    );
    
    scan_hex_led_disp scan_hex_led_disp_unit0 (
        .clk(clk),.reset(1'b0),
        .hex3(show_data[15:12]),.hex2(show_data[11:8]),.hex1(show_data[7:4]),.hex0(show_data[3:0]),
        .dp(4'b0100),.en(en0),.sseg(sseg0)
    );
    scan_hex_led_disp scan_hex_led_disp_unit1 (
        .clk(clk),.reset(1'b0),
        .hex3(show_data[31:28]),.hex2(show_data[27:24]),.hex1(show_data[23:20]),.hex0(show_data[19:16]),
        .dp(4'b0101),.en(en1),.sseg(sseg1)
    );
endmodule
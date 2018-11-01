 /* this program is to drive seven segments LED
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
module scan_hex_led_disp(
        input clk,reset,
        input [3:0] hex3,hex2,hex1,hex0,
        input [3:0] dp,
        output reg[3:0] en, // enable
        output reg[7:0] sseg
    );

    localparam N = 18;
    reg[N-1:0] countN;

    reg[3:0] hex_sel; // hex_selected

    always @ (posedge clk,posedge reset)
        if(reset)
            countN <= 0;
        else
            countN <= countN + 1;
    
    always @ *
        case(countN[N-1:N-2])
            2'b00: begin
                hex_sel = hex0;
                sseg[7] = dp[0];
                en = 4'b0001;
                end
            2'b01: begin
                hex_sel = hex1;
                sseg[7] = dp[1];
                en = 4'b0010;
                end
            2'b10: begin
                hex_sel = hex2;
                sseg[7] = dp[2];
                en = 4'b0100;
                end
            default: begin
                hex_sel = hex3;
                sseg[7] = dp[3];
                en = 4'b1000;
                end
        endcase

    always @ * 
        case(hex_sel)
            4'h0: sseg[6:0] = 7'b0111111;
            4'h1: sseg[6:0] = 7'b0000110;
            4'h2: sseg[6:0] = 7'b1011011;
            4'h3: sseg[6:0] = 7'b1001111;
            4'h4: sseg[6:0] = 7'b1100110;
            4'h5: sseg[6:0] = 7'b1101101;
            4'h6: sseg[6:0] = 7'b1111101;
            4'h7: sseg[6:0] = 7'b0000111;
            4'h8: sseg[6:0] = 7'b1111111;
            4'h9: sseg[6:0] = 7'b1101111;
            4'ha: sseg[6:0] = 7'b1110111;
            4'hb: sseg[6:0] = 7'b1111100;
            4'hc: sseg[6:0] = 7'b0111001;
            4'hd: sseg[6:0] = 7'b1011110;
            4'he: sseg[6:0] = 7'b1111001;
            default:  sseg[6:0] = 7'b1110001; // 4'hf
        endcase
endmodule


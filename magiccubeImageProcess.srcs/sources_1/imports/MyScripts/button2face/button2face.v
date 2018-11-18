 /* this program is to transfer button signals into select_coding
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

//
`timescale 1ns / 1ns
module button2face (
    input[5:0] face_select_signals,
    output[2:0] face_select
    );
    reg[2:0] face_select_reg = 0;
    assign face_select = face_select_reg;
    always @ *
        case(face_select_signals)
            6'b000001: face_select_reg = 3'b001;
            6'b000010: face_select_reg = 3'b010;
            6'b000100: face_select_reg = 3'b011;
            6'b001000: face_select_reg = 3'b100;
            6'b010000: face_select_reg = 3'b101;
            6'b100000: face_select_reg = 3'b110;
            default: face_select_reg = 3'b111;
        endcase
endmodule
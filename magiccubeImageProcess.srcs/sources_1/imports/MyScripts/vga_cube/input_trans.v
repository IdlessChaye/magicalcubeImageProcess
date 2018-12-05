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


module input_trans(
input [26:0]front_in,
input [26:0]left_in,
input [26:0]right_in,
input [26:0]back_in,
input [26:0]above_in,
input [26:0]below_in,
output reg [107:0]front_out,
output reg [107:0]left_out,
output reg [107:0]right_out,
output reg [107:0]back_out,
output reg [107:0]above_out,
output reg [107:0]below_out
    );
always @*
begin
case(below_in[26:24])
        3'b001:below_out[107:96]<=12'hf00;
        3'b010:below_out[107:96]<=12'h000;
        3'b011:below_out[107:96]<=12'hff0;
        3'b100:below_out[107:96]<=12'h0f0;
        3'b101:below_out[107:96]<=12'h00f;
        3'b110:below_out[107:96]<=12'hfff;
        default:below_out[107:96]<=12'h000;
endcase
case(below_in[23:21])
        3'b001:below_out[95:84]<=12'hf00;
        3'b010:below_out[95:84]<=12'h000;
        3'b011:below_out[95:84]<=12'hff0;
        3'b100:below_out[95:84]<=12'h0f0;
        3'b101:below_out[95:84]<=12'h00f;
        3'b110:below_out[95:84]<=12'hfff;
        default:below_out[95:84]<=12'h000;
endcase
case(below_in[20:18])
        3'b001:below_out[83:72]<=12'hf00;
        3'b010:below_out[83:72]<=12'h000;
        3'b011:below_out[83:72]<=12'hff0;
        3'b100:below_out[83:72]<=12'h0f0;
        3'b101:below_out[83:72]<=12'h00f;
        3'b110:below_out[83:72]<=12'hfff;
default:below_out[83:72]<=12'h000;
endcase
case(below_in[17:15])
       3'b001:below_out[71:60]<=12'hf00;
       3'b010:below_out[71:60]<=12'h000;
       3'b011:below_out[71:60]<=12'hff0;
       3'b100:below_out[71:60]<=12'h0f0;
       3'b101:below_out[71:60]<=12'h00f;
       3'b110:below_out[71:60]<=12'hfff;
       default:below_out[71:60]<=12'h000;
endcase
case(below_in[14:12])
       3'b001:below_out[59:48]<=12'hf00;
       3'b010:below_out[59:48]<=12'h000;
       3'b011:below_out[59:48]<=12'hff0;
       3'b100:below_out[59:48]<=12'h0f0;
       3'b101:below_out[59:48]<=12'h00f;
       3'b110:below_out[59:48]<=12'hfff;
       default:below_out[59:48]<=12'h000;
endcase
case(below_in[11:9])
       3'b001:below_out[47:36]<=12'hf00;
       3'b010:below_out[47:36]<=12'h000;
       3'b011:below_out[47:36]<=12'hff0;
       3'b100:below_out[47:36]<=12'h0f0;
       3'b101:below_out[47:36]<=12'h00f;
       3'b110:below_out[47:36]<=12'hfff;
       default:below_out[47:36]<=12'h000;
endcase
case(below_in[8:6])
       3'b001:below_out[35:24]<=12'hf00;
       3'b010:below_out[35:24]<=12'h000;
       3'b011:below_out[35:24]<=12'hff0;
       3'b100:below_out[35:24]<=12'h0f0;
       3'b101:below_out[35:24]<=12'h00f;
       3'b110:below_out[35:24]<=12'hfff;
       default:below_out[35:24]<=12'h000;
endcase
case(below_in[5:3])
       3'b001:below_out[23:12]<=12'hf00;
       3'b010:below_out[23:12]<=12'h000;
       3'b011:below_out[23:12]<=12'hff0;
       3'b100:below_out[23:12]<=12'h0f0;
       3'b101:below_out[23:12]<=12'h00f;
       3'b110:below_out[23:12]<=12'hfff;
       default:below_out[23:12]<=12'h000;
endcase
case(below_in[2:0])
       3'b001:below_out[11:0]<=12'hf00;
       3'b010:below_out[11:0]<=12'h000;
       3'b011:below_out[11:0]<=12'hff0;
       3'b100:below_out[11:0]<=12'h0f0;
       3'b101:below_out[11:0]<=12'h00f;
       3'b110:below_out[11:0]<=12'hfff;
       default:below_out[11:0]<=12'h000;
endcase

case(front_in[26:24])
        3'b001:front_out[107:96]<=12'hf00;
        3'b010:front_out[107:96]<=12'h000;
        3'b011:front_out[107:96]<=12'hff0;
        3'b100:front_out[107:96]<=12'h0f0;
        3'b101:front_out[107:96]<=12'h00f;
        3'b110:front_out[107:96]<=12'hfff;
        default:front_out[107:96]<=12'h000;
endcase
case(front_in[23:21])
        3'b001:front_out[95:84]<=12'hf00;
        3'b010:front_out[95:84]<=12'h000;
        3'b011:front_out[95:84]<=12'hff0;
        3'b100:front_out[95:84]<=12'h0f0;
        3'b101:front_out[95:84]<=12'h00f;
        3'b110:front_out[95:84]<=12'hfff;
        default:front_out[95:84]<=12'h000;
endcase
case(front_in[20:18])
        3'b001:front_out[83:72]<=12'hf00;
        3'b010:front_out[83:72]<=12'h000;
        3'b011:front_out[83:72]<=12'hff0;
        3'b100:front_out[83:72]<=12'h0f0;
        3'b101:front_out[83:72]<=12'h00f;
        3'b110:front_out[83:72]<=12'hfff;
        default:front_out[83:72]<=12'h000;
endcase
case(front_in[17:15])
       3'b001:front_out[71:60]<=12'hf00;
       3'b010:front_out[71:60]<=12'h000;
       3'b011:front_out[71:60]<=12'hff0;
       3'b100:front_out[71:60]<=12'h0f0;
       3'b101:front_out[71:60]<=12'h00f;
       3'b110:front_out[71:60]<=12'hfff;
       default:front_out[71:60]<=12'h000;
endcase
case(front_in[14:12])
       3'b001:front_out[59:48]<=12'hf00;
       3'b010:front_out[59:48]<=12'h000;
       3'b011:front_out[59:48]<=12'hff0;
       3'b100:front_out[59:48]<=12'h0f0;
       3'b101:front_out[59:48]<=12'h00f;
       3'b110:front_out[59:48]<=12'hfff;
       default:front_out[59:48]<=12'h000;
endcase
case(front_in[11:9])
       3'b001:front_out[47:36]<=12'hf00;
       3'b010:front_out[47:36]<=12'h000;
       3'b011:front_out[47:36]<=12'hff0;
       3'b100:front_out[47:36]<=12'h0f0;
       3'b101:front_out[47:36]<=12'h00f;
       3'b110:front_out[47:36]<=12'hfff;
       default:front_out[47:36]<=12'h000;
endcase
case(front_in[8:6])
       3'b001:front_out[35:24]<=12'hf00;
       3'b010:front_out[35:24]<=12'h000;
       3'b011:front_out[35:24]<=12'hff0;
       3'b100:front_out[35:24]<=12'h0f0;
       3'b101:front_out[35:24]<=12'h00f;
       3'b110:front_out[35:24]<=12'hfff;
       default:front_out[35:24]<=12'h000;
endcase
case(front_in[5:3])
       3'b001:front_out[23:12]<=12'hf00;
       3'b010:front_out[23:12]<=12'h000;
       3'b011:front_out[23:12]<=12'hff0;
       3'b100:front_out[23:12]<=12'h0f0;
       3'b101:front_out[23:12]<=12'h00f;
       3'b110:front_out[23:12]<=12'hfff;
       default:front_out[23:12]<=12'h000;
endcase
case(front_in[2:0])
       3'b001:front_out[11:0]<=12'hf00;
       3'b010:front_out[11:0]<=12'h000;
       3'b011:front_out[11:0]<=12'hff0;
       3'b100:front_out[11:0]<=12'h0f0;
       3'b101:front_out[11:0]<=12'h00f;
       3'b110:front_out[11:0]<=12'hfff;
       default:front_out[11:0]<=12'h000;
endcase

case(left_in[26:24])
        3'b001:left_out[107:96]<=12'hf00;
        3'b010:left_out[107:96]<=12'h000;
        3'b011:left_out[107:96]<=12'hff0;
        3'b100:left_out[107:96]<=12'h0f0;
        3'b101:left_out[107:96]<=12'h00f;
        3'b110:left_out[107:96]<=12'hfff;
        default:left_out[107:96]<=12'h000;
endcase
case(left_in[23:21])
        3'b001:left_out[95:84]<=12'hf00;
        3'b010:left_out[95:84]<=12'h000;
        3'b011:left_out[95:84]<=12'hff0;
        3'b100:left_out[95:84]<=12'h0f0;
        3'b101:left_out[95:84]<=12'h00f;
        3'b110:left_out[95:84]<=12'hfff;
        default:left_out[95:84]<=12'h000;
endcase
case(left_in[20:18])
        3'b001:left_out[83:72]<=12'hf00;
        3'b010:left_out[83:72]<=12'h000;
        3'b011:left_out[83:72]<=12'hff0;
        3'b100:left_out[83:72]<=12'h0f0;
        3'b101:left_out[83:72]<=12'h00f;
        3'b110:left_out[83:72]<=12'hfff;
default:left_out[83:72]<=12'h000;
endcase
case(left_in[17:15])
       3'b001:left_out[71:60]<=12'hf00;
       3'b010:left_out[71:60]<=12'h000;
       3'b011:left_out[71:60]<=12'hff0;
       3'b100:left_out[71:60]<=12'h0f0;
       3'b101:left_out[71:60]<=12'h00f;
       3'b110:left_out[71:60]<=12'hfff;
       default:left_out[71:60]<=12'h000;
endcase
case(left_in[14:12])
       3'b001:left_out[59:48]<=12'hf00;
       3'b010:left_out[59:48]<=12'h000;
       3'b011:left_out[59:48]<=12'hff0;
       3'b100:left_out[59:48]<=12'h0f0;
       3'b101:left_out[59:48]<=12'h00f;
       3'b110:left_out[59:48]<=12'hfff;
       default:left_out[59:48]<=12'h000;
endcase
case(left_in[11:9])
       3'b001:left_out[47:36]<=12'hf00;
       3'b010:left_out[47:36]<=12'h000;
       3'b011:left_out[47:36]<=12'hff0;
       3'b100:left_out[47:36]<=12'h0f0;
       3'b101:left_out[47:36]<=12'h00f;
       3'b110:left_out[47:36]<=12'hfff;
       default:left_out[47:36]<=12'h000;
endcase
case(left_in[8:6])
       3'b001:left_out[35:24]<=12'hf00;
       3'b010:left_out[35:24]<=12'h000;
       3'b011:left_out[35:24]<=12'hff0;
       3'b100:left_out[35:24]<=12'h0f0;
       3'b101:left_out[35:24]<=12'h00f;
       3'b110:left_out[35:24]<=12'hfff;
       default:left_out[35:24]<=12'h000;
endcase
case(left_in[5:3])
       3'b001:left_out[23:12]<=12'hf00;
       3'b010:left_out[23:12]<=12'h000;
       3'b011:left_out[23:12]<=12'hff0;
       3'b100:left_out[23:12]<=12'h0f0;
       3'b101:left_out[23:12]<=12'h00f;
       3'b110:left_out[23:12]<=12'hfff;
       default:left_out[23:12]<=12'h000;
endcase
case(left_in[2:0])
       3'b001:left_out[11:0]<=12'hf00;
       3'b010:left_out[11:0]<=12'h000;
       3'b011:left_out[11:0]<=12'hff0;
       3'b100:left_out[11:0]<=12'h0f0;
       3'b101:left_out[11:0]<=12'h00f;
       3'b110:left_out[11:0]<=12'hfff;
       default:left_out[11:0]<=12'h000;
endcase

case(right_in[26:24])
        3'b001:right_out[107:96]<=12'hf00;
        3'b010:right_out[107:96]<=12'h000;
        3'b011:right_out[107:96]<=12'hff0;
        3'b100:right_out[107:96]<=12'h0f0;
        3'b101:right_out[107:96]<=12'h00f;
        3'b110:right_out[107:96]<=12'hfff;
        default:right_out[107:96]<=12'h000;
endcase
case(right_in[23:21])
        3'b001:right_out[95:84]<=12'hf00;
        3'b010:right_out[95:84]<=12'h000;
        3'b011:right_out[95:84]<=12'hff0;
        3'b100:right_out[95:84]<=12'h0f0;
        3'b101:right_out[95:84]<=12'h00f;
        3'b110:right_out[95:84]<=12'hfff;
        default:right_out[95:84]<=12'h000;
endcase
case(right_in[20:18])
        3'b001:right_out[83:72]<=12'hf00;
        3'b010:right_out[83:72]<=12'h000;
        3'b011:right_out[83:72]<=12'hff0;
        3'b100:right_out[83:72]<=12'h0f0;
        3'b101:right_out[83:72]<=12'h00f;
        3'b110:right_out[83:72]<=12'hfff;
default:right_out[83:72]<=12'h000;
endcase
case(right_in[17:15])
       3'b001:right_out[71:60]<=12'hf00;
       3'b010:right_out[71:60]<=12'h000;
       3'b011:right_out[71:60]<=12'hff0;
       3'b100:right_out[71:60]<=12'h0f0;
       3'b101:right_out[71:60]<=12'h00f;
       3'b110:right_out[71:60]<=12'hfff;
       default:right_out[71:60]<=12'h000;
endcase
case(right_in[14:12])
       3'b001:right_out[59:48]<=12'hf00;
       3'b010:right_out[59:48]<=12'h000;
       3'b011:right_out[59:48]<=12'hff0;
       3'b100:right_out[59:48]<=12'h0f0;
       3'b101:right_out[59:48]<=12'h00f;
       3'b110:right_out[59:48]<=12'hfff;
       default:right_out[59:48]<=12'h000;
endcase
case(right_in[11:9])
       3'b001:right_out[47:36]<=12'hf00;
       3'b010:right_out[47:36]<=12'h000;
       3'b011:right_out[47:36]<=12'hff0;
       3'b100:right_out[47:36]<=12'h0f0;
       3'b101:right_out[47:36]<=12'h00f;
       3'b110:right_out[47:36]<=12'hfff;
       default:right_out[47:36]<=12'h000;
endcase
case(right_in[8:6])
       3'b001:right_out[35:24]<=12'hf00;
       3'b010:right_out[35:24]<=12'h000;
       3'b011:right_out[35:24]<=12'hff0;
       3'b100:right_out[35:24]<=12'h0f0;
       3'b101:right_out[35:24]<=12'h00f;
       3'b110:right_out[35:24]<=12'hfff;
       default:right_out[35:24]<=12'h000;
endcase
case(right_in[5:3])
       3'b001:right_out[23:12]<=12'hf00;
       3'b010:right_out[23:12]<=12'h000;
       3'b011:right_out[23:12]<=12'hff0;
       3'b100:right_out[23:12]<=12'h0f0;
       3'b101:right_out[23:12]<=12'h00f;
       3'b110:right_out[23:12]<=12'hfff;
       default:right_out[23:12]<=12'h000;
endcase
case(right_in[2:0])
       3'b001:right_out[11:0]<=12'hf00;
       3'b010:right_out[11:0]<=12'h000;
       3'b011:right_out[11:0]<=12'hff0;
       3'b100:right_out[11:0]<=12'h0f0;
       3'b101:right_out[11:0]<=12'h00f;
       3'b110:right_out[11:0]<=12'hfff;
       default:right_out[11:0]<=12'h000;
endcase

case(back_in[26:24])
        3'b001:back_out[107:96]<=12'hf00;
        3'b010:back_out[107:96]<=12'h000;
        3'b011:back_out[107:96]<=12'hff0;
        3'b100:back_out[107:96]<=12'h0f0;
        3'b101:back_out[107:96]<=12'h00f;
        3'b110:back_out[107:96]<=12'hfff;
        default:back_out[107:96]<=12'h000;
endcase
case(back_in[23:21])
        3'b001:back_out[95:84]<=12'hf00;
        3'b010:back_out[95:84]<=12'h000;
        3'b011:back_out[95:84]<=12'hff0;
        3'b100:back_out[95:84]<=12'h0f0;
        3'b101:back_out[95:84]<=12'h00f;
        3'b110:back_out[95:84]<=12'hfff;
        default:back_out[95:84]<=12'h000;
endcase
case(back_in[20:18])
        3'b001:back_out[83:72]<=12'hf00;
        3'b010:back_out[83:72]<=12'h000;
        3'b011:back_out[83:72]<=12'hff0;
        3'b100:back_out[83:72]<=12'h0f0;
        3'b101:back_out[83:72]<=12'h00f;
        3'b110:back_out[83:72]<=12'hfff;
default:back_out[83:72]<=12'h000;
endcase
case(back_in[17:15])
       3'b001:back_out[71:60]<=12'hf00;
       3'b010:back_out[71:60]<=12'h000;
       3'b011:back_out[71:60]<=12'hff0;
       3'b100:back_out[71:60]<=12'h0f0;
       3'b101:back_out[71:60]<=12'h00f;
       3'b110:back_out[71:60]<=12'hfff;
       default:back_out[71:60]<=12'h000;
endcase
case(back_in[14:12])
       3'b001:back_out[59:48]<=12'hf00;
       3'b010:back_out[59:48]<=12'h000;
       3'b011:back_out[59:48]<=12'hff0;
       3'b100:back_out[59:48]<=12'h0f0;
       3'b101:back_out[59:48]<=12'h00f;
       3'b110:back_out[59:48]<=12'hfff;
       default:back_out[59:48]<=12'h000;
endcase
case(back_in[11:9])
       3'b001:back_out[47:36]<=12'hf00;
       3'b010:back_out[47:36]<=12'h000;
       3'b011:back_out[47:36]<=12'hff0;
       3'b100:back_out[47:36]<=12'h0f0;
       3'b101:back_out[47:36]<=12'h00f;
       3'b110:back_out[47:36]<=12'hfff;
       default:back_out[47:36]<=12'h000;
endcase
case(back_in[8:6])
       3'b001:back_out[35:24]<=12'hf00;
       3'b010:back_out[35:24]<=12'h000;
       3'b011:back_out[35:24]<=12'hff0;
       3'b100:back_out[35:24]<=12'h0f0;
       3'b101:back_out[35:24]<=12'h00f;
       3'b110:back_out[35:24]<=12'hfff;
       default:back_out[35:24]<=12'h000;
endcase
case(back_in[5:3])
       3'b001:back_out[23:12]<=12'hf00;
       3'b010:back_out[23:12]<=12'h000;
       3'b011:back_out[23:12]<=12'hff0;
       3'b100:back_out[23:12]<=12'h0f0;
       3'b101:back_out[23:12]<=12'h00f;
       3'b110:back_out[23:12]<=12'hfff;
       default:back_out[23:12]<=12'h000;
endcase
case(back_in[2:0])
       3'b001:back_out[11:0]<=12'hf00;
       3'b010:back_out[11:0]<=12'h000;
       3'b011:back_out[11:0]<=12'hff0;
       3'b100:back_out[11:0]<=12'h0f0;
       3'b101:back_out[11:0]<=12'h00f;
       3'b110:back_out[11:0]<=12'hfff;
       default:back_out[11:0]<=12'h000;
endcase

case(above_in[26:24])
        3'b001:above_out[107:96]<=12'hf00;
        3'b010:above_out[107:96]<=12'h000;
        3'b011:above_out[107:96]<=12'hff0;
        3'b100:above_out[107:96]<=12'h0f0;
        3'b101:above_out[107:96]<=12'h00f;
        3'b110:above_out[107:96]<=12'hfff;
        default:above_out[107:96]<=12'h000;
endcase
case(above_in[23:21])
        3'b001:above_out[95:84]<=12'hf00;
        3'b010:above_out[95:84]<=12'h000;
        3'b011:above_out[95:84]<=12'hff0;
        3'b100:above_out[95:84]<=12'h0f0;
        3'b101:above_out[95:84]<=12'h00f;
        3'b110:above_out[95:84]<=12'hfff;
        default:above_out[95:84]<=12'h000;
endcase
case(above_in[20:18])
        3'b001:above_out[83:72]<=12'hf00;
        3'b010:above_out[83:72]<=12'h000;
        3'b011:above_out[83:72]<=12'hff0;
        3'b100:above_out[83:72]<=12'h0f0;
        3'b101:above_out[83:72]<=12'h00f;
        3'b110:above_out[83:72]<=12'hfff;
default:above_out[83:72]<=12'h000;
endcase
case(above_in[17:15])
       3'b001:above_out[71:60]<=12'hf00;
       3'b010:above_out[71:60]<=12'h000;
       3'b011:above_out[71:60]<=12'hff0;
       3'b100:above_out[71:60]<=12'h0f0;
       3'b101:above_out[71:60]<=12'h00f;
       3'b110:above_out[71:60]<=12'hfff;
       default:above_out[71:60]<=12'h000;
endcase
case(above_in[14:12])
       3'b001:above_out[59:48]<=12'hf00;
       3'b010:above_out[59:48]<=12'h000;
       3'b011:above_out[59:48]<=12'hff0;
       3'b100:above_out[59:48]<=12'h0f0;
       3'b101:above_out[59:48]<=12'h00f;
       3'b110:above_out[59:48]<=12'hfff;
       default:above_out[59:48]<=12'h000;
endcase
case(above_in[11:9])
       3'b001:above_out[47:36]<=12'hf00;
       3'b010:above_out[47:36]<=12'h000;
       3'b011:above_out[47:36]<=12'hff0;
       3'b100:above_out[47:36]<=12'h0f0;
       3'b101:above_out[47:36]<=12'h00f;
       3'b110:above_out[47:36]<=12'hfff;
       default:above_out[47:36]<=12'h000;
endcase
case(above_in[8:6])
       3'b001:above_out[35:24]<=12'hf00;
       3'b010:above_out[35:24]<=12'h000;
       3'b011:above_out[35:24]<=12'hff0;
       3'b100:above_out[35:24]<=12'h0f0;
       3'b101:above_out[35:24]<=12'h00f;
       3'b110:above_out[35:24]<=12'hfff;
       default:above_out[35:24]<=12'h000;
endcase
case(above_in[5:3])
       3'b001:above_out[23:12]<=12'hf00;
       3'b010:above_out[23:12]<=12'h000;
       3'b011:above_out[23:12]<=12'hff0;
       3'b100:above_out[23:12]<=12'h0f0;
       3'b101:above_out[23:12]<=12'h00f;
       3'b110:above_out[23:12]<=12'hfff;
       default:above_out[23:12]<=12'h000;
endcase
case(above_in[2:0])
       3'b001:above_out[11:0]<=12'hf00;
       3'b010:above_out[11:0]<=12'h000;
       3'b011:above_out[11:0]<=12'hff0;
       3'b100:above_out[11:0]<=12'h0f0;
       3'b101:above_out[11:0]<=12'h00f;
       3'b110:above_out[11:0]<=12'hfff;
       default:above_out[11:0]<=12'h000;
endcase

end   
endmodule

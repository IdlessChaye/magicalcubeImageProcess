 /* this program is to set data of one side on magiccube
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
module magic_side_data_set (
    input clk,
    input rst,

    input enable,

    input[8:0] position_coding,
    input[2:0] color_coding,
    output reg[26:0] oneside_dout,

    output reg done
);


localparam s_idle    = 3'b000;
localparam s_init    = 3'b001;
localparam s_update  = 3'b011;
localparam s_done    = 3'b010;
localparam s_ready   = 3'b110;
reg[2:0] status = s_idle;

always@(posedge clk) begin
    if(rst) begin
        done <= 0;
        oneside_dout <= 0;

        status <= s_idle;
    end else begin
        case(status) 
            s_idle: begin
                done <= 0;

                if(enable) begin
                    status <= s_init;
                end else begin
                    status <= s_idle;
                end
            end
            s_init: begin
                status <= s_update;
            end
            s_update: begin
                case(position_coding) 
                    9'd1: oneside_dout[2:0] <= color_coding;
                    9'd2: oneside_dout[5:3] <= color_coding;
                    9'd3: oneside_dout[8:6] <= color_coding;
                    9'd4: oneside_dout[11:9] <= color_coding;
                    9'd5: oneside_dout[14:12] <= color_coding;
                    9'd6: oneside_dout[17:15] <= color_coding;
                    9'd7: oneside_dout[20:18] <= color_coding;
                    9'd8: oneside_dout[23:21] <= color_coding;
                    9'd9: oneside_dout[26:24] <= color_coding;
                    default: begin
                        // nop
                    end
                endcase

                status <= s_done;
            end
            s_done: begin
                done <= 1;

                status <= s_ready;
            end
            s_ready: begin
                done <= 0;

                status <= s_idle; 
            end
            default: begin
                status <= s_idle; 
            end
        endcase
    end
end

endmodule
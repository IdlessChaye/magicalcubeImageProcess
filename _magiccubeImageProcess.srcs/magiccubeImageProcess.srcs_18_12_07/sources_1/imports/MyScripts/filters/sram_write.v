 /* this program is a sram writer for mean filter module on github
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

module sram_write(
    input wclk,
    input rst,

    input enable,
    input[4:0] num_write, // the num continue to write
    input[18:0] addr,
    input[15:0] data,

    output reg selec,
    output reg write,
    output reg read,
    output reg[18:0] addr_wr,
    output reg[15:0] data_wr_in,
    
    output reg done
);

reg[4:0] count_write;

localparam s_idle     = 4'b0000;
localparam s_write    = 4'b0001;
localparam s_write_wait = 4'b0010;
reg[3:0] status = s_idle;

always @ (posedge wclk) begin
    if(rst) begin
        selec  <= 0;
        write  <= 0;
        read   <= 0;
        addr_wr  <= 0;
        data_wr_in <= 0;
        count_write <= 0;
        done <= 0;
        status <= s_idle;
    end else begin
        case(status)
            s_idle: begin
                done <= 0;
                selec <= 1;
                write <= 1;
                read <= 0;
                addr_wr <= addr;
                data_wr_in <= data;
                count_write <= num_write;
                if(enable) begin
                    status <= s_write_wait;
                end
            end
            s_write: begin
                count_write <= count_write - 1;
                if(count_write == 1) begin
                    done <= 1;
                    status <= s_idle;
                end else begin
                    addr_wr  <= addr;
                    data_wr_in <= data;
                    status <= s_write_wait;
                end
            end
            s_write_wait: begin
                status <= s_write;
            end
            default: begin
                status <= s_idle;
            end
        endcase
    end
end

endmodule
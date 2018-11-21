 /* this program is a sram reader for median filter module on github
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
module sram_read(
    input wclk,
    input rst,

    input enable,
    input[4:0] num_read, // the num continue to read
    input[18:0] addr,

    output reg selec,
    output reg write,
    output reg read,
    output reg[18:0] addr_wr,
    
    output reg done
);

reg[4:0] count_read;

localparam s_idle     = 4'b0000;
localparam s_read     = 4'b0001;
reg[3:0] status = s_idle;

always @ (posedge wclk) begin
    if(rst) begin
        selec  <= 0;
        write  <= 0;
        read   <= 0;
        addr_wr  <= 0;
        count_read <= 0;
        done <= 0;
        status <= s_idle;
    end else begin
        case(status)
            s_idle: begin
                done <= 0;
                selec <= 1;
                write <= 0;
                read <= 1;
                addr_wr <= addr;
                count_read <= num_read;
                if(enable) begin
                    status <= s_read;
                end
            end
            s_read: begin
                count_read <= count_read - 1;
                if(count_read == 1) begin
                    done <= 1;
                    status <= s_idle;
                end else begin
                    addr_wr <= addr;
                end
            end
            default: begin
                status <= s_idle;
            end
        endcase
    end
end

endmodule
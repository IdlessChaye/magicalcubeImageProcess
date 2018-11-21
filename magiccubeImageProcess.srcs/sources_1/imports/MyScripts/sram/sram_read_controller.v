 /* this program can tranfer data of sram to vga module
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
module sram_read_controller(
    input enable,

    output reg selec_reader,
    output reg write_reader,
    output reg read_reader,
    output reg[18:0] addr_wr_reader,
    input[15:0] data_wr_out_reader,

    input[18:0] addr_wr,
    output[15:0] data_wr_out
);

assign data_wr_out = data_wr_out_reader;

always@* begin
    if(enable) begin
        selec_reader = 1;
        read_reader  = 1;
        write_reader = 0;
        addr_wr_reader = addr_wr;
    end else begin
        selec_reader = 0;
        read_reader =  0;
        write_reader = 0;
        addr_wr_reader = 0;
    end
end

endmodule

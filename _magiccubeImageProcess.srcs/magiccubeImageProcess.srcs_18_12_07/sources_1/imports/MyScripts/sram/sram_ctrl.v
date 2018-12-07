 /* this program is to drive sram
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
module sram_ctrl(
    input wire	clk,
    input wire	rst_n,

    input selec,
    input write,
    input read,
    input      [15:0] data_wr_in,
	output reg [15:0] data_wr_out=0,
	input wire [18:0] addr_wr,

	inout wire [15:0] sram_data,
	output wire [18:0] sram_addr,
    output reg		  sram_oe_r,
    output reg		  sram_ce_r,
    output reg		  sram_we_r,
    output reg		  sram_ub_r,
    output reg		  sram_lb_r
);

assign sram_addr = addr_wr;

reg	en = 1;
reg[15:0] data_wr=0;
assign sram_data = (en)? 16'bz : data_wr;

always@(posedge clk)
	if(!rst_n) begin
        sram_oe_r <= 1'b1;
        sram_we_r <= 1'b1;
        sram_ce_r <= 1'b1;
        sram_ub_r <= 1'b1;
        sram_lb_r <= 1'b1;
		en <= 1;
	end
	else if(selec) begin
		if(write ==1'b1 && read==1'b0) begin   //write
			sram_oe_r <= 1'b1;
			sram_ce_r <= 1'b0;
			sram_we_r <= 1'b0;
			sram_ub_r <= 1'b0;
			sram_lb_r <= 1'b0;
			en <= 0;
		end
		else if(read==1'b1 && write==1'b0) begin   //read
			sram_oe_r <= 1'b0;
			sram_ce_r <= 1'b0;
			sram_we_r <= 1'b1;        
			sram_ub_r <= 1'b0;
			sram_lb_r <= 1'b0;
			en <= 1;
		end
		else begin
			sram_oe_r <= 1'b1;
			sram_ce_r <= 1'b1;
			sram_we_r <= 1'b1;        
			sram_ub_r <= 1'b1;
			sram_lb_r <= 1'b1;
			en <= 1;			
		end
    end else begin
        sram_oe_r <= 1'b1;
        sram_ce_r <= 1'b1;
        sram_we_r <= 1'b1;
        sram_ub_r <= 1'b1;
        sram_lb_r <= 1'b1;
        en <= 1;
    end

always @ (negedge clk)  // write need 2 Ts
	if(write ==1'b1 && read==1'b0)
		data_wr <= data_wr_in;

always @ (negedge clk) // read need 1 T
	if(!rst_n)
		data_wr_out <= 0;
	else if(read==1'b1 && write==1'b0)
		data_wr_out <= sram_data;	

endmodule

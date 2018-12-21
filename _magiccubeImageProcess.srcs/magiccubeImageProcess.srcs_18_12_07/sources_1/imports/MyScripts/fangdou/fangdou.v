 /* this program is to defend button from tremble
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

module fangdou(
	input clk,
	input button,
	output fangdou_button
    );
    
	reg go = 0;

	localparam N = 20;
	reg[N-1:0] count=0;
	always @(posedge clk) begin
		if (go) begin
			count <= count + 1;
		end
		else 
			count <= 0;
	end	

	wire tick;
	assign tick = (count == 2**N-1);

	localparam[1:0] s0 = 2'b00,
					s1 = 2'b01,
					s2 = 2'b11,
					s3 = 2'b10;

	reg[1:0] state_reg=s0,state_next=s0;

	always @ (posedge clk) begin
		state_reg <= state_next;
	end
	
	always @ * begin
		state_next = state_reg;
		case(state_reg)
			s0: begin
				if(button == 1) begin
					go = 1;
					state_next = s1;
				end else
				    go = 0;
			end
			s1: begin
				if(button == 1) begin
					if(tick == 1) begin
						state_next = s2;	
						go = 0;					
					end else begin
					    go = 1;
					end
				end
				else begin
					state_next = s0;
					go = 0;
				end
			end
			s2: begin
				if(button == 0) begin
					state_next = s3;
					go = 1;
				end else
				    go = 0;
			end
			s3: begin
				if(button == 0) begin
					if(tick == 1) begin
						state_next = s0;
						go = 0;
					end else
					    go = 1;
				end
				else begin
					state_next = s2;
					go = 0;
				end
			end
			default: begin
				state_next = s0;
				go = 0;
			end
		endcase
	end

	reg output_fangdou_button = 0;
	assign fangdou_button = output_fangdou_button;
	always @ * begin
		case(state_reg) 
			s0:output_fangdou_button = 0;
			s1:output_fangdou_button = 0;
			s2:output_fangdou_button = 1;
			s3:output_fangdou_button = 1;
		endcase
	end		
endmodule

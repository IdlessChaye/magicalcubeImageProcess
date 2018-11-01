 /* this program is to generate clock signals
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
module freq_divide(
	    input clki,
	    output clko_10MHz,
	    output clko_25MHz
    );

	parameter N = 10, N1 = 4;
	parameter M = N / 2, M1 = N1 / 2;
	
	reg[2:0] count=1;
	always @ (posedge clki)
		if(count == M)
			count <= 1;
		else
			count <= count + 1;
	
	wire halfT;
	assign halfT = count == M ? 1'b1 : 1'b0;
	
	reg clko_10MHz_reg=0;
	assign clko_10MHz = clko_10MHz_reg;
	
	always @ (posedge halfT)
		clko_10MHz_reg <= ~clko_10MHz_reg;


	reg[1:0] count1=1;
	always @ (posedge clki)
		if(count1 == M1)
			count1 <= 1;
		else
			count1 <= count1 + 1;
	
	wire halfT1;
	assign halfT1 = count1 == M1 ? 1'b1 : 1'b0;
	
	reg clko_25MHz_reg=0;
	assign clko_25MHz = clko_25MHz_reg;
	
	always @ (posedge halfT1)
		clko_25MHz_reg <= ~clko_25MHz_reg;

endmodule

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

/*
* module:div_rill_tb
* file name:div_rill_tb.v
* syn:no
* author:rill
* date:2014-04-10
*/
`timescale 1ns/1ns

module div_rill_clk_tb;

reg clk;
reg rst;
reg enable;

reg [31:0] a;
reg [31:0] b;
wire [31:0] yshang;
wire [31:0] yyushu;

wire done;

initial begin
    clk = 0;
    
    #10
    rst = 1;
    #20
    rst = 0;
    
    #15
    enable =1;
    a = 2;//$random()%10000;
    b = 7;//$random()%1000;
    #10
    enable =0;
    
    #1000
    enable =1;
    a = 7;//$random()%1000;
    b = 2;//$random()%100;
    #10
    enable =0;
    
    #1000
    enable =1;
    a = 7;//$random()%100;
    b = 7;//$random()%10;   
    #10
    enable =0;
    
    #1000 $stop;
end

always # 5 clk = ~clk;

div_rill_clk DIV_RILL (
    .clk (clk),
    .rst (rst),

    .enable (enable),
    .a (a), 
    .b (b),

    .yshang (yshang),
    .yyushu (yyushu),

    .done (done)
);

endmodule
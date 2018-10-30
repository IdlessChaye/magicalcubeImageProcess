`timescale 1ns/1ns

module rgb2hsv_clk_tb;

reg pclk;
reg rst;

reg enable;
reg[23:0] RGB24;
wire[23:0] HSV24;

wire hsv_done;

initial begin
    pclk = 0;


    #10
    rst = 1;
    #20
    rst = 0; 
    #15
    enable =1;
    RGB24[23:16] = 8'd255;
    RGB24[15:8] = 8'd255;
    RGB24[7:0] = 8'd155;
    #10
    enable =0;
    #1000


    #10
    rst = 1;
    #20
    rst = 0; 
    #15
    enable =1;
    RGB24[23:16] = 8'd255;
    RGB24[15:8] = 8'd155;
    RGB24[7:0] = 8'd155;
    #10
    enable =0;
    #1000


    #10
    rst = 1;
    #20
    rst = 0; 
    #15
    enable =1;
    RGB24[23:16] = 8'd255;
    RGB24[15:8] = 8'd55;
    RGB24[7:0] = 8'd155;
    #10
    enable =0;
    #1000


    #10
    rst = 1;
    #20
    rst = 0; 
    #15
    enable =1;
    RGB24[23:16] = 8'd205;
    RGB24[15:8] = 8'd255;
    RGB24[7:0] = 8'd55;
    #10
    enable =0;
    #1000


    #10
    rst = 1;
    #20
    rst = 0; 
    #15
    enable =1;
    RGB24[23:16] = 8'd205;
    RGB24[15:8] = 8'd55;
    RGB24[7:0] = 8'd255;
    #10
    enable =0;


    #1000 $stop;
end

always # 5 pclk = ~pclk;

rgb2hsv_clk rgb2hsv_clk_0 (
    .pclk(pclk),
    .rst(rst),

    .enable(enable),
    .RGB24(RGB24),
    .HSV24(HSV24),

    .hsv_done(hsv_done)
);

endmodule
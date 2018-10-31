module hsv2color_coding (
    input clk,
    input rst,

    input enable,

    input[23:0] hsv24,
    output reg[2:0] color_coding,

    output reg done
);


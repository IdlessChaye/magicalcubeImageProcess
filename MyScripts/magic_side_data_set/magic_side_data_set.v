module magic_side_data_set (
    input clk,
    input rst,

    input enable,

    input[8:0] position_coding,
    input[2:0] color_coding,
    output reg[26:0] oneside_dout,

    output reg done
);
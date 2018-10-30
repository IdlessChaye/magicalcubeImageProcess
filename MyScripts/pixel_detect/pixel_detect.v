module pixel_detect (
    input clk,
    input rst,

    input enable,

    input[15:0] data_wr_out,
    input[18:0] addr_wr_out,
    output reg[15:0] rgb565,
    output reg[8:0] position_coding,

    output reg find,

    output reg done
);


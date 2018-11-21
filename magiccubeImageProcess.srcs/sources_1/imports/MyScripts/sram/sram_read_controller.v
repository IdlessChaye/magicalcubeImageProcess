`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/20 17:01:17
// Design Name: 
// Module Name: sram_read_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


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

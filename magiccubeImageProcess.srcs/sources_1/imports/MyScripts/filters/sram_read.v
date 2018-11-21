`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/19 09:59:41
// Design Name: 
// Module Name: sram_read
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

// continue to read data from sram through num_read T, need addr for every data
module sram_read(
    input wclk,
    input rst,

    input enable,
    input[4:0] num_read, // the num continue to read
    input[18:0] addr,

    output reg selec,
    output reg write,
    output reg read,
    output reg[18:0] addr_wr,
    
    output reg done
);

reg[4:0] count_read;

localparam s_idle     = 4'b0000;
localparam s_read     = 4'b0001;
reg[3:0] status = s_idle;

always @ (posedge wclk) begin
    if(rst) begin
        selec  <= 0;
        write  <= 0;
        read   <= 0;
        addr_wr  <= 0;
        count_read <= 0;
        done <= 0;
        status <= s_idle;
    end else begin
        case(status)
            s_idle: begin
                done <= 0;
                selec <= 1;
                write <= 0;
                read <= 1;
                addr_wr <= addr;
                count_read <= num_read;
                if(enable) begin
                    status <= s_read;
                end
            end
            s_read: begin
                count_read <= count_read - 1;
                if(count_read == 1) begin
                    done <= 1;
                    status <= s_idle;
                end else begin
                    addr_wr <= addr;
                end
            end
            default: begin
                status <= s_idle;
            end
        endcase
    end
end

endmodule
`timescale 1ns / 1ps

module sram_write(
    input wclk,
    input rst,

    input enable,
    input[4:0] num_write, // the num continue to write
    input[18:0] addr,
    input[15:0] data,

    output reg selec,
    output reg write,
    output reg read,
    output reg[18:0] addr_wr,
    output reg[15:0] data_wr_in,
    
    output reg done
);

reg[4:0] count_write;

localparam s_idle     = 4'b0000;
localparam s_write    = 4'b0001;
reg[3:0] status = s_idle;

always @ (posedge wclk) begin
    if(rst) begin
        selec  <= 0;
        write  <= 0;
        read   <= 0;
        addr_wr  <= 0;
        data_wr_in <= 0;
        count_write <= 0;
        done <= 0;
        status <= s_idle;
    end else begin
        case(status)
            s_idle: begin
                done <= 0;
                if(enable) begin
                    selec  <= 1;
                    write  <= 1;
                    read   <= 0;
                    addr_wr  <= addr;
                    data_wr_in <= data;
                    count_write <= num_write;

                    status <= s_write;
                end else begin
                    selec  <= 0;
                    write  <= 0;
                    read   <= 0;
                    addr_wr  <= 0;
                    data_wr_in <= 0;                    
                    count_write <= 0;
                end
            end
            s_write: begin
                count_write <= count_write - 1;
                if(count_write == 1) begin
                    selec  <= 0;
                    write  <= 0;
                    read   <= 0;
                    addr_wr  <= 0;
                    data_wr_in <= 0;
                    done <= 1;
                    status <= s_idle;
                end else begin
                    addr_wr  <= addr;
                    data_wr_in <= data;
                end
            end
            default: begin
                status <= s_idle;
            end
        endcase
    end
end

endmodule
module image_in_sram (
    input wclk, 
    input rst, // high_power work

    input enable_button, // posedge work

    input[16:0] cam_addr,
    input[15:0] cam_data,
    input cam_we,

    output reg selec_in_sram,
    output reg write_in_sram,
    output reg read_in_sram,
    output reg[15:0] data_wr_in_in_sram,
    output reg[18:0] addr_wr_in_sram,

    output reg done
);

reg enable = 0;
always@(posedge enable_button) begin
    enable = 1'b1;
end
    
parameter address_count_max = 240 * 320 - 1; // 76800 - 1


parameter s_idle           = 4'b0000;
parameter s_init           = 4'b0001;
parameter s_write          = 4'b0011;
parameter s_ready          = 4'b0010;
parameter s_done           = 4'b0110;
reg [3:0] status = s_idle;


always@(posedge pclk) begin
    if(rst) begin
        selec_in_sram <= 0;
        write_in_sram <= 0;
        read_in_sram <= 0;
        data_wr_in_in_sram <= 0;
        addr_wr_in_sram <= 0;
        done <= 0;

        status <= s_idle;
    end else begin
        case(status) 
            s_idle: begin
                done <= 0;            
                if(enable && cam_addr == 0) begin
                    status <= s_init;
                end else begin
                    selec_in_sram <= 0;
                    write_in_sram <= 0;
                    read_in_sram <= 0;
                    data_wr_in_in_sram <= 0;
                    addr_wr_in_sram <= 0;

                    status <= s_idle;
                end
            end
            s_init: begin
                enable <= 0;
                if(cam_we) begin
                    data_wr_in_in_sram <= cam_data;
                    addr_wr_in_sram <= cam_addr;
                end

                if(addr_wr_in_sram == address_count_max) begin
                    selec_in_sram <= 0;
                    write_in_sram <= 0;
                    read_in_sram <= 0;

                    status <= s_done;
                end else if(cam_we) begin
                    selec_in_sram <= 1;
                    write_in_sram <= 1;
                    read_in_sram  <= 0;

                    status <= s_write;    
                end else begin
                    selec_in_sram <= 0;
                    write_in_sram <= 0;
                    read_in_sram <= 0;

                    status <= s_init;
                end
            end
            s_write: begin
                status <= s_init;
            end
            s_done: begin
                done <= 1'b1;

                status <= s_ready;
            end
            s_ready: begin
                status <= s_idle;
            end
            default: begin
                status <= s_idle;
            end
        endcase
    end
end

endmodule
module image_out_sram (
    input wclk, 
    input rst, // high_power work

    input enable, // high_power work
    input continue,
    output get_data,

    output reg selec_out_sram,
    output reg write_out_sram,
    output reg read_out_sram,
    output reg[18:0] addr_wr_out_sram,
    input[15:0] data_wr_out_out_sram,

    output reg[15:0] cam_dout,
    
    output reg done
);


parameter s_idle           = 4'b0000;
parameter s_init           = 4'b0001;
parameter s_read           = 4'b0011;
parameter s_ready          = 4'b0010;
parameter s_done           = 4'b0110;
reg [3:0] status = s_idle;


always@(posedge wclk) begin
    if(rst) begin
        R_reg <= 0;
        G_reg <= 0;
        B_reg <= 0;
        Hue <= 0;
        Saturation <= 0;
        Value <= 0;
        hsv_done <= 0;

        status <= s_idle;
    end else begin
        case(status) 
            s_idle: begin
                if(enable) begin
                                

                    status <= s_init;
                end else begin
                    R_reg <= 0;
                    G_reg <= 0;
                    B_reg <= 0;
                    hsv_done <= 0;

                    status <= s_idle;                    
                end
            end
            s_init: begin
                
                status <= s_div_work;
            end
            s_div_work: begin
                enable_div <= 0;
                if(clac_done) begin
                    status <= s_done;
                end else begin
                    status <= s_div_work;
                end
            end
            s_done: begin
                if(sign_flag == 0) 
                    Hue <= (h_quotient + h_add);
                else
                    Hue <= (h_add - h_quotient);
                Saturation <= s_quotient;
                Value <= v;
                hsv_done <= 1'b1;   

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
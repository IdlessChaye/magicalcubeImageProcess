/*
                if(H_cnt==h_youxia&&V_cnt==v_youxia) begin
                    status <= s_done;

be careful of that
make sure that H_cnt==h_youxia&&V_cnt==v_youxia is the last case
*/

module image_out_sramdetect (
    input wclk, 
    input rst, // high_power work

    input enable, // high_power work, lots of rgb565, a big xunhuan start, need extra 8 continues to finish
    input continue, // high_power work, one rgb565, a little xunhuan start

    output reg selec_out_sram,
    output reg write_out_sram,
    output reg read_out_sram,
    output reg[18:0] addr_wr_out_sram,
    input[15:0] data_wr_out_out_sram,

    output reg[15:0] rgb565,
    output reg[8:0] position_coding,
    
    output reg find,
    output reg done
);


reg[15:0] data_wr_out_reg;

reg[9:0] V_cnt,H_cnt;
parameter H_cnt_max = 320;
parameter V_cnt_max = 240;



localparam[9:0] h_zuoshang=40,
                h_zhongshang=120, 
                h_youshang=200,     
                h_zuozhong=40,
                h_zhongzhong=120,
                h_youzhong=200,
                h_zuoxia=40,
                h_zhongxia=120, 
                h_youxia=200;
localparam[9:0] v_zuoshang=40,
                v_zhongshang=40,
                v_youshang=40,
                v_zuozhong=120,
                v_zhongzhong=120,
                v_youzhong=120,
                v_zuoxia=200,
                v_zhongxia=200,
                v_youxia=200;


parameter s_idle           = 4'b0000;
parameter s_init_enable    = 4'b0001;
parameter s_init_notfind   = 4'b0011;
parameter s_read           = 4'b0111;
parameter s_detect         = 4'b1111;
parameter s_find           = 4'b1110;
parameter s_done           = 4'b1100;
parameter s_ready          = 4'b1000;
reg [3:0] status = s_idle;


always@(posedge wclk) begin
    if(rst) begin
        selec_out_sram <= 0;
        write_out_sram <= 0;
        read_out_sram  <= 0;
        addr_wr_out_sram <= 0;
        V_cnt <= 0;
        H_cnt <= 0;
        rgb565 <= 0;
        position_coding <= 0;
        find <= 0;
        done <= 0;

        status <= s_idle;
    end else begin
        case(status) 
            s_idle: begin
                done <= 0;            
                find <= 0;
                selec_out_sram <= 0;
                write_out_sram <= 0;
                read_out_sram  <= 0;
                addr_wr_out_sram <= 0;
                V_cnt <= 0;
                H_cnt <= 0;

                if(enable) begin
                    status <= s_init_enable;
                end else begin
                    status <= s_idle;                    
                end
            end
            s_init_enable: begin
                find <= 0;
                selec_out_sram <= 0;
                write_out_sram <= 0;
                read_out_sram  <= 0;  

                if(enable) begin
                    addr_wr_out_sram <= 0;
                    V_cnt <= 0;
                    H_cnt <= 0;

                    status <= s_init_enable;
                end else if(addr_wr_out_sram == 0 || continue) begin
                    status <= s_init_notfind;
                end else begin
                    status <= s_init_enable;    
                end
            end
            s_init_notfind: begin
                selec_out_sram <= 1;
                write_out_sram <= 0;
                read_out_sram  <= 1;

                status <= s_read;
            end
            s_read: begin
                data_wr_out_reg <= data_wr_out_out_sram;
                selec_out_sram <= 0;
                write_out_sram <= 0;
                read_out_sram  <= 0;                  
                addr_wr_out_sram <= addr_wr_out_sram + 1; // next addr            

                if(H_cnt == H_cnt_max) begin //this H_cnt and V_cnt
                    if(V_cnt == V_cnt_max) begin
                        status <= done;
                    end else begin
                        H_cnt <= 0;
                        V_cnt <= V_cnt + 1;

                        status <= s_detect;
                    end
                end else begin
                    H_cnt <= H_cnt + 1;

                    status <= s_detect;
                end
            end
            s_detect: begin
                if(H_cnt==h_zuoshang&&V_cnt==v_zuoshang) begin
                    rgb565 <= data_wr_out_reg;
                    position_coding <= 9'd1;
                    status <= s_find;
                end else if(H_cnt==h_zhongshang&&V_cnt==v_zhongshang) begin
                    rgb565 <= data_wr_out_reg;
                    position_coding <= 9'd2;
                    status <= s_find;
                end else if(H_cnt==h_youshang&&V_cnt==v_youshang) begin
                    rgb565 <= data_wr_out_reg;
                    position_coding <= 9'd3;
                    status <= s_find;
                end else if(H_cnt==h_zuozhong&&V_cnt==v_zuozhong) begin
                    rgb565 <= data_wr_out_reg;                   
                    position_coding <= 9'd4;
                    status <= s_find;
                end else if(H_cnt==h_zhongzhong&&V_cnt==v_zhongzhong) begin
                    rgb565 <= data_wr_out_reg;                  
                    position_coding <= 9'd5;
                    status <= s_find;
                end else if(H_cnt==h_youzhong&&V_cnt==v_youzhong) begin
                    rgb565 <= data_wr_out_reg;                 
                    position_coding <= 9'd6;
                    status <= s_find;
                end else if(H_cnt==h_zuoxia&&V_cnt==v_zuoxia) begin
                    rgb565 <= data_wr_out_reg;                 
                    position_coding <= 9'd7;
                    status <= s_find;                    
                end else if(H_cnt==h_zhongxia&&V_cnt==v_zhongxia) begin
                    rgb565 <= data_wr_out_reg;            
                    position_coding <= 9'd8;
                    status <= s_find;                    
                end else if(H_cnt==h_youxia&&V_cnt==v_youxia) begin
                    rgb565 <= data_wr_out_reg;                  
                    position_coding <= 9'd9;
                    status <= s_find;
                end else begin
                    status <= s_init_notfind;
                end
            end
            s_find: begin
                find <= 1;
                if(H_cnt==h_youxia&&V_cnt==v_youxia) begin
                    done <= 1; // the last case, find and done are sync

                    status <= s_ready; // skip s_done
                else begin
                    status <= s_init_enable; // wait for continue, next little xunhuan
                end
            end
            s_done: begin
                done <= 1;

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
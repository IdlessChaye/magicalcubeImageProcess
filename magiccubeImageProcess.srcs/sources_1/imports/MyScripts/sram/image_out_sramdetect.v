 /* this program is to get a picture from sram and then detect specific pixels
    Copyright (C) 2018 IdlessChaye

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/

/*
                if(H_cnt==h_youxia&&V_cnt==v_youxia) begin
                    status <= s_done;

be careful of that
make sure that H_cnt==h_youxia&&V_cnt==v_youxia is the last case
*/


`timescale 1ns / 1ns
module image_out_sramdetect #(parameter H_cnt_max = 320,
                              parameter V_cnt_max = 240) (
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

reg[6:0] r_7;
reg[7:0] g_8;
reg[6:0] b_7;
reg search_finish;
reg[2:0] count_sum_residue;
reg[15:0] data_wr_out_reg;

reg[9:0] V_cnt,H_cnt;


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


localparam s_idle           = 4'b0000;
localparam s_init_enable    = 4'b0001;
localparam s_init_notfind   = 4'b0011;
localparam s_read           = 4'b0111;
localparam s_detect         = 4'b1111;
localparam s_find           = 4'b1110;
localparam s_done           = 4'b1100;
localparam s_ready          = 4'b1000;
localparam s_residue        = 4'b1001;
localparam s_dataready      = 4'b1011;
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
        count_sum_residue <= 0;
        r_7 <= 0;
        g_8 <= 0;
        b_7 <= 0;
        search_finish <= 0;
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
                count_sum_residue <= 0;
                search_finish <= 0;

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
                        H_cnt <= 0;
                        V_cnt <= 0;
                        status <= done;
                    end else begin
                        H_cnt <= 0;
                        V_cnt <= V_cnt + 1;

                        if(count_sum_residue == 0) begin
                            status <= s_detect;    
                        end else begin
                            status <= s_residue; 
                        end
                    end
                end else begin
                    H_cnt <= H_cnt + 1;

                    if(count_sum_residue == 0) begin
                        status <= s_detect;    
                    end else begin
                        status <= s_residue;
                    end
                end
            end
            s_detect: begin
                if(H_cnt==h_zuoshang&&V_cnt==v_zuoshang) begin
                    count_sum_residue <= 4;
                    position_coding <= 9'd1;
                    status <= s_residue;
                end else if(H_cnt==h_zhongshang&&V_cnt==v_zhongshang) begin
                    count_sum_residue <= 4;
                    position_coding <= 9'd2;
                    status <= s_residue;
                end else if(H_cnt==h_youshang&&V_cnt==v_youshang) begin
                    count_sum_residue <= 4;
                    position_coding <= 9'd3;
                    status <= s_residue;
                end else if(H_cnt==h_zuozhong&&V_cnt==v_zuozhong) begin
                    count_sum_residue <= 4;              
                    position_coding <= 9'd4;
                    status <= s_residue;
                end else if(H_cnt==h_zhongzhong&&V_cnt==v_zhongzhong) begin
                    count_sum_residue <= 4;              
                    position_coding <= 9'd5;
                    status <= s_residue;
                end else if(H_cnt==h_youzhong&&V_cnt==v_youzhong) begin
                    count_sum_residue <= 4;          
                    position_coding <= 9'd6;
                    status <= s_residue;
                end else if(H_cnt==h_zuoxia&&V_cnt==v_zuoxia) begin
                    count_sum_residue <= 4;        
                    position_coding <= 9'd7;
                    status <= s_residue;                  
                end else if(H_cnt==h_zhongxia&&V_cnt==v_zhongxia) begin
                    count_sum_residue <= 4;        
                    position_coding <= 9'd8;
                    status <= s_residue;            
                end else if(H_cnt==h_youxia&&V_cnt==v_youxia) begin
                    search_finish <= 1;
                    count_sum_residue <= 4;            
                    position_coding <= 9'd9;
                    status <= s_residue;
                end else begin
                    status <= s_init_notfind;
                end
            end
            s_residue: begin
                if(count_sum_residue == 4) begin
                    r_7 <= {2'b0,data_wr_out_reg[15:11]};
                    g_8 <= {2'b0,data_wr_out_reg[10:5]};
                    b_7 <= {2'b0,data_wr_out_reg[4:0]};
                    status <= s_init_notfind;
                end else if(count_sum_residue == 1) begin
                    r_7 <= r_7 + {2'b0,data_wr_out_reg[15:11]};
                    g_8 <= g_8 + {2'b0,data_wr_out_reg[10:5]};
                    b_7 <= b_7 + {2'b0,data_wr_out_reg[4:0]};
                    status <= s_dataready;
                end else begin
                    r_7 <= r_7 + {2'b0,data_wr_out_reg[15:11]};
                    g_8 <= g_8 + {2'b0,data_wr_out_reg[10:5]};
                    b_7 <= b_7 + {2'b0,data_wr_out_reg[4:0]};
                    status <= s_init_notfind;
                end
                count_sum_residue <= count_sum_residue - 1;
            end
            s_dataready: begin
                rgb565 <= {r_7[6:2],g_8[7:2],b_7[6:2]};
                status <= s_find;
            end
            s_find: begin
                find <= 1;
                if(search_finish) begin
                    done <= 1; // the last case, find and done are sync
                    search_finish <= 0;

                    status <= s_ready; // skip s_done
                end else begin
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
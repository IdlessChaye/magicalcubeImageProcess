 /* this program is to load a picture from ov7076 into sram
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


`timescale 1ns / 1ns
module image_in_sram #(parameter H_cnt_max=320,
                       parameter V_cnt_max=240) (
    input wclk, 
    input rst, // high_power work

    input enable,

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

    reg[9:0] H_cnt;
    reg[9:0] V_cnt;
    
localparam address_count_max = H_cnt_max * V_cnt_max - 1; // 76800 - 1


localparam s_idle           = 4'b0000;
localparam s_init           = 4'b0001;
localparam s_write1         = 4'b0011;
localparam s_write2         = 4'b0010;
localparam s_done           = 4'b0110;
localparam s_ready          = 4'b0111;
reg [3:0] status = s_idle;

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
localparam[15:0] red = 16'b1111100000000000;
localparam[15:0] green = 16'b0000011111100000;
localparam[15:0] blue = 16'b0000000000011111;
localparam[15:0] AAA = 16'b1111100000011111;
localparam[15:0] BBB = 16'b0000011111111111;
localparam[15:0] CCC = 16'b1111111111100000;
localparam[15:0] white = 16'b1111111111111111;
localparam[15:0] black = 16'b0000000000000000;

always@(posedge wclk) begin
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
                selec_in_sram <= 0;
                write_in_sram <= 0;
                read_in_sram <= 0;
                data_wr_in_in_sram <= 0;
                addr_wr_in_sram <= 0;

                if(enable) begin
                    status <= s_init;
                end else begin
                    status <= s_idle;
                end
            end
            s_init: begin
                if(enable) begin
                    status <= s_init;
                end else if(cam_addr == 0) begin
                    status <= s_write1;
                end else begin
                    status <= s_init;
                end
            end
            s_write1: begin
                if(cam_we) begin
                    addr_wr_in_sram <= cam_addr;
                    data_wr_in_in_sram <= cam_data;

                    /*if(H_cnt == 320) begin
                        H_cnt <= 0;
                        if(V_cnt == 240) begin
                            V_cnt <= 0;
                        end else begin
                            V_cnt <= V_cnt + 1;
                        end
                    end else
                        H_cnt <= H_cnt + 1;
                        
                    if(H_cnt==h_zuoshang&&V_cnt==v_zuoshang) begin
                        data_wr_in_in_sram <= 0;
                    end else if(H_cnt==h_zhongshang&&V_cnt==v_zhongshang) begin
                        data_wr_in_in_sram <= 0;
                    end else if(H_cnt==h_youshang&&V_cnt==v_youshang) begin
                        data_wr_in_in_sram <= 0;
                    end else if(H_cnt==h_zuozhong&&V_cnt==v_zuozhong) begin
                        data_wr_in_in_sram <= 0;
                    end else if(H_cnt==h_zhongzhong&&V_cnt==v_zhongzhong) begin
                        data_wr_in_in_sram <= 0;
                    end else if(H_cnt==h_youzhong&&V_cnt==v_youzhong) begin
                        data_wr_in_in_sram <= 0;
                    end else if(H_cnt==h_zuoxia&&V_cnt==v_zuoxia) begin
                        data_wr_in_in_sram <= 0;                
                    end else if(H_cnt==h_zhongxia&&V_cnt==v_zhongxia) begin
                        data_wr_in_in_sram <= 0;       
                    end else if(H_cnt==h_youxia&&V_cnt==v_youxia) begin
                        data_wr_in_in_sram <= 0;
                    end else if(V_cnt >= 0 && V_cnt <= 40) begin
                        if(H_cnt>=0 && H_cnt<=40) begin
                            data_wr_in_in_sram <= red;
                        end else if(H_cnt>=40 && H_cnt<=80) begin
                            data_wr_in_in_sram <= green;
                        end else if(H_cnt>=80 && H_cnt<=120) begin
                            data_wr_in_in_sram <= blue;
                        end else if(H_cnt>=120 && H_cnt<=160) begin
                            data_wr_in_in_sram <= white;
                        end else if(H_cnt>=160 && H_cnt<=200) begin
                            data_wr_in_in_sram <= black;
                        end else if(H_cnt>=120 && H_cnt<=240) begin
                            data_wr_in_in_sram <= AAA;
                        end else if(H_cnt>=120 && H_cnt<=280) begin
                            data_wr_in_in_sram <= BBB;
                        end else if(H_cnt>=120 && H_cnt<=320) begin
                            data_wr_in_in_sram <= CCC;
                        end
                    end else if(V_cnt >= 40 && V_cnt <= 80) begin
                        if(H_cnt>=0 && H_cnt<=40) begin
                            data_wr_in_in_sram <= green;
                        end else if(H_cnt>=40 && H_cnt<=80) begin
                            data_wr_in_in_sram <= blue;
                        end else if(H_cnt>=80 && H_cnt<=120) begin
                            data_wr_in_in_sram <= white;
                        end else if(H_cnt>=120 && H_cnt<=160) begin
                            data_wr_in_in_sram <= black;
                        end else if(H_cnt>=160 && H_cnt<=200) begin
                            data_wr_in_in_sram <= CCC;
                        end else if(H_cnt>=120 && H_cnt<=240) begin
                            data_wr_in_in_sram <= BBB;
                        end else if(H_cnt>=120 && H_cnt<=280) begin
                            data_wr_in_in_sram <= AAA;
                        end else if(H_cnt>=120 && H_cnt<=320) begin
                            data_wr_in_in_sram <= red;
                        end 
                    end else if(V_cnt >= 80 && V_cnt <= 120) begin
                        if(H_cnt>=0 && H_cnt<=40) begin
                            data_wr_in_in_sram <= blue;
                        end else if(H_cnt>=40 && H_cnt<=80) begin
                            data_wr_in_in_sram <= white;
                        end else if(H_cnt>=80 && H_cnt<=120) begin
                            data_wr_in_in_sram <= black;
                        end else if(H_cnt>=120 && H_cnt<=160) begin
                            data_wr_in_in_sram <= CCC;
                        end else if(H_cnt>=160 && H_cnt<=200) begin
                            data_wr_in_in_sram <= BBB;
                        end else if(H_cnt>=120 && H_cnt<=240) begin
                            data_wr_in_in_sram <= AAA;
                        end else if(H_cnt>=120 && H_cnt<=280) begin
                            data_wr_in_in_sram <= red;
                        end else if(H_cnt>=120 && H_cnt<=320) begin
                            data_wr_in_in_sram <= green;
                        end 
                    end else if(V_cnt >= 120 && V_cnt <= 160) begin
                        if(H_cnt>=0 && H_cnt<=40) begin
                            data_wr_in_in_sram <= black;
                        end else if(H_cnt>=40 && H_cnt<=80) begin
                            data_wr_in_in_sram <= white;
                        end else if(H_cnt>=80 && H_cnt<=120) begin
                            data_wr_in_in_sram <= red;
                        end else if(H_cnt>=120 && H_cnt<=160) begin
                            data_wr_in_in_sram <= green;
                        end else if(H_cnt>=160 && H_cnt<=200) begin
                            data_wr_in_in_sram <= blue;
                        end else if(H_cnt>=120 && H_cnt<=240) begin
                            data_wr_in_in_sram <= CCC;
                        end else if(H_cnt>=120 && H_cnt<=280) begin
                            data_wr_in_in_sram <= BBB;
                        end else if(H_cnt>=120 && H_cnt<=320) begin
                            data_wr_in_in_sram <= AAA;
                        end 
                    end else if(V_cnt >= 160 && V_cnt <= 200) begin
                        if(H_cnt>=0 && H_cnt<=40) begin
                            data_wr_in_in_sram <= AAA;
                        end else if(H_cnt>=40 && H_cnt<=80) begin
                            data_wr_in_in_sram <= CCC;
                        end else if(H_cnt>=80 && H_cnt<=120) begin
                            data_wr_in_in_sram <= BBB;
                        end else if(H_cnt>=120 && H_cnt<=160) begin
                            data_wr_in_in_sram <= red;
                        end else if(H_cnt>=160 && H_cnt<=200) begin
                            data_wr_in_in_sram <= green;
                        end else if(H_cnt>=120 && H_cnt<=240) begin
                            data_wr_in_in_sram <= white;
                        end else if(H_cnt>=120 && H_cnt<=280) begin
                            data_wr_in_in_sram <= black;
                        end else if(H_cnt>=120 && H_cnt<=320) begin
                            data_wr_in_in_sram <= blue;
                        end 
                    end else if(V_cnt >= 200 && V_cnt <= 240) begin
                        if(H_cnt>=0 && H_cnt<=40) begin
                            data_wr_in_in_sram <= blue;
                        end else if(H_cnt>=40 && H_cnt<=80) begin
                            data_wr_in_in_sram <= red;
                        end else if(H_cnt>=80 && H_cnt<=120) begin
                            data_wr_in_in_sram <= green;
                        end else if(H_cnt>=120 && H_cnt<=160) begin
                            data_wr_in_in_sram <= BBB;
                        end else if(H_cnt>=160 && H_cnt<=200) begin
                            data_wr_in_in_sram <= AAA;
                        end else if(H_cnt>=120 && H_cnt<=240) begin
                            data_wr_in_in_sram <= white;
                        end else if(H_cnt>=120 && H_cnt<=280) begin
                            data_wr_in_in_sram <= CCC;
                        end else if(H_cnt>=120 && H_cnt<=320) begin
                            data_wr_in_in_sram <= black;
                        end 
                    end
                    else begin
                        data_wr_in_in_sram <= cam_data;
                    end*/
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

                    status <= s_write2;    
                end else begin
                    selec_in_sram <= 0;
                    write_in_sram <= 0;
                    read_in_sram <= 0;

                    status <= s_write1;
                end                
            end
            s_write2: begin
                status <= s_write1;
            end
            s_done: begin
                done <= 1'b1;

                status <= s_ready;
            end
            s_ready: begin
                done <= 0;
                status <= s_idle;
            end
            default: begin
                status <= s_idle;
            end
        endcase
    end
end

endmodule
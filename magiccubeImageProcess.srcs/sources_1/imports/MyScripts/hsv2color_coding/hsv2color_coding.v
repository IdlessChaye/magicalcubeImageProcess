 /* this program is to generate color_coding
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
module hsv2color_coding (
    input clk,
    input rst,

    input enable,

    input[24:0] hsv25,
    output reg[2:0] color_coding,
    
    input[8:0] color1_Hue_input,
    input[8:0] color2_Hue_input,
    input[8:0] color3_Hue_input,
    input[8:0] color4_Hue_input,
    input[8:0] color5_Hue_input,
    input[8:0] color6_Hue_input,
    input[7:0] color1_S_input,
    input[7:0] color2_S_input,
    input[7:0] color3_S_input,
    input[7:0] color4_S_input,
    input[7:0] color5_S_input,
    input[7:0] color6_S_input,
    input[7:0] color1_V_input,
    input[7:0] color2_V_input,
    input[7:0] color3_V_input,
    input[7:0] color4_V_input,
    input[7:0] color5_V_input,
    input[7:0] color6_V_input,
    input[7:0] color_S_margin_default,

    output reg done
);

reg[8:0] Hue;
reg[7:0] Saturation;
reg[7:0] Value;

// white 3'b110 black 3'b010
localparam  color1_coding = 3'b001,
            color2_coding = 3'b001,
            color3_coding = 3'b011,
            color4_coding = 3'b100,
            color5_coding = 3'b101,
            color6_coding = 3'b001;  // also red
//reg[7:0]    color_S_margin_default = 45;
localparam  color_V_margin_default = 96;


reg[7:0] dis_S_1,
         dis_S_2,
         dis_S_3,
         dis_S_4,
         dis_S_5,
         dis_S_6;
reg[7:0] dis_V_1,
         dis_V_2,
         dis_V_3,
         dis_V_4,
         dis_V_5,
         dis_V_6;
reg[9:0] dis_color1,
         dis_color2,
         dis_color3,
         dis_color4,
         dis_color5,
         dis_color6;
reg[9:0] min1_1,
         min1_2,
         min1_3,
         min2,
         min3;


localparam s_idle    = 4'b0000;
localparam s_init    = 4'b0001;
localparam s_dis1    = 4'b1001;
localparam s_dis2    = 4'b1101;
localparam s_sum1    = 4'b1111;
localparam s_sum2    = 4'b1011;
localparam s_min1    = 4'b0101;
localparam s_min2    = 4'b0111;
localparam s_min3    = 4'b0011;
localparam s_trans   = 4'b0010;
localparam s_done    = 4'b0110;
localparam s_ready   = 4'b0100;
reg[3:0] status = s_idle;

always@(posedge clk) begin
    if(rst) begin
        done <= 0;
        color_coding <= color1_coding;
        Hue <= 0;
        Saturation <= 0;
        Value <= 0;

        status <= s_idle;
    end else begin
        case(status) 
            s_idle: begin
                done <= 0;
                Hue <= 0;
                Saturation <= 0;
                Value <= 0;

                if(enable) begin
                    status <= s_init;
                end else begin
                    status <= s_idle;
                end
            end
            s_init: begin
                Hue <= hsv25[24:16];
                Saturation <= hsv25[15:8];
                Value <= hsv25[7:0];

                status <= s_dis1;
            end
            s_dis1: begin
                if(Saturation <= color_S_margin_default) begin
                    if(Value <= color_V_margin_default)
                        color_coding <= 3'b010; // black
                    else
                        color_coding <= 3'b110; // white
                    status <= s_done;
                end else begin
                    status <= s_dis2;

                    if(color1_Hue_input < Hue) begin
                        dis_color1 <= Hue - color1_Hue_input;
                    end else begin
                        dis_color1 <= color1_Hue_input - Hue;
                    end
                    if(color2_Hue_input < Hue) begin
                        dis_color2 <= Hue - color2_Hue_input;
                    end else begin
                        dis_color2 <= color2_Hue_input - Hue;
                    end                   
                    if(color3_Hue_input < Hue) begin
                        dis_color3 <= Hue - color3_Hue_input;
                    end else begin
                        dis_color3 <= color3_Hue_input - Hue;
                    end                    
                    if(color4_Hue_input < Hue) begin
                        dis_color4 <= Hue - color4_Hue_input;
                    end else begin
                        dis_color4 <= color4_Hue_input - Hue;
                    end                    
                    if(color5_Hue_input < Hue) begin
                        dis_color5 <= Hue - color5_Hue_input;
                    end else begin
                        dis_color5 <= color5_Hue_input - Hue;
                    end                    
                    if(color6_Hue_input < Hue) begin
                        dis_color6 <= Hue - color6_Hue_input;
                    end else begin
                        dis_color6 <= color6_Hue_input - Hue;
                    end                    
                end

                dis_S_1 <= 255 - color1_S_input;
                dis_S_2 <= 255 - color2_S_input;
                dis_S_3 <= 255 - color3_S_input;
                dis_S_4 <= 255 - color4_S_input;
                dis_S_5 <= 255 - color5_S_input;
                dis_S_6 <= 255 - color6_S_input;

                dis_V_1 <= 255 - color1_V_input;
                dis_V_2 <= 255 - color2_V_input;
                dis_V_3 <= 255 - color3_V_input;
                dis_V_4 <= 255 - color4_V_input;
                dis_V_5 <= 255 - color5_V_input;
                dis_V_6 <= 255 - color6_V_input;

            end
            s_dis2: begin
                if(dis_color1 > 180) begin
                    dis_color1 <= 360 - dis_color1;
                end
                if(dis_color2 > 180) begin
                    dis_color2 <= 360 - dis_color2;
                end
                if(dis_color3 > 180) begin
                    dis_color3 <= 360 - dis_color3;
                end
                if(dis_color4 > 180) begin
                    dis_color4 <= 360 - dis_color4;
                end
                if(dis_color5 > 180) begin
                    dis_color5 <= 360 - dis_color5;
                end
                if(dis_color6 > 180) begin
                    dis_color6 <= 360 - dis_color6;
                end

                status <= s_min1;
            end   
            s_sum1: begin
                dis_color1 <= dis_color1 + {2'b0,dis_S_1};
                dis_color2 <= dis_color2 + {2'b0,dis_S_2};
                dis_color3 <= dis_color3 + {2'b0,dis_S_3};
                dis_color4 <= dis_color4 + {2'b0,dis_S_4};
                dis_color5 <= dis_color5 + {2'b0,dis_S_5};
                dis_color6 <= dis_color6 + {2'b0,dis_S_6};

                status <= s_sum2;
            end
            s_sum2: begin
                dis_color1 <= dis_color1 + {2'b0,dis_V_1};
                dis_color2 <= dis_color2 + {2'b0,dis_V_2};
                dis_color3 <= dis_color3 + {2'b0,dis_V_3};
                dis_color4 <= dis_color4 + {2'b0,dis_V_4};
                dis_color5 <= dis_color5 + {2'b0,dis_V_5};
                dis_color6 <= dis_color6 + {2'b0,dis_V_6};

                status <= s_min1;
            end
            s_min1: begin
                if(dis_color1 < dis_color2) begin
                    min1_1 <= dis_color1;
                end else begin
                    min1_1 <= dis_color2;
                end
                if(dis_color3 < dis_color4) begin
                    min1_2 <= dis_color3;
                end else begin
                    min1_2 <= dis_color4;
                end
                if(dis_color5 < dis_color6) begin
                    min1_3 <= dis_color5;
                end else begin
                    min1_3 <= dis_color6;
                end

                status <= s_min2;
            end 
            s_min2: begin
                if(min1_1 < min1_2) begin
                    min2 <= min1_1;
                end else begin
                    min2 <= min1_2;
                end

                status <= s_min3;
            end 
            s_min3: begin
                if(min2 < min1_3) begin
                    min3 <= min2;
                end else begin
                    min3 <= min1_3;
                end

                status <= s_trans;
            end       
            s_trans: begin
                case(min3)
                    dis_color1: begin
                        color_coding <= color1_coding;
                    end
                    dis_color2: begin
                        color_coding <= color2_coding;
                    end
                    dis_color3: begin
                        color_coding <= color3_coding;
                    end
                    dis_color4: begin
                        color_coding <= color4_coding;
                    end
                    dis_color5: begin
                        color_coding <= color5_coding;
                    end
                    dis_color6: begin
                        color_coding <= color6_coding;
                    end
                    default: begin
                        color_coding <= color1_coding;
                    end
                endcase

                status <= s_done;
            end
            s_done: begin
                done <= 1;

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
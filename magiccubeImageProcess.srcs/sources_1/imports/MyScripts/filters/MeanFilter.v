`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/19 10:01:09
// Design Name: 
// Module Name: MeanFilter
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


module MeanFilter #(parameter N=5,
                    parameter H_cnt_max = 320,
                    parameter V_cnt_max = 240) (
    input wclk,
    input rst,

    input enable,

    output reg[16:0] frame_addr_1_r,
    input[15:0] frame_pixel_1_r,

    output selec_mean,
    output write_mean,
    output read_mean,
    output[15:0] data_wr_in_mean,
    output[18:0] addr_wr_mean,
    
    output reg done
);

reg enable_write;
reg[4:0] num_write;
reg[18:0] addr_write;
reg[15:0] data_write;
wire done_write;
sram_write sram_write_0 (
    .wclk(wclk),
    .rst(rst),

    .enable(enable_write),

    .num_write(num_write), 
    .addr(addr_write),
    .data(data_write),

    .selec(selec_mean),
    .write(write_mean),
    .read(read_mean),
    .addr_wr(addr_wr_mean),
    .data_wr_in(data_wr_in_mean),

    .done(done_write)
);



reg out_of_range;
reg[N:0] cnt_read_square;
reg[1:0] cnt_calc_mean;
reg[9:0] H_cnt,V_cnt;
reg[16:0] address;

reg[4:0] mean_R;
reg[5:0] mean_G;
reg[4:0] mean_B;
reg[9:0] sum_R;
reg[10:0] sum_G;
reg[9:0] sum_B;
reg[14:0] sum_for_div_R; // 32 + 8 + 1 / 1024
reg[15:0] sum_for_div_G;
reg[14:0] sum_for_div_B;


localparam s_idle         = 4'b0000;
localparam s_judge        = 4'b0001;
localparam s_read_square  = 4'b0011;
localparam s_calc_mean    = 4'b0010;
localparam s_set_data     = 4'b1110;
localparam s_done         = 4'b1111;
reg[3:0] status = s_idle;

always @ (posedge wclk) begin
    if(rst) begin
        H_cnt <= 0;
        V_cnt <= 0;
        frame_addr_1_r <= 0;
        enable_write <= 0;
        addr_write <= 0;
        data_write <= 0;
        done <= 0;

        status <= s_idle;
    end else begin
        case(status)
            s_idle: begin
                H_cnt <= 0;
                V_cnt <= 0;
                frame_addr_1_r <= 0;
                enable_write <= 0;
                addr_write <= 0;
                data_write <= 0;
                done <= 0;

                if(enable) begin
                    status <= s_judge;
                end
            end
            s_judge: begin
                address <= V_cnt * H_cnt_max + H_cnt;
                if(H_cnt < N - 1 || H_cnt > H_cnt_max - N || V_cnt < N - 1 || V_cnt > V_cnt_max - N) begin
                    frame_addr_1_r <= V_cnt * H_cnt_max + H_cnt;
                    out_of_range <= 1;
                    status <= s_set_data;
                end else begin
                    frame_addr_1_r <= (V_cnt + 2) * H_cnt_max + H_cnt + 2; // zuoshangjiao de nengsuanwanma?
                    cnt_read_square <= N*N - 1;
                    sum_R <= 0;
                    sum_G <= 0;
                    sum_B <= 0;
                    out_of_range <= 0;
                    status <= s_read_square;
                end
            end
            s_read_square: begin // default N = 3
                cnt_read_square <= cnt_read_square - 1;
                case(cnt_read_square)
                    24: begin
                        frame_addr_1_r <= (V_cnt - 2) * H_cnt_max + H_cnt - 2;
                    end
                    23: begin
                        frame_addr_1_r <= (V_cnt - 2) * H_cnt_max + H_cnt - 1;
                    end
                    22: begin
                        frame_addr_1_r <= (V_cnt - 2) * H_cnt_max + H_cnt;
                    end
                    21: begin
                        frame_addr_1_r <= (V_cnt - 2) * H_cnt_max + H_cnt + 1;
                    end
                    20: begin
                        frame_addr_1_r <= (V_cnt - 2) * H_cnt_max + H_cnt + 2;
                    end
                    19: begin
                        frame_addr_1_r <= (V_cnt - 1) * H_cnt_max + H_cnt - 2;
                    end
                    18: begin
                        frame_addr_1_r <= (V_cnt - 1) * H_cnt_max + H_cnt - 1;
                    end
                    17: begin
                        frame_addr_1_r <= (V_cnt - 1) * H_cnt_max + H_cnt;
                    end
                    16: begin
                        frame_addr_1_r <= (V_cnt - 1) * H_cnt_max + H_cnt + 1;
                    end
                    15: begin
                        frame_addr_1_r <= (V_cnt - 1) * H_cnt_max + H_cnt + 2;
                    end
                    14: begin
                        frame_addr_1_r <= (V_cnt) * H_cnt_max + H_cnt - 2;
                    end
                    13: begin
                        frame_addr_1_r <= (V_cnt) * H_cnt_max + H_cnt - 1;
                    end
                    12: begin
                        frame_addr_1_r <= (V_cnt) * H_cnt_max + H_cnt;
                    end
                    11: begin
                        frame_addr_1_r <= (V_cnt) * H_cnt_max + H_cnt + 1;
                    end
                    10: begin
                        frame_addr_1_r <= (V_cnt) * H_cnt_max + H_cnt + 2;
                    end
                    9: begin
                        frame_addr_1_r <= (V_cnt + 1) * H_cnt_max + H_cnt - 2;
                    end
                    8: begin
                        frame_addr_1_r <= (V_cnt + 1) * H_cnt_max + H_cnt - 1;
                    end
                    7: begin
                        frame_addr_1_r <= (V_cnt + 1) * H_cnt_max + H_cnt;
                    end
                    6: begin
                        frame_addr_1_r <= (V_cnt + 1) * H_cnt_max + H_cnt + 1;                    
                    end
                    5: begin
                        frame_addr_1_r <= (V_cnt + 1) * H_cnt_max + H_cnt + 2;
                    end
                    4: begin
                        frame_addr_1_r <= (V_cnt + 2) * H_cnt_max + H_cnt - 2;
                    end
                    3: begin
                        frame_addr_1_r <= (V_cnt + 2) * H_cnt_max + H_cnt - 1;                     
                    end
                    2: begin
                        frame_addr_1_r <= (V_cnt + 2) * H_cnt_max + H_cnt;
                    end
                    1: begin
                        frame_addr_1_r <= (V_cnt + 2) * H_cnt_max + H_cnt + 1;
                    end
                    default: begin
                        frame_addr_1_r <= 0;
                    end
                endcase

                sum_R <= sum_R + frame_pixel_1_r[15:11];
                sum_G <= sum_G + frame_pixel_1_r[10:5];
                sum_B <= sum_B + frame_pixel_1_r[4:0];   
                if(cnt_read_square == 0) begin
                    cnt_calc_mean <= 3;       
                    sum_for_div_R <= 0;
                    sum_for_div_G <= 0;
                    sum_for_div_B <= 0;
                    status <= s_calc_mean;
                end else begin             
                    status <= s_read_square;
                end
            end
            s_calc_mean: begin
                cnt_calc_mean <= cnt_calc_mean - 1;
                case(cnt_calc_mean) 
                    3: begin
                        sum_for_div_R <= {5'b0,sum_R};
                        sum_for_div_G <= {5'b0,sum_G};
                        sum_for_div_B <= {5'b0,sum_B};                      
                    end
                    2: begin
                        sum_for_div_R <= sum_for_div_R + {sum_R,5'b0};
                        sum_for_div_G <= sum_for_div_G + {sum_G,5'b0};
                        sum_for_div_B <= sum_for_div_B + {sum_B,5'b0};   
                    end
                    1: begin
                        sum_for_div_R <= sum_for_div_R + {2'b0,sum_R,3'b0};
                        sum_for_div_G <= sum_for_div_G + {2'b0,sum_G,3'b0};
                        sum_for_div_B <= sum_for_div_B + {2'b0,sum_B,3'b0}; 
                    end
                    0: begin
                        mean_R <= sum_for_div_R[14:10];
                        mean_G <= sum_for_div_G[15:10];
                        mean_B <= sum_for_div_B[14:10];
                    end
                    default: begin
                        // nop
                    end
                endcase
                if(cnt_calc_mean == 0) begin
                    status <= s_set_data;
                end
            end
            s_set_data: begin
                if(H_cnt == H_cnt_max - 1) begin
                    H_cnt <= 0;
                    if(V_cnt == V_cnt_max - 1) begin
                        V_cnt <= 0;
                        done <= 1;
                        status <= s_done;
                    end else begin
                        V_cnt <= V_cnt + 1;
                        status <= s_judge;
                    end
                end else begin
                    H_cnt <= H_cnt + 1;
                    status <= s_judge;
                end

                enable_write <= 1;
                num_write <= 1;
                addr_write <= {2'b0,address};
                if(out_of_range) begin
                    data_write <= frame_pixel_1_r;    
                end else begin
                    data_write <= {mean_R,mean_G,mean_B}; 
                end
            end
            s_done: begin
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
 /* this program is the main part of median filter module on github
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

module MedianFilter #(parameter N=3,
                      parameter H_cnt_max = 320,
                      parameter V_cnt_max = 240) (
    input wclk,
    input rst,

    input enable,

    output selec_median,
    output write_median,
    output read_median,
    output[18:0] addr_wr_median,
    input[15:0] data_wr_out_median,

    output reg frame_1_we,
    output reg[16:0] frame_addr_1_w,
    output reg[15:0] frame_pixel_1_w,
    
    output reg done
);


reg enable_read;
reg[4:0] num_read;
reg[18:0] addr_read;
wire done_read;
sram_read sram_read_0 (
    .wclk(wclk),
    .rst(rst),

    .enable(enable_read),

    .num_read(num_read),
    .addr(addr_read),

    .selec(selec_median),
    .write(write_median),
    .read(read_median),
    .addr_wr(addr_wr_median),

    .done(done_read)
);

reg out_of_range;
reg[N:0] cnt_read_square;
reg[1:0] cnt_calc_median;
reg[9:0] H_cnt,V_cnt,H_cntP1,H_cntP2,H_cntM1,V_cntM1;
reg[16:0] address;


reg[4:0] buffer_R[1:0][319:0];
reg[5:0] buffer_G[1:0][319:0];
reg[4:0] buffer_B[1:0][319:0];


reg[4:0] data1_R;
reg[4:0] data2_R;
reg[4:0] data3_R;
reg[4:0] data4_R;
reg[4:0] data5_R;
reg[4:0] data6_R;
reg[4:0] data7_R;
reg[4:0] data8_R;
reg[4:0] data9_R;
wire[4:0] median_R;
MedianSeletor #(.N(5)) MedianSeletor_R (
    .clk(wclk),
    .rst(rst),
    .Data1(data1_R),
    .Data2(data2_R),
    .Data3(data3_R),
    .Data4(data4_R),
    .Data5(data5_R),
    .Data6(data6_R),
    .Data7(data7_R),
    .Data8(data8_R),
    .Data9(data9_R),
    .Median(median_R)
);
reg[5:0] data1_G;
reg[5:0] data2_G;
reg[5:0] data3_G;
reg[5:0] data4_G;
reg[5:0] data5_G;
reg[5:0] data6_G;
reg[5:0] data7_G;
reg[5:0] data8_G;
reg[5:0] data9_G;
wire[5:0] median_G;
MedianSeletor #(.N(6)) MedianSeletor_G (
    .clk(wclk),
    .rst(rst),
    .Data1(data1_G),
    .Data2(data2_G),
    .Data3(data3_G),
    .Data4(data4_G),
    .Data5(data5_G),
    .Data6(data6_G),
    .Data7(data7_G),
    .Data8(data8_G),
    .Data9(data9_G),
    .Median(median_G)
);
reg[4:0] data1_B;
reg[4:0] data2_B;
reg[4:0] data3_B;
reg[4:0] data4_B;
reg[4:0] data5_B;
reg[4:0] data6_B;
reg[4:0] data7_B;
reg[4:0] data8_B;
reg[4:0] data9_B;
wire[4:0] median_B;
MedianSeletor #(.N(5)) MedianSeletor_B (
    .clk(wclk),
    .rst(rst),
    .Data1(data1_B),
    .Data2(data2_B),
    .Data3(data3_B),
    .Data4(data4_B),
    .Data5(data5_B),
    .Data6(data6_B),
    .Data7(data7_B),
    .Data8(data8_B),
    .Data9(data9_B),
    .Median(median_B)
);

localparam s_idle         = 4'b0000;
localparam s_judge        = 4'b0001;
localparam s_calc_median  = 4'b0010;
localparam s_set_data     = 4'b1110;
localparam s_youhua_1     = 4'b1100;
localparam s_youhua_2     = 4'b1101;
localparam s_done         = 4'b1111;
reg[3:0] status = s_idle;

always @ (posedge wclk) begin
    if(rst) begin
        H_cnt <= 0;
        V_cnt <= 0;
        enable_read <= 0;
        num_read <= 0;
        frame_1_we <= 0;
        frame_addr_1_w <= 0;
        frame_pixel_1_w <= 0;
        done <= 0;

        status <= s_idle;
    end else begin
        case(status)
            s_idle: begin
                H_cnt <= 0;
                V_cnt <= 0;
                enable_read <= 0;
                num_read <= 0;
                frame_1_we <= 0;
                frame_addr_1_w <= 0;
                frame_pixel_1_w <= 0;
                done <= 0;


                if(enable) begin
                    status <= s_judge;
                end
            end
            s_judge: begin
                frame_1_we <= 0;
                address <= V_cnt * H_cnt_max + H_cnt;
                if(V_cnt <= 1) begin
                    enable_read <= 1;
                    num_read <= 1;
                    addr_read <= V_cnt * H_cnt_max + H_cnt;
                    out_of_range <= 1;
                    status <= s_set_data;
                end else begin
                    enable_read <= 1;
                    num_read <= 1;
                    addr_read <= V_cnt * H_cnt_max + H_cnt;
                    //num_read <= N*N;
                    //addr_read <= (V_cnt - N/2) * H_cnt_max + H_cnt - N/2; // zuoshangjiao de nengsuanwanma?
                    //cnt_read_square <= N*N - 1;
                    out_of_range <= 0;
                    status <= s_youhua_1;
                end
                H_cntP1 <= H_cnt + 1;
                H_cntP2 <= H_cnt + 2;
                H_cntM1 <= H_cnt - 1;
                V_cntM1 <= V_cnt - 1;
            end
            s_youhua_1: begin
                if(H_cnt == 0) begin
                    data1_R <= buffer_R[0][H_cnt];
                    data2_R <= buffer_R[0][H_cntP1];
                    data3_R <= buffer_R[0][H_cntP2];
                    //data4_R <= buffer_R[1][H_cnt];
                    data5_R <= buffer_R[1][H_cntP1];
                    data6_R <= buffer_R[1][H_cntP2];
                    data7_R <= data_wr_out_median[15:11];
                    buffer_R[0][H_cnt] <= buffer_R[1][H_cnt];
                    buffer_R[1][H_cnt] <= data_wr_out_median[15:11];

                    data1_G <= buffer_G[0][H_cnt];
                    data2_G <= buffer_G[0][H_cntP1];
                    data3_G <= buffer_G[0][H_cntP2];
                    //data4_G <= buffer_G[1][H_cnt];
                    data5_G <= buffer_G[1][H_cntP1];
                    data6_G <= buffer_G[1][H_cntP2];
                    data7_G <= data_wr_out_median[10:5];
                    buffer_G[0][H_cnt] <= buffer_G[1][H_cnt];
                    buffer_G[1][H_cnt] <= data_wr_out_median[10:5];

                    data1_B <= buffer_B[0][H_cnt];
                    data2_B <= buffer_B[0][H_cntP1];
                    data3_B <= buffer_B[0][H_cntP2];
                    //data4_B <= buffer_B[1][H_cnt];
                    data5_B <= buffer_B[1][H_cntP1];
                    data6_B <= buffer_B[1][H_cntP2];
                    data7_B <= data_wr_out_median[4:0];
                    buffer_B[0][H_cnt] <= buffer_B[1][H_cnt];
                    buffer_B[1][H_cnt] <= data_wr_out_median[4:0];

                    out_of_range <= 1;
                    status <= s_set_data;
                end else if(H_cnt == 1) begin
                    data4_R <= buffer_R[0][H_cntM1];
                    data8_R <= data_wr_out_median[15:11];
                    buffer_R[0][H_cnt] <= buffer_R[1][H_cnt];
                    buffer_R[1][H_cnt] <= data_wr_out_median[15:11];

                    data4_G <= buffer_G[0][H_cntM1];
                    data8_G <= data_wr_out_median[10:5];
                    buffer_G[0][H_cnt] <= buffer_G[1][H_cnt];
                    buffer_G[1][H_cnt] <= data_wr_out_median[10:5];

                    data4_B <= buffer_B[0][H_cntM1];
                    data8_B <= data_wr_out_median[4:0];
                    buffer_B[0][H_cnt] <= buffer_B[1][H_cnt];
                    buffer_B[1][H_cnt] <= data_wr_out_median[4:0];

                    out_of_range <= 1;
                    status <= s_set_data;
                end else if(H_cnt == 2) begin
                    data9_R <= data_wr_out_median[15:11];
                    buffer_R[0][H_cnt] <= buffer_R[1][H_cnt];
                    buffer_R[1][H_cnt] <= data_wr_out_median[15:11];

                    data9_G <= data_wr_out_median[10:5];
                    buffer_G[0][H_cnt] <= buffer_G[1][H_cnt];
                    buffer_G[1][H_cnt] <= data_wr_out_median[10:5];

                    data9_B <= data_wr_out_median[4:0];
                    buffer_B[0][H_cnt] <= buffer_B[1][H_cnt];
                    buffer_B[1][H_cnt] <= data_wr_out_median[4:0];

                    frame_1_we <= 1;
                    frame_addr_1_w <= address;
                    frame_pixel_1_w <= data_wr_out_median;

                    cnt_calc_median <= 3;
                    address <= V_cntM1 * H_cnt_max + H_cntM1;
                    status <= s_calc_median;
                end else begin
                    data1_R <= data2_R;
                    data4_R <= data5_R;
                    data7_R <= data8_R;
                    data2_R <= data3_R;
                    data5_R <= data6_R;
                    data8_R <= data9_R;
                    data3_R <= buffer_R[0][H_cnt];
                    data6_R <= buffer_R[1][H_cnt];
                    data9_R <= data_wr_out_median[15:11];
                    buffer_R[0][H_cnt] <= buffer_R[1][H_cnt];
                    buffer_R[1][H_cnt] <= data_wr_out_median[15:11];

                    data1_G <= data2_G;
                    data4_G <= data5_G;
                    data7_G <= data8_G;
                    data2_G <= data3_G;
                    data5_G <= data6_G;
                    data8_G <= data9_G;
                    data3_G <= buffer_G[0][H_cnt];
                    data6_G <= buffer_G[1][H_cnt];
                    data9_G <= data_wr_out_median[10:5];
                    buffer_G[0][H_cnt] <= buffer_G[1][H_cnt];
                    buffer_G[1][H_cnt] <= data_wr_out_median[10:5];  

                    data1_B <= data2_B;
                    data4_B <= data5_B;
                    data7_B <= data8_B;
                    data2_B <= data3_B;
                    data5_B <= data6_B;
                    data8_B <= data9_B;
                    data3_B <= buffer_B[0][H_cnt];
                    data6_B <= buffer_B[1][H_cnt];
                    data9_B <= data_wr_out_median[4:0];
                    buffer_B[0][H_cnt] <= buffer_B[1][H_cnt];
                    buffer_B[1][H_cnt] <= data_wr_out_median[4:0];

                    frame_1_we <= 1;
                    frame_addr_1_w <= address;
                    frame_pixel_1_w <= data_wr_out_median;

                    cnt_calc_median <= 3;
                    address <= V_cntM1 * H_cnt_max + H_cntM1;
                    status <= s_calc_median;
                end
            end
            s_calc_median: begin
                frame_1_we <= 0;
                cnt_calc_median <= cnt_calc_median - 1;
                if(cnt_calc_median == 1) begin
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

                if(V_cnt <= 1) begin 
                    buffer_R[V_cnt[1:0]][H_cnt] <= data_wr_out_median[15:11];
                    buffer_G[V_cnt[1:0]][H_cnt] <= data_wr_out_median[10:5];
                    buffer_B[V_cnt[1:0]][H_cnt] <= data_wr_out_median[4:0];
                end

                frame_1_we <= 1;
                frame_addr_1_w <= address;
                if(out_of_range) begin
                    frame_pixel_1_w <= data_wr_out_median;    
                end else begin
                    frame_pixel_1_w <= {median_R,median_G,median_B}; 
                end
            end
            s_done: begin
                frame_1_we <= 0;
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
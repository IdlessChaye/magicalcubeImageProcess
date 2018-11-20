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
reg[9:0] H_cnt,V_cnt;
reg[16:0] address;


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
localparam s_read_square  = 4'b0011;
localparam s_calc_median  = 4'b0010;
localparam s_set_data     = 4'b1110;
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
                if(H_cnt < N - 1 || H_cnt > H_cnt_max - N || V_cnt < N - 1 || V_cnt > V_cnt_max - N) begin
                    enable_read <= 1;
                    num_read <= 1;
                    addr_read <= V_cnt * H_cnt_max + H_cnt;
                    out_of_range <= 1;
                    status <= s_set_data;
                end else begin
                    enable_read <= 1;
                    num_read <= N*N;
                    addr_read <= (V_cnt - N/2) * H_cnt_max + H_cnt - N/2; // zuoshangjiao de nengsuanwanma?
                    cnt_read_square <= N*N - 1;
                    out_of_range <= 0;
                    status <= s_read_square;
                end
            end
            s_read_square: begin // default N = 3
                cnt_read_square <= cnt_read_square - 1;
                case(cnt_read_square)
                    8: begin
                        addr_read <= (V_cnt - N/2) * H_cnt_max + H_cnt;
                        data1_R <= data_wr_out_median[15:11];
                        data1_G <= data_wr_out_median[10:5];
                        data1_B <= data_wr_out_median[4:0];
                    end
                    7: begin
                        addr_read <= (V_cnt - N/2) * H_cnt_max + H_cnt + N/2;
                        data2_R <= data_wr_out_median[15:11];
                        data2_G <= data_wr_out_median[10:5];
                        data2_B <= data_wr_out_median[4:0];
                    end
                    6: begin
                        addr_read <= (V_cnt) * H_cnt_max + H_cnt - N/2;
                        data3_R <= data_wr_out_median[15:11];
                        data3_G <= data_wr_out_median[10:5];
                        data3_B <= data_wr_out_median[4:0];                        
                    end
                    5: begin
                        addr_read <= (V_cnt) * H_cnt_max + H_cnt; 
                        data4_R <= data_wr_out_median[15:11];
                        data4_G <= data_wr_out_median[10:5];
                        data4_B <= data_wr_out_median[4:0];                        
                    end
                    4: begin
                        addr_read <= (V_cnt) * H_cnt_max + H_cnt + N/2;
                        data5_R <= data_wr_out_median[15:11];
                        data5_G <= data_wr_out_median[10:5];
                        data5_B <= data_wr_out_median[4:0];                        
                    end
                    3: begin
                        addr_read <= (V_cnt + N/2) * H_cnt_max + H_cnt - N/2;
                        data6_R <= data_wr_out_median[15:11];
                        data6_G <= data_wr_out_median[10:5];
                        data6_B <= data_wr_out_median[4:0];                        
                    end
                    2: begin
                        addr_read <= (V_cnt + N/2) * H_cnt_max + H_cnt;
                        data7_R <= data_wr_out_median[15:11];
                        data7_G <= data_wr_out_median[10:5];
                        data7_B <= data_wr_out_median[4:0];                        
                    end
                    1: begin
                        addr_read <= (V_cnt + N/2) * H_cnt_max + H_cnt + N/2;
                        data8_R <= data_wr_out_median[15:11];
                        data8_G <= data_wr_out_median[10:5];
                        data8_B <= data_wr_out_median[4:0];                        
                    end
                    0: begin
                        data9_R <= data_wr_out_median[15:11];
                        data9_G <= data_wr_out_median[10:5];
                        data9_B <= data_wr_out_median[4:0];
                    end
                    default: begin
                        addr_read <= 0;
                    end
                endcase

                if(cnt_read_square == 0) begin
                    cnt_calc_median <= 3;                
                    status <= s_calc_median;
                end else begin
                    status <= s_read_square;
                end
            end
            s_calc_median: begin
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
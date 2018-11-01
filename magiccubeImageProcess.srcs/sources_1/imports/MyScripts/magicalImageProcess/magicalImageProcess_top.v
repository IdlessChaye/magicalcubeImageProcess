 /* this program is the top file of magiccubeImageProcess project on github
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
module magicalImageProcess_top (
    input clk_in, 
    input rst, // high power work

    output OV7725_SIOC,
    inout  OV7725_SIOD,
    output OV7725_XCLK,
    input  OV7725_PCLK,
    input[7:0] OV7725_D,
    input OV7725_HREF,
    input OV7725_VSYNC,

    input[5:0] side_select_signals,
    input load_image_data_button,    
    input set_side_data_button,


    inout[15:0] sram_data,
    output[18:0] sram_addr,
    output sram_oe_r,
    output sram_ce_r,
    output sram_we_r,
    output sram_ub_r,
    output sram_lb_r,

    output[3:0] en0,en1,
    output[7:0] sseg0,sseg1,
    output signal0,

    output reg done_top
    );


    wire clk_wiz_0_clk_out1;
    wire clk_wiz_0_clk_out2;
    wire clk_in_1;
    assign clk_in_1 = clk_in;
    wire rst_1;
    assign rst_1 = rst;


    wire [15:0]ov7725_regData_0_LUT_DATA;
    wire [7:0]IICctrl_0_LUT_INDEX;
    wire [7:0]ov7725_regData_0_Slave_Addr;   


    wire IICctrl_0_I2C_SCLK;    
    assign OV7725_SIOC = IICctrl_0_I2C_SCLK;


    assign OV7725_XCLK = clk_wiz_0_clk_out1;
    wire pclk_1;
    wire [7:0]d_1;
    wire href_1;
    wire vsync_1;
    assign pclk_1 = OV7725_PCLK;    
    assign d_1 = OV7725_D[7:0];
    assign href_1 = OV7725_HREF;
    assign vsync_1 = OV7725_VSYNC; 

    wire [16:0]cam_ov7670_ov7725_0_addr;
    wire [15:0]cam_ov7670_ov7725_0_dout;
    wire cam_ov7670_ov7725_0_wclk; // 50MHz
    wire cam_ov7670_ov7725_0_we;
    wire[9:0] V_cnt,H_cnt;


    wire[5:0] fangdou_side_select_signals;
    wire[2:0] side_select_coding;
    wire fangdou_load_image_data_button;
    wire fangdou_set_side_data_button;
    

    reg[26:0] oneside_dout1 = 0;
    reg[26:0] oneside_dout2 = 0;
    reg[26:0] oneside_dout3 = 0;
    reg[26:0] oneside_dout4 = 0;
    reg[26:0] oneside_dout5 = 0;
    reg[26:0] oneside_dout6 = 0;
    //wire out_en;

    assign signal0 = cam_ov7670_ov7725_0_we;


    freq_divide freq_divide_0(
        .clki(clk_in_1),
        .clko_25MHz(clk_wiz_0_clk_out1),
        .clko_10MHz(clk_wiz_0_clk_out2)
    );

    ov7725_regData ov7725_regData_0 (
        .LUT_DATA(ov7725_regData_0_LUT_DATA),
        .LUT_INDEX(IICctrl_0_LUT_INDEX),
        .Slave_Addr(ov7725_regData_0_Slave_Addr)
    );

    IICctrl IICctrl_0 (
        .LUT_DATA(ov7725_regData_0_LUT_DATA),
        .LUT_INDEX(IICctrl_0_LUT_INDEX),
        .Slave_Addr(ov7725_regData_0_Slave_Addr),

        .I2C_SCLK(IICctrl_0_I2C_SCLK),
        .I2C_SDAT(OV7725_SIOD),

        .iCLK(clk_wiz_0_clk_out1),
        .rst(rst_1)
    );


    cam_ov7670_ov7725 cam_ov7670_ov7725_0 (
        .pclk(pclk_1),
        .vsync(vsync_1),
        .href(href_1),
        .d(d_1),
        
        .wclk(cam_ov7670_ov7725_0_wclk),
        .addr(cam_ov7670_ov7725_0_addr),
        .dout(cam_ov7670_ov7725_0_dout),
        .we(cam_ov7670_ov7725_0_we),
        .V_cnt(V_cnt),
        .H_cnt(H_cnt)
    );


    fangdou fangdou_0(
        .clk(clk_in_1),
        .button(side_select_signals[0]),
        .fangdou_button(fangdou_side_select_signals[0])
    );

    fangdou fangdou_1(
        .clk(clk_in_1),
        .button(side_select_signals[1]),
        .fangdou_button(fangdou_side_select_signals[1])
    );    

    fangdou fangdou_2(
        .clk(clk_in_1),
        .button(side_select_signals[2]),
        .fangdou_button(fangdou_side_select_signals[2])
    );    

    fangdou fangdou_3(
        .clk(clk_in_1),
        .button(side_select_signals[3]),
        .fangdou_button(fangdou_side_select_signals[3])
    );

    fangdou fangdou_4(
        .clk(clk_in_1),
        .button(side_select_signals[4]),
        .fangdou_button(fangdou_side_select_signals[4])
    );

    fangdou fangdou_5(
        .clk(clk_in_1),
        .button(side_select_signals[5]),
        .fangdou_button(fangdou_side_select_signals[5])
    );

    button2face button2face_0(
        .face_select_signals(fangdou_side_select_signals),
        .face_select(side_select_coding)
    );


    fangdou fangdou_6 (
        .clk(clk_in_1),
        .button(load_image_data_button),
        .fangdou_button(fangdou_load_image_data_button)
    );

    fangdou fangdou_7 (
        .clk(clk_in_1),
        .button(set_side_data_button),
        .fangdou_button(fangdou_set_side_data_button)
    );


    /*// need modified
    image2magicalhsv image2magicalhsv_0 (
        .wclk(cam_ov7670_ov7725_0_wclk),

        .H_cnt(H_cnt),
        .V_cnt(V_cnt),
        .din(cam_ov7670_ov7725_0_dout),
        .we(cam_ov7670_ov7725_0_we),
    
        .face_select(side_select),
        .oneface_dout1(oneside_dout1),
        .oneface_dout2(oneside_dout2),
        .oneface_dout3(oneside_dout3),
        .oneface_dout4(oneside_dout4),
        .oneface_dout5(oneside_dout5),
        .oneface_dout6(oneside_dout6),
        .out_en(out_en)
    );
    */




    localparam s_idle           = 4'b0000;
    localparam s_init           = 4'b0001;
    localparam s_write          = 4'b0011;
    localparam s_sramdetect     = 4'b0010;
    localparam s_hsv            = 4'b0111;
    localparam s_color_coding   = 4'b1111;
    localparam s_oneside_data   = 4'b1110;
    localparam s_done           = 4'b1100;
    localparam s_ready          = 4'b1000;
    reg [3:0] status = s_idle;



    wire enable_in_sram;
    wire selec_in_sram;
    wire write_in_sram;
    wire read_in_sram;
    wire[15:0] data_wr_in_in_sram;
    wire[18:0] addr_wr_in_sram;
    wire done_in_sram;
    assign enable_in_sram = fangdou_load_image_data_button;
    image_in_sram image_in_sram_0 (
        .wclk(cam_ov7670_ov7725_0_wclk),
        .rst(rst_1),

        .enable(enable_in_sram),

        .cam_addr(cam_ov7670_ov7725_0_addr),
        .cam_data(cam_ov7670_ov7725_0_dout),
        .cam_we(cam_ov7670_ov7725_0_we),

        .selec_in_sram(selec_in_sram),
        .write_in_sram(write_in_sram),
        .read_in_sram(read_in_sram),
        .data_wr_in_in_sram(data_wr_in_in_sram),
        .addr_wr_in_sram(addr_wr_in_sram),

        .done(done_in_sram)
    );


    wire enable_out_sram;
    wire continue_out_sram;
    wire selec_out_sram;
    wire write_out_sram;
    wire read_out_sram;
    wire[18:0] addr_wr_out_sram;
    wire[15:0] data_wr_out_out_sram;
    wire[15:0] rgb565;
    wire[8:0] position_coding;
    wire find_out_sram;
    wire done_out_sram;
    assign enable_out_sram = fangdou_set_side_data_button;
    wire done_data_set;
    assign continue_out_sram = done_data_set;
    image_out_sramdetect image_out_sramdetect_0 (
        .wclk(cam_ov7670_ov7725_0_wclk),
        .rst(rst_1),

        .enable(enable_out_sram),
        .continue(continue_out_sram),

        .selec_out_sram(selec_out_sram),
        .write_out_sram(write_out_sram),
        .read_out_sram(read_out_sram),
        .addr_wr_out_sram(addr_wr_out_sram),        
        .data_wr_out_out_sram(data_wr_out_out_sram),

        .rgb565(rgb565),
        .position_coding(position_coding),

        .find(find_out_sram),
        .done(done_out_sram)
    );


    wire selec;
    wire write;
    wire read;
    wire[15:0] data_wr_in;
    wire[15:0] data_wr_out;
    wire[18:0] addr_wr;
    sram_ctrl sram_ctrl_0 (
        .clk(cam_ov7670_ov7725_0_wclk),
        .rst_n(!rst_1),

        .selec(selec),
        .write(write),
        .read(read),
        .data_wr_in(data_wr_in),
        .data_wr_out(data_wr_out),
        .addr_wr(addr_wr),

        .sram_data(sram_data),
        .sram_addr(sram_addr),
        .sram_oe_r(sram_oe_r),
        .sram_ce_r(sram_ce_r),
        .sram_we_r(sram_we_r),
        .sram_ub_r(sram_ub_r),
        .sram_lb_r(sram_lb_r)
    );



    wire enable_rgb2hsv;
    wire[24:0] hsv25;
    wire done_rgb2hsv;
    assign enable_rgb2hsv = find_out_sram;
    rgb2hsv_clk rgb2hsv_clk_0 (
        .pclk(cam_ov7670_ov7725_0_wclk),
        .rst(rst_1), // high_power work

        .enable(enable_rgb2hsv), // high_power work
        .RGB24({rgb565[15:11],3'b000,rgb565[10:5],2'b00,rgb565[4:0],3'b000}),
        .HSV25(hsv25),

        .hsv_done(done_rgb2hsv)
    );


    wire enable_color_coding;
    wire[2:0] color_coding;
    wire done_color_coding;
    assign enable_color_coding = done_rgb2hsv;
    hsv2color_coding hsv2color_coding_0 (
        .clk(cam_ov7670_ov7725_0_wclk),
        .rst(rst_1),

        .enable(enable_color_coding),

        .hsv25(hsv25),
        .color_coding(color_coding),

        .done(done_color_coding)
    );


    wire enable_data_set;
    wire[26:0] oneside_dout;
    //wire done_data_set; // declare above 
    assign enable_data_set = done_color_coding;
    magic_side_data_set magic_side_data_set_0 (
        .clk(cam_ov7670_ov7725_0_wclk),
        .rst(rst_1),

        .enable(enable_data_set),

        .position_coding(position_coding),
        .color_coding(color_coding),
        .oneside_dout(oneside_dout),

        .done(done_data_set)
    );



reg last_little_turn;
always@(posedge cam_ov7670_ov7725_0_wclk) begin
    if(rst_1) begin
        done_top <= 0;
        last_little_turn <= 0;
        status <= s_idle;
    end else begin
        case(status)
            s_idle: begin
                done_top <= 0;
                last_little_turn <= 0;
                if(enable_in_sram) begin
                    status <= s_write;
                end else if(enable_out_sram) begin
                    status <= s_sramdetect;
                end else begin
                    status <= s_idle;
                end
            end
            s_write: begin
                if(done_in_sram) begin
                    status <= s_done;
                end
            end
            s_sramdetect: begin
                if(find_out_sram) begin
                    if(done_out_sram) begin
                        last_little_turn <= 1; // s_oneside_data needs this
                    end
                    status <= s_hsv;                    
                end else begin
                    status <= s_sramdetect;
                end
            end
            s_hsv: begin
                if(done_rgb2hsv) begin
                    status <= s_color_coding;
                end else begin
                    status <= s_hsv;
                end
            end
            s_color_coding: begin
                if(done_color_coding) begin
                    status <= s_oneside_data;
                end else begin
                    status <= s_color_coding;
                end
            end
            s_oneside_data: begin
                if(done_data_set) begin
                    if(last_little_turn) begin
                        status <= s_done;
                    end else begin
                        status <= s_sramdetect;
                    end
                end else begin
                    status <= s_oneside_data;
                end

                case(side_select_coding)
                    3'd1: oneside_dout1 <= oneside_dout;
                    3'd2: oneside_dout2 <= oneside_dout;
                    3'd3: oneside_dout3 <= oneside_dout;
                    3'd4: oneside_dout4 <= oneside_dout;
                    3'd5: oneside_dout5 <= oneside_dout;
                    3'd6: oneside_dout6 <= oneside_dout;
                    default: begin
                        // nop
                    end
                endcase
            end
            s_done: begin
                done_top <= 1;
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


assign selec = status == s_write ? selec_in_sram : status == s_sramdetect ? selec_out_sram : 1'b0;
assign write = status == s_write ? write_in_sram : status == s_sramdetect ? write_out_sram : 1'b0;
assign read  = status == s_write ? read_in_sram  : status == s_sramdetect ? read_out_sram  : 1'b0;
assign data_wr_in = status == s_write ? data_wr_in_in_sram : 16'bz;
assign addr_wr    = status == s_write ? addr_wr_in_sram    : status == s_sramdetect ? addr_wr_out_sram : 19'bz;
assign data_wr_out_out_sram = status == s_sramdetect ? data_wr_out : 16'bz;



    super_stop_watch_test super_stop_watch_test_0 (
        .en0(en0),.en1(en1),
        .sseg0(sseg0),.sseg1(sseg1),
        .show_data({oneside_dout2[4:0],oneside_dout1}),
        .clk(clk_in_1)
    );

endmodule
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
    output signal0,signal1,signal2,signal3,

    output reg done_top,

    // from tongtong
    output [3:0] vga_red,
    output [3:0] vga_green,
    output [3:0] vga_blue,
    output vga_hsync,
    output vga_vsync,
    output pwdm,
    output reset_cam
    );
    assign pwdm = 1'b0;
    assign reset_cam = 1'b1;
    parameter H_cnt_max = 320;
    parameter V_cnt_max = 240;

    wire clk_wiz_0_clk_out1;
    wire clk_wiz_0_clk_out2;
    wire clk_in_1;
    assign clk_in_1 = clk_in;
    wire rst_1;
    assign rst_1 = rst;


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
    assign signal1 = fangdou_load_image_data_button;
    assign signal2 = fangdou_set_side_data_button;
    assign signal3 = fangdou_side_select_signals[2];



    freq_divide freq_divide_0(
        .clki(clk_in_1),
        .clko_25MHz(clk_wiz_0_clk_out1),
        .clko_10MHz(clk_wiz_0_clk_out2)
    );


    IICctrl IICctrl_0 (
        .iCLK(clk_wiz_0_clk_out1),   
        .I2C_SCLK(IICctrl_0_I2C_SCLK),   
        .I2C_SDAT(OV7725_SIOD) 
    );


    cam_ov7670_ov7725 #(.H_cnt_max(H_cnt_max),
                        .V_cnt_max(V_cnt_max)) cam_ov7670_ov7725_0 (
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
    

    reg frame_1_we;
    reg[16:0] frame_addr_1_w;
    reg[15:0] frame_pixel_1_w;
    reg[16:0] frame_addr_1_r;
    wire[15:0] frame_pixel_1_r;
    blk_mem_gen_1 blk_mem_gen_1 (
          .clka(cam_ov7670_ov7725_0_wclk),    // input wire clka
          .wea(frame_1_we),      // input wire [0:0] wea
          .addra(frame_addr_1_w),  // input wire [16:0] addra
          .dina(frame_pixel_1_w),    // input wire [15:0] dina
          .clkb(cam_ov7670_ov7725_0_wclk),    // input wire clkb
          .addrb(frame_addr_1_r),  // input wire [16 : 0] addrb
          .doutb(frame_pixel_1_r)  // output wire [15 : 0] doutb
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




    localparam s_idle           = 4'b0000;
    localparam s_init           = 4'b0001;
    localparam s_write          = 4'b0011;
    localparam s_median_filter  = 4'b0100;
    localparam s_mean_filter    = 4'b0110;
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
    image_in_sram #(.H_cnt_max(H_cnt_max),
                    .V_cnt_max(V_cnt_max)) image_in_sram_0 (
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
    wire done_mean;   
    assign enable_out_sram = done_mean;
    wire done_data_set;
    assign continue_out_sram = done_data_set;
    image_out_sramdetect #(.H_cnt_max(H_cnt_max),
                           .V_cnt_max(V_cnt_max)) image_out_sramdetect_0 (
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


    reg selec;
    reg write;
    reg read;
    reg[15:0] data_wr_in;
    wire[15:0] data_wr_out;
    reg[18:0] addr_wr;
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


    wire enable_median;
    wire selec_median;
    wire write_median;
    wire read_median;
    wire[18:0] addr_wr_median;
    wire[15:0] data_wr_out_median;
    wire frame_1_we_median;
    wire[16:0] frame_addr_1_w_median;
    wire[15:0] frame_pixel_1_w_median;
    wire done_median;
    assign enable_median = fangdou_set_side_data_button;
    MedianFilter MedianFilter_0 (
        .wclk(clk_wiz_0_clk_out1),
        .rst(rst_1),

        .enable(enable_median),

        .selec_median(selec_median),
        .write_median(write_median),
        .read_median(read_median),
        .addr_wr_median(addr_wr_median),
        
        .data_wr_out_median(data_wr_out_median),

        .frame_1_we(frame_1_we_median),
        .frame_addr_1_w(frame_addr_1_w_median),
        .frame_pixel_1_w(frame_pixel_1_w_median),

        .done(done_median)
    );


    wire enable_mean;
    wire selec_mean;
    wire write_mean;
    wire read_mean;
    wire[18:0] addr_wr_mean;
    wire[15:0] data_wr_in_mean;
    wire[16:0] frame_addr_1_r_mean;
    wire[15:0] frame_pixel_1_r_mean;
    //wire done_mean;
    assign enable_mean = done_median;
    MeanFilter MeanFilter_0 (
        .wclk(clk_wiz_0_clk_out1),
        .rst(rst_1),

        .enable(enable_mean),

        .frame_addr_1_r(frame_addr_1_r_mean),
        .frame_pixel_1_r(frame_pixel_1_r_mean),

        .selec_mean(selec_mean),
        .write_mean(write_mean),
        .read_mean(read_mean),
        .data_wr_in_mean(data_wr_in_mean),
        .addr_wr_mean(addr_wr_mean),

        .done(done_mean)
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
    reg[8:0] color1_Hue_input = 0;
    reg[8:0] color2_Hue_input = 60;
    reg[8:0] color3_Hue_input = 120;
    reg[8:0] color4_Hue_input = 180;
    reg[8:0] color5_Hue_input = 240;
    reg[8:0] color6_Hue_input = 300;
    always@* begin
        case(fangdou_side_select_signals)
            6'b111110: begin
                color1_Hue_input = hsv25[24:16];
            end
            6'b111101: begin
                color2_Hue_input = hsv25[24:16];
            end            
            6'b111011: begin
                color3_Hue_input = hsv25[24:16];
            end       
            6'b110111: begin
                color4_Hue_input = hsv25[24:16];
            end            
            6'b101111: begin
                color5_Hue_input = hsv25[24:16];
            end
            6'b011111: begin
                color6_Hue_input = hsv25[24:16];
            end
            default: begin
                //nop
            end          
        endcase
    end
    wire[2:0] color_coding;
    wire done_color_coding;
    assign enable_color_coding = done_rgb2hsv;
    hsv2color_coding hsv2color_coding_0 (
        .clk(cam_ov7670_ov7725_0_wclk),
        .rst(rst_1),

        .enable(enable_color_coding),

        .color1_Hue_input(color1_Hue_input),
        .color2_Hue_input(color2_Hue_input),
        .color3_Hue_input(color3_Hue_input),
        .color4_Hue_input(color4_Hue_input),
        .color5_Hue_input(color5_Hue_input),
        .color6_Hue_input(color6_Hue_input),

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
                end else if(enable_median) begin
                    status <= s_median_filter;
                end
            end
            s_write: begin
                if(done_in_sram) begin
                    status <= s_done;
                end
            end
            s_median_filter: begin
                if(done_median) begin
                    status <= s_mean_filter;
                end
            end
            s_mean_filter: begin
                if(done_mean) begin
                    status <= s_sramdetect; 
                end
            end
            s_sramdetect: begin
                if(find_out_sram) begin
                    if(done_out_sram) begin
                        last_little_turn <= 1; // s_oneside_data needs this
                    end
                    status <= s_hsv;                    
                end
            end
            s_hsv: begin
                if(done_rgb2hsv) begin
                    status <= s_color_coding;
                end
            end
            s_color_coding: begin
                if(done_color_coding) begin
                    status <= s_oneside_data;
                end
            end
            s_oneside_data: begin
                if(done_data_set) begin
                    if(last_little_turn) begin
                        status <= s_done;
                    end else begin
                        status <= s_sramdetect;
                    end
                end

                if(last_little_turn) begin
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


    wire enable_reader;
    wire selec_reader;
    wire write_reader;
    wire read_reader;
    wire[18:0] addr_wr_reader;
    wire[15:0] data_wr_out_reader;
    wire[18:0] frame_addr_reader;
    wire[15:0] frame_pixel_reader;
    assign enable_reader = status == s_idle ? 1 : 0;
    sram_read_controller sram_read_controller_0 (
        .enable(enable_reader),
        .selec_reader(selec_reader),
        .write_reader(write_reader),
        .read_reader(read_reader),
        .addr_wr_reader(addr_wr_reader),
        .data_wr_out_reader(data_wr_out_reader),
        .addr_wr(frame_addr_reader),
        .data_wr_out(frame_pixel_reader)
    );



always@* begin
    if(status == s_write) begin
        selec = selec_in_sram;
    end else if(status == s_sramdetect) begin
        selec = selec_out_sram;
    end else if(status == s_median_filter) begin
        selec = selec_median;
    end else if(status == s_mean_filter) begin
        selec = selec_mean;
    end else if(status == s_idle) begin
        selec = selec_reader;
    end else begin
        selec = 0;
    end
end
always@* begin
    if(status == s_write) begin
        write = write_in_sram;
    end else if(status == s_sramdetect) begin
        write = write_out_sram;
    end else if(status == s_median_filter) begin
        write = write_median;
    end else if(status == s_mean_filter) begin
        write = write_mean;
    end else if(status == s_idle) begin
        write = write_reader;
    end else begin
        write = 0;
    end
end
always@* begin
    if(status == s_write) begin
        read = read_in_sram;
    end else if(status == s_sramdetect) begin
        read = read_out_sram;
    end else if(status == s_median_filter) begin
        read = read_median;
    end else if(status == s_mean_filter) begin
        read = read_mean;
    end else if(status == s_idle) begin
        read = read_reader;
    end else begin
        read = 0;
    end
end
always@* begin
    if(status == s_write) begin
        data_wr_in = data_wr_in_in_sram;
    end else if(status == s_mean_filter) begin
        data_wr_in = data_wr_in_mean;
    end else begin
        data_wr_in = 16'bz;
    end
end
always@* begin
    if(status == s_write) begin
        addr_wr = addr_wr_in_sram;
    end else if(status == s_sramdetect) begin
        addr_wr = addr_wr_out_sram;
    end else if(status == s_median_filter) begin
        addr_wr = addr_wr_median;
    end else if(status == s_mean_filter) begin
        addr_wr = addr_wr_mean;
    end else if(status == s_idle) begin
        addr_wr = addr_wr_reader;
    end else begin
        addr_wr = 19'bz;
    end
end

assign data_wr_out_out_sram = status == s_sramdetect ? data_wr_out : 16'bz;
assign data_wr_out_median   = status == s_median_filter ? data_wr_out : 16'bz;
assign data_wr_out_reader   = status == s_idle ? data_wr_out : 16'bz;



    super_stop_watch_test super_stop_watch_test_0 (
        .en0(en0),.en1(en1),
        .sseg0(sseg0),.sseg1(sseg1),
        .show_data({oneside_dout2[4:0],oneside_dout1}),
        .clk(clk_in_1)
    );




    // from tongtong
    wire[16:0] frame_addr_1_r_vga;
    wire[15:0] frame_pixel_1_r_vga;
    wire[18:0] frame_addr_reader_vga;
    wire[15:0] frame_pixel_reader_vga;
    vga_top vga_top_0(
        .clk25(clk_wiz_0_clk_out1), //25MHz
        .front_in(oneside_dout1),
        .left_in(oneside_dout2),
        .right_in(oneside_dout3),
        .back_in(oneside_dout4),
        .above_in(oneside_dout5),
        .below_in(oneside_dout6),
        .vga_red(vga_red),
        .vga_green(vga_green),
        .vga_blue(vga_blue),
        .vga_hsync(vga_hsync),
        .vga_vsync(vga_vsync),
        .frame_addr(frame_addr_1_r_vga),
        .frame_pixel(frame_pixel_1_r_vga),
        .frame_addr_reader(frame_addr_reader_vga),
        .frame_pixel_reader(frame_pixel_reader_vga)
    );


always@* begin
    if(status == s_median_filter) begin
        frame_1_we = frame_1_we_median;
    end else begin
        frame_1_we = 0;
    end
end
always@* begin
    if(status == s_median_filter) begin
        frame_addr_1_w = frame_addr_1_w_median;
    end else begin
        frame_addr_1_w = 0;
    end
end
always@* begin
    if(status == s_median_filter) begin
        frame_pixel_1_w = frame_pixel_1_w_median;
    end else begin
        frame_pixel_1_w = 0;
    end
end
always@* begin
    if(status == s_mean_filter) begin
        frame_addr_1_r = frame_addr_1_r_mean;
    end else begin
        frame_addr_1_r = frame_addr_1_r_vga;
    end
end

assign frame_pixel_1_r_mean = status == s_mean_filter ? frame_pixel_1_r : 0;
assign frame_pixel_1_r_vga  = status == s_mean_filter ? 0 : frame_pixel_1_r;

assign frame_addr_reader = frame_addr_reader_vga;
assign frame_pixel_reader_vga = frame_pixel_reader;
endmodule
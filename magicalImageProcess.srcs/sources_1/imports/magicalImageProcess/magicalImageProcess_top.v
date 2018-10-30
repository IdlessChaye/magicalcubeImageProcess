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
    output signal0
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
    wire cam_ov7670_ov7725_0_wclk;
    wire cam_ov7670_ov7725_0_we;
    wire[9:0] V_cnt,H_cnt;


    wire[5:0] fangdou_side_select_signals;
    wire[2:0] side_select;
    wire fangdou_load_image_data_button;
    wire fangdou_set_side_data_button;
    

    wire[26:0] oneside_dout1;
    wire[26:0] oneside_dout2;
    wire[26:0] oneside_dout3;
    wire[26:0] oneside_dout4;
    wire[26:0] oneside_dout5;
    wire[26:0] oneside_dout6;
    wire out_en;


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
        .clk(clk_in),
        .button(side_select_signals[0]),
        .fangdou_button(fangdou_side_select_signals[0])
    );

    fangdou fangdou_1(
        .clk(clk_in),
        .button(side_select_signals[1]),
        .fangdou_button(fangdou_side_select_signals[1])
    );    

    fangdou fangdou_2(
        .clk(clk_in),
        .button(side_select_signals[2]),
        .fangdou_button(fangdou_side_select_signals[2])
    );    

    fangdou fangdou_3(
        .clk(clk_in),
        .button(side_select_signals[3]),
        .fangdou_button(fangdou_side_select_signals[3])
    );

    fangdou fangdou_4(
        .clk(clk_in),
        .button(side_select_signals[4]),
        .fangdou_button(fangdou_side_select_signals[4])
    );

    fangdou fangdou_5(
        .clk(clk_in),
        .button(side_select_signals[5]),
        .fangdou_button(fangdou_side_select_signals[5])
    );

    button2face button2face_0(
        .face_select_signals(fangdou_side_select_signals),
        .face_select(side_select)
    );


    fangdou fangdou_6 (
        .clk(clk_in),
        .button(load_image_data_button),
        .fangdou_button(fangdou_load_image_data_button)
    );


    fangdou fangdou_7 (
        .clk(clk_in),
        .button(set_side_data_button),
        .fangdou_button(fangdou_set_side_data_button)
    );


    // need modified
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

    // image_in_sram
    // 
    // 
    // image_out_sram
    // 
    // pixel_detect (position_coding)
    // 
    // rgb2hsv
    // 
    // hsv2coding
    // 
    // magic_side_data_set
    // 
    // 
    // situation_machine
    
    parameter s_idle           = 4'b0000;
    parameter s_init           = 4'b0001;
    parameter s_write          = 4'b0011;
    parameter s_read           = 4'b0010;
    parameter s_ready          = 4'b0110;
    parameter s_done           = 4'b0111;
    reg [3:0] status = s_idle;



    wire enable_in_sram;
    wire selec_in_sram;
    wire write_in_sram;
    wire read_in_sram;
    wire[15:0] data_wr_in_in_sram;
    wire[18:0] addr_wr_in_sram;
    wire done_in_sram;
    image_in_sram image_in_sram_0 (
        .wclk(cam_ov7670_ov7725_0_wclk),
        .rst(rst_1),

        .enable(fangdou_load_image_data_button),

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
    wire selec_out_sram;
    wire write_out_sram;
    wire read_out_sram;
    wire[18:0] addr_wr_out_sram;
    wire[15:0] data_wr_out_out_sram;
    wire[15:0] cam_dout;
    wire done_out_sram;
    image_out_sram image_out_sram_0 (
        .wclk(cam_ov7670_ov7725_0_wclk),
        .rst(rst_1),

        .enable(enable_out_sram),

        .selec_out_sram(selec_out_sram),
        .write_out_sram(write_out_sram),
        .read_out_sram(read_out_sram),
        .data_wr_out_out_sram(data_wr_out_out_sram),
        .addr_wr_out_sram(addr_wr_out_sram),

        .cam_dout(cam_dout),

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

    assign selec = status == s_write ? selec_in_sram : status == s_read ? selec_out_sram : 1'b0;
    assign write = status == s_write ? write_in_sram : write_out_sram;
    assign read  = status == s_write ? read_in_sram  : read_out_sram;
    assign data_wr_in = status == s_write ? data_wr_in_in_sram : 16'bz;
    assign addr_wr    = status == s_write ? addr_wr_in_sram    : addr_wr_out_sram;



    wire enable_detect;
    wire[15:0] rgb565;
    wire[8:0] position_coding;
    wire find;
    wire done_detect;
    pixel_detect pixel_detect_0 (
        .clk(cam_ov7670_ov7725_0_wclk),
        .rst(rst_1),

        .enable(enable_detect),

        .data_wr_out(data_wr_out_out_sram),
        .addr_wr_out(addr_wr_out_sram),
        .rgb565(rgb565),
        .position_coding(position_coding),

        .find(find),

        .done(done_detect)
    );



    wire enable_rgb2hsv;
    wire[23:0] hsv24;
    wire done_rgb2hsv;
    rgb2hsv_clk rgb2hsv_clk_0 (
        .pclk(cam_ov7670_ov7725_0_wclk),
        .rst(rst_1), // high_power work

        .enable(enable_rgb2hsv), // high_power work
        .RGB24({rgb565[15:11],3'b000,rgb565[10:5],2'b00,rgb565[4:0],3'b000}),
        .HSV24(hsv24),

        .hsv_done(done_rgb2hsv)
    );


    wire enable_color;
    wire[2:0] color_coding;
    wire done_color;
    hsv2color_coding hsv2color_coding_0 (
        .clk(cam_ov7670_ov7725_0_wclk),
        .rst(rst_1),

        .enable(enable_color),

        .hsv24(hsv24),
        .color_coding(color_coding),

        .done(done_color)
    );



    wire enable_data;
    wire[26:0] oneside_dout;
    wire done_data;
    magic_side_data_set magic_side_data_set_0 (
        .clk(cam_ov7670_ov7725_0_wclk),
        .rst(rst_1),

        .enable(enable_data),

        .position_coding(position_coding),
        .color_coding(color_coding),
        .oneside_dout(oneside_dout),

        .done(done_data)
    );




    super_stop_watch_test super_stop_watch_test_0 (
        .en0(en0),.en1(en1),
        .sseg0(sseg0),.sseg1(sseg1),
        .show_data({oneside_dout2[4:0],oneside_dout1}),
        .clk(clk_in_1)
    );

endmodule
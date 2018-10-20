`timescale 1ns / 1ns

module magicalImageProcess_top (
    output OV7725_SIOC,
    inout  OV7725_SIOD,
    output OV7725_XCLK,
    input  OV7725_PCLK,
    input[7:0] OV7725_D,
    input OV7725_HREF,
    input OV7725_VSYNC,

    input clk_in1,
    input rst,

    output[3:0] en0,en1,
    output[7:0] sseg0,sseg1,
    output signal0,
    input[5:0] face_select_signals
    );

    wire clk_in1_1;
    wire clk_wiz_0_clk_out1;
    wire clk_wiz_0_clk_out2; 
    wire rst_1;

    wire [15:0]ov7725_regData_0_LUT_DATA;
    wire [7:0]IICctrl_0_LUT_INDEX;
    wire [7:0]ov7725_regData_0_Slave_Addr;    
    wire IICctrl_0_I2C_SCLK;    
    // OV7725_SIOD
    // assign OV7725_XCLK = clk_wiz_0_clk_out1;
    wire pclk_1;
    wire [7:0]d_1;
    wire href_1;
    wire vsync_1;
    wire [16:0]cam_ov7670_ov7725_0_addr;
    wire [15:0]cam_ov7670_ov7725_0_dout;
    wire cam_ov7670_ov7725_0_wclk;
    wire cam_ov7670_ov7725_0_we;

    assign clk_in1_1 = clk_in1;
    assign rst_1 = rst;
    assign OV7725_SIOC = IICctrl_0_I2C_SCLK;
    // assign OV7725_SIOD = OV7725_SIOC;
    assign OV7725_XCLK = clk_wiz_0_clk_out1;
    assign pclk_1 = OV7725_PCLK;
    assign d_1 = OV7725_D[7:0];
    assign href_1 = OV7725_HREF;
    assign vsync_1 = OV7725_VSYNC;  

    assign  signal0= cam_ov7670_ov7725_0_we;

    freq_divide freq_divide_0(
        .clki(clk_in1_1),
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

    wire[9:0] V_cnt,H_cnt;
    cam_ov7670_ov7725 cam_ov7670_ov7725_0 (
        .addr(cam_ov7670_ov7725_0_addr),
        .dout(cam_ov7670_ov7725_0_dout),
        .wclk(cam_ov7670_ov7725_0_wclk),
        .we(cam_ov7670_ov7725_0_we),
        .pclk(pclk_1),
        .d(d_1),
        .href(href_1),
        .vsync(vsync_1),
        .V_cnt(V_cnt),
        .H_cnt(H_cnt)
    );

    wire[5:0] fangdou_face_select_signals;
    wire[2:0] face_select;
    fangdou fangdou_0(
        .clk(clk_in1),
        .button(face_select_signals[0]),
        .fangdou_button(fangdou_face_select_signals[0])
    );
    fangdou fangdou_1(
        .clk(clk_in1),
        .button(face_select_signals[1]),
        .fangdou_button(fangdou_face_select_signals[1])
    );    
    fangdou fangdou_2(
        .clk(clk_in1),
        .button(face_select_signals[2]),
        .fangdou_button(fangdou_face_select_signals[2])
    );    
    fangdou fangdou_3(
        .clk(clk_in1),
        .button(face_select_signals[3]),
        .fangdou_button(fangdou_face_select_signals[3])
    );
    fangdou fangdou_4(
        .clk(clk_in1),
        .button(face_select_signals[4]),
        .fangdou_button(fangdou_face_select_signals[4])
    );
    fangdou fangdou_5(
        .clk(clk_in1),
        .button(face_select_signals[5]),
        .fangdou_button(fangdou_face_select_signals[5])
    );
    button2face button2face_0(
        .face_select_signals(fangdou_face_select_signals),
        .face_select(face_select)
    );

    wire[26:0] oneface_dout1;
    wire[26:0] oneface_dout2;
    wire[26:0] oneface_dout3;
    wire[26:0] oneface_dout4;
    wire[26:0] oneface_dout5;
    wire[26:0] oneface_dout6;
    wire out_en;
    image2magicalhsv image2magicalhsv_0 (
        .H_cnt(H_cnt),
        .V_cnt(V_cnt),
        .din(cam_ov7670_ov7725_0_dout),
        .we(cam_ov7670_ov7725_0_we),
        .wclk(cam_ov7670_ov7725_0_wclk),
        .face_select(face_select),
        .oneface_dout1(oneface_dout1),
        .oneface_dout2(oneface_dout2),
        .oneface_dout3(oneface_dout3),
        .oneface_dout4(oneface_dout4),
        .oneface_dout5(oneface_dout5),
        .oneface_dout6(oneface_dout6),
        .out_en(out_en)
    );
    
    super_stop_watch_test super_stop_watch_test_0 (
        .en0(en0),.en1(en1),
        .sseg0(sseg0),.sseg1(sseg1),
        .show_data({oneface_dout2[4:0],oneface_dout1}),
        .clk(clk_in1_1)
    );


endmodule
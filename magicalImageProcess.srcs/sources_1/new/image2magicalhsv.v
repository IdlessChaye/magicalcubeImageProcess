`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/19 19:59:40
// Design Name: 
// Module Name: image2magicalhsv
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


module image2magicalhsv (
    input[9:0] H_cnt,
    input[9:0] V_cnt,
    input[15:0] din,
    input we,
    input wclk,
    input[2:0] face_select, // which face to update
    output[26:0] oneface_dout1,
    output[26:0] oneface_dout2,
    output[26:0] oneface_dout3,
    output[26:0] oneface_dout4,
    output[26:0] oneface_dout5,
    output[26:0] oneface_dout6,
    output out_en // 因为组合逻辑太多，输出要延迟备好
    );
    
    reg[26:0] oneface_dout_reg=0,
              oneface_dout1_reg=0,
              oneface_dout2_reg=0,
              oneface_dout3_reg=0,
              oneface_dout4_reg=0,
              oneface_dout5_reg=0,
              oneface_dout6_reg=0;
    assign oneface_dout1 = oneface_dout1_reg;
    assign oneface_dout2 = oneface_dout2_reg;
    assign oneface_dout3 = oneface_dout3_reg;
    assign oneface_dout4 = oneface_dout4_reg;
    assign oneface_dout5 = oneface_dout5_reg;
    assign oneface_dout6 = oneface_dout6_reg;
    always @ * 
        case(face_select)
            3'b001: oneface_dout1_reg=oneface_dout_reg;
            3'b010: oneface_dout2_reg=oneface_dout_reg;
            3'b011: oneface_dout3_reg=oneface_dout_reg;
            3'b100: oneface_dout4_reg=oneface_dout_reg;
            3'b101: oneface_dout5_reg=oneface_dout_reg;
            3'b110: oneface_dout6_reg=oneface_dout_reg;
            default: begin
                oneface_dout1_reg=oneface_dout1_reg;
                oneface_dout2_reg=oneface_dout2_reg;
                oneface_dout3_reg=oneface_dout3_reg;
                oneface_dout4_reg=oneface_dout4_reg;
                oneface_dout5_reg=oneface_dout5_reg;
                oneface_dout6_reg=oneface_dout6_reg;
            end
        endcase

    // 采样坐标 
    localparam[11:0]h_zuoshang=40,
                    h_zhongshang=120, 
                    h_youshang=200,     
                    h_zuozhong=40,
                    h_zhongzhong=120,
                    h_youzhong=200,
                    h_zuoxia=40,
                    h_zhongxia=120, 
                    h_youxia=200;
    localparam[10:0]v_zuoshang=40-1,
                    v_zhongshang=40-1,
                    v_youshang=40-1,
                    v_zuozhong=120-1,
                    v_zhongzhong=120-1,
                    v_youzhong=120-1,
                    v_zuoxia=200-1,
                    v_zhongxia=200-1,
                    v_youxia=200-1;
                    
    reg[2:0]thiscolor_code=0; // pixal's color code

    // �???机设计要�?:
    // 1. dout[2:0] = thiscoler_code,�???�??  9
    // 2. out_en
    // 3. 指定坐标?? 11
    // 4. 延迟�??? 10
    reg[15:0] din_reg=0; // din_reg
    reg din_signal_reg=0; // 1为din => din_reg
    always @ (negedge wclk)
        if(din_signal_reg)
            din_reg <= din;
    reg out_en_reg=0;
    assign out_en = out_en_reg; // 输出使能，在延迟�???期间�?0,
    reg[3:0] delay_updata_position_reg=0; // 要延迟赋值的位置编号，从1?始计?
    parameter delay_T = 40; // 延迟40个wclk
    reg[5:0] delay_count = 0; // 延迟计数?
    wire delay_finish_signal; // 延迟完毕信号
    assign delay_finish_signal=delay_count==delay_T?1'b1:1'b0;
    always @ (posedge wclk)
        if(out_en_reg==0)
            if(delay_finish_signal)
                delay_count <= 0;
            else
                delay_count <= delay_count + 1;
        else
            delay_count <= 0;
    localparam[1:0] s_pixalDetect=2'b00,
                    s_dGenDelay  =2'b01,
                    s_dataUpdata =2'b11,
                    s_reset      =2'b10;
    reg[1:0] cur_s=0,next_s=0;
    always @ (posedge wclk)
        cur_s <= next_s;
    always @ * begin
        next_s = cur_s;
        case(cur_s)
            s_pixalDetect: begin
                if(H_cnt==h_zuoshang&&V_cnt==v_zuoshang) begin
                    next_s = s_dGenDelay;
                    out_en_reg = 0;
                    delay_updata_position_reg = 4'b0001;
                    din_signal_reg = 1;
                end else if(H_cnt==h_zhongshang&&V_cnt==v_zhongshang) begin
                    next_s = s_dGenDelay;
                    din_signal_reg = 1;
                    out_en_reg = 0;
                    delay_updata_position_reg = 4'b0010;
                end else if(H_cnt==h_youshang&&V_cnt==v_youshang) begin
                    next_s = s_dGenDelay;
                    din_signal_reg = 1;
                    out_en_reg = 0;
                    delay_updata_position_reg = 4'b0011;
                end else if(H_cnt==h_zuozhong&&V_cnt==v_zuozhong) begin
                    next_s = s_dGenDelay;
                    din_signal_reg = 1;
                    out_en_reg = 0;
                    delay_updata_position_reg = 4'b0100;                    
                end else if(H_cnt==h_zhongzhong&&V_cnt==v_zhongzhong) begin
                    next_s = s_dGenDelay;
                    din_signal_reg = 1;
                    out_en_reg = 0;
                    delay_updata_position_reg = 4'b0101;                    
                end else if(H_cnt==h_youzhong&&V_cnt==v_youzhong) begin
                    next_s = s_dGenDelay;
                    din_signal_reg = 1;
                    out_en_reg = 0;
                    delay_updata_position_reg = 4'b0110;                    
                end else if(H_cnt==h_zuoxia&&V_cnt==v_zuoxia) begin
                    next_s = s_dGenDelay;
                    din_signal_reg = 1;
                    out_en_reg = 0;
                    delay_updata_position_reg = 4'b0111;                    
                end else if(H_cnt==h_zhongxia&&V_cnt==v_zhongxia) begin
                    next_s = s_dGenDelay;
                    din_signal_reg = 1;
                    out_en_reg = 0;
                    delay_updata_position_reg = 4'b1000;                    
                end else if(H_cnt==h_youxia&&V_cnt==v_youxia) begin
                    next_s = s_dGenDelay;
                    din_signal_reg = 1;
                    out_en_reg = 0;
                    delay_updata_position_reg = 4'b1001;                   
                end else begin
                    din_signal_reg = 0;
                    delay_updata_position_reg = 4'b0000;//none
                    out_en_reg = 1;
                end 
            end
            s_dGenDelay:begin
                din_signal_reg=0;                
                if(delay_finish_signal)
                    next_s = s_dataUpdata;
            end
            s_dataUpdata:begin
                next_s = s_reset;
                case(delay_updata_position_reg) 
                    4'b0001:oneface_dout_reg[2:0]=thiscolor_code;
                    4'b0010:oneface_dout_reg[5:3]=thiscolor_code;
                    4'b0011:oneface_dout_reg[8:6]=thiscolor_code;
                    4'b0100:oneface_dout_reg[11:9]=thiscolor_code;
                    4'b0101:oneface_dout_reg[14:12]=thiscolor_code;
                    4'b0110:oneface_dout_reg[17:15]=thiscolor_code;
                    4'b0111:oneface_dout_reg[20:18]=thiscolor_code;
                    4'b1000:oneface_dout_reg[23:21]=thiscolor_code;
                    4'b1001:oneface_dout_reg[26:24]=thiscolor_code;
                    default:next_s = s_reset;
                 endcase
            end
            s_reset:begin
                next_s = s_pixalDetect;
                delay_updata_position_reg = 4'b0000;//none
                out_en_reg = 1;               
            end
            default:begin
                next_s = cur_s;              
            end
        endcase
    end

    // rgb2h_of_hsv
    wire[7:0] r,g,b,max,min,maxminusmin,gminusb,bminusr,rminusg;
    assign r = {din_reg[15:11],3'b000};
    assign g = {din_reg[10:5],2'b00};
    assign b = {din_reg[4:0],3'b000};
    assign max = r>(g>b?g:b) ? r : (g>b?g:b);
    assign min = r<(g<b?g:b) ? r : (g<b?g:b);
    assign maxminusmin = max-min;
    assign gminusb = g-b;
    assign bminusr = b-r;
    assign rminusg = r-g;
    wire[8:0] h;
    reg[8:0] h_reg;
    assign h = h_reg;
    always @ * begin
        if(max==min)
            h_reg = 0;
        else if(max==r && g<b)
            h_reg = 360+60*gminusb/maxminusmin;
        else if(max==r)
            h_reg =     60*gminusb/maxminusmin;
        else if(max==g)
            h_reg = 120+60*bminusr/maxminusmin;
        else if(max==b)
            h_reg = 240+60*rminusg/maxminusmin;
    end

    // h_of_hsv2color   white：s=0 v=1
    localparam[8:0]red=0,green=120,blue=240,
             orange=30,yellow=60;
    wire white;
    wire rd,gd,bd,od,yd;
    assign white = min > 225 ?1'b1:1'b0;
    assign rd = h-red;
    assign gd = h>green? h-green:green-h;
    assign bd = h>blue?  h-blue :blue-h;
    assign od = h>orange?h-orange:orange-h;
    assign yd = h>yellow?h-yellow:yellow-h;
    wire[8:0]rgmind,bomind,rgbomind,mind;
    assign rgmind = rd<gd?rd:gd;
    assign bomind = bd<od?bd:od;
    assign rgbomind = rgmind<bomind?rgmind:bomind;
    assign mind = rgbomind<yd?rgbomind:yd;
    // color encode
    localparam[2:0] white_code=3'b000,yellow_code=3'b001,
             blue_code=3'b010,green_code=3'b011,
             red_code=3'b100,orange_code=3'b101,NO_COLOR=3'b111;
    //reg[2:0]thiscolor_code=0;
    always @ * begin
        if(white)
            thiscolor_code = white_code; 
        else if(mind==rd)
            thiscolor_code = red_code;
        else if(mind==gd)
            thiscolor_code = green_code;
        else if(mind==od)
            thiscolor_code = orange_code;
        else if(mind==yd)
            thiscolor_code = yellow_code;
        else if(mind==bd)
            thiscolor_code = blue_code;
        else
            thiscolor_code = NO_COLOR;
    end

endmodule

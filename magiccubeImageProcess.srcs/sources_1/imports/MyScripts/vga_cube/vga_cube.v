`timescale 1ns / 1ps
 /* 
    Copyright (C) 2018 Tongtong, github IdlessChaya

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

module vga_cube(
input clk25,
input rst,
input [107:0]front,
input [107:0]left,
input [107:0]right,
input [107:0]back,
input [107:0]above,
input [107:0]below,
input [4:0] state,
output reg[3:0] vga_red,
output reg[3:0] vga_green,
output reg[3:0] vga_blue,
output reg vga_hsync,
output reg vga_vsync,
output [16:0] frame_addr,
input [15:0] frame_pixel,
output[18:0] frame_addr_reader,
input[15:0] frame_pixel_reader
    );
    //Timing constants
      parameter hRez   = 640;
      parameter hStartSync   = 640+16;
      parameter hEndSync     = 640+16+96;
      parameter hMaxCount    = 640+16+96+48;
    
      parameter vRez         = 480;
      parameter vStartSync   = 480+10;
      parameter vEndSync     = 480+10+2;
      parameter vMaxCount    = 480+10+2+33;
    
    parameter hsync_active   =0;
    parameter vsync_active  = 0;
    reg[9:0] hCounter;
    reg[9:0] vCounter;  
    reg [10:0]i;
    reg [10:0]j;
    reg [10:0]a;  
    reg blank;
    reg [255:0]mo;
    reg [255:0]fang;
    reg [255:0]fu;
    reg [255:0]yuan;
    reg [255:0]jiao;
    reg [255:0]xue;
    reg [255:0]xi;
    reg [255:0]tong;
    reg [255:0]lian;
    reg [255:0]xu;
    reg [255:0]bu;
    reg [255:0]jin;
    reg [255:0]xian;
    reg [255:0]shi;
   initial   hCounter = 10'b0;
   initial   vCounter = 10'b0;  
   initial   blank = 1'b1;    
   initial   mo   = 256'H0084_3FFE_2220_3FFC_2630_2B6E_32A4_2FF8_2888_2FF8_2888_2FF8_4940_4252_8C42_303E;
   initial   fang = 256'h0400_0300_0100_0004_FFFE_0400_0410_07F8_0410_0410_0410_0810_0810_1010_20A0_4040;
   initial   fu   = 256'h1008_1FFC_2000_2FF0_4810_8ff0_0810_0ff0_0400_0ff0_0c20_1240_2180_4240_0430_380E;
   initial   yuan = 256'h0008_3FFC_2100_2100_2208_2ffc_2808_2FF8_2808_2FF8_2080_2490_4488_4884_9284_0100;
   initial   jiao = 256'h0840_0840_7F40_0944_0A7E_FF88_0808_1F48_2250_CC50_0820_0E50_7850_0888_290E_1204;
   initial   xue  = 256'h2208_1108_1110_0020_7FFE_4002_8004_1FE0_0040_0184_FFFE_0100_0100_0100_0500_0200;
   initial   xi   = 256'h0038_7FC0_0400_0410_0820_3FC0_0100_0220_0410_3FF8_0108_0920_0910_1108_2508_0200;
   initial   tong = 256'h1080_1040_2048_27FC_4880_F910_1208_27FC_4142_F920_4120_0120_1A22_E222_441E_0800;
   initial   lian = 256'h0080_4088_2FFC_2100_0140_0250_E7F8_2040_2040_2048_2FFC_2040_2040_5046_8FFC_0000;
   initial   xu   = 256'h1040_1050_23F8_2040_4840_FFFC_1124_20A8_4220_F924_07FE_0040_1C60_E090_410C_0204;
   initial   bu   = 256'h0100_0900_0910_09F8_0900_0904_FFFE_0100_0910_0D18_1120_2120_00C0_0300_0C00_7000;
   initial   jin  = 256'h0220_4220_2228_2FFC_0220_0220_E220_2228_2FFC_2220_2220_2220_2420_5026_8FFC_0000;
   initial   xian = 256'h0010_1FF9_1010_1010_1FF0_1010_1010_1FF0_1450_4444_344C_1450_0440_0444_FFFE_0000;
   initial   shi  = 256'h0010_3FF8_0000_0000_0000_0004_FFFE_0100_0100_0920_1918_210C_4104_0100_0500_0200;
   parameter C_WHITE =  12'b111111111111;
   parameter C_BLACK =  12'b000000000000;
   parameter C_GREY = 12'b011101110111;
   parameter U = 128'h0810_0810_0810_0810_0810_0810_0420_03c0;
   parameter U1 = 128'h0850_0870_0850_0850_0850_0850_0490_0338;
   parameter U2 = 128'h10f0_1088_1088_1090_10a0_10c0_0940_0678;
   parameter F = 128'h07e0_0400_0400_07e0_0400_0400_0400_0400;
   parameter F1 = 128'h0F90_0830_0810_0f90_0810_0810_0810_0838;
   parameter F2 = 128'h1f70_1008_1008_1f10_1020_1040_1040_1078;
   parameter R = 128'h07c0_0420_0420_07c0_0500_0480_0440_0420;
   parameter R1 = 128'h0F90_0870_0850_0850_0f90_0910_0890_0878;
   parameter R2 = 128'h1f70_1088_1088_1f10_1420_1240_1140_10f8;
   parameter L = 128'h0400_0400_0400_0400_0400_0400_0400_07e0;
   parameter L1 = 128'h0810_0830_0810_0810_0810_0810_0810_0fb8;
   parameter L2 = 128'h1070_1008_1008_1010_1020_1040_1040_1f78;
   parameter B = 128'h07c0_0420_0420_07c0_0420_0420_0420_07c0;
   parameter B1 = 128'h0f10_08b0_0890_0f10_0890_0890_0890_0f38;
   parameter B2 = 128'h1e70_1108_1108_1e10_1120_1140_1140_1e78;
   parameter D = 128'h0780_0440_0420_0420_0420_0420_0440_0780;
   parameter D1 = 128'h0f10_08b0_0850_0850_0850_0850_0890_0f38;
   parameter D2 = 128'h1e70_1108_1088_1090_10a0_10c0_1140_1e78;
   reg [11:0] colour;
  always@(*)
  begin
  //liti_front
      if(hCounter>=187&&hCounter<211&&hCounter<=vCounter&&hCounter>vCounter-35)
        colour<=front[11:0];
      else if(hCounter>=211&&hCounter<235&&hCounter<=vCounter&&hCounter>vCounter-35)
        colour<=front[23:12];
      else if(hCounter>=235&&hCounter<259&&hCounter<=vCounter&&hCounter>vCounter-35)
        colour<=front[35:24];
      else if(hCounter>=187&&hCounter<211&&hCounter<=vCounter-35&&hCounter>vCounter-70)
        colour<=front[47:36];
      else if(hCounter>=211&&hCounter<235&&hCounter<=vCounter-35&&hCounter>vCounter-70)
        colour<=front[59:48];
      else if(hCounter>=235&&hCounter<259&&hCounter<=vCounter-35&&hCounter>vCounter-70)
        colour<=front[71:60];
      else if(hCounter>=187&&hCounter<211&&hCounter<=vCounter-70&&hCounter>vCounter-105)
        colour<=front[83:72];
      else if(hCounter>=211&&hCounter<235&&hCounter<=vCounter-70&&hCounter>vCounter-105)
        colour<=front[95:84];
      else if(hCounter>=235&&hCounter<259&&hCounter<=vCounter-70&&hCounter>vCounter-105)
        colour<=front[107:96];
  //liti_right
      else if(hCounter>=259&&hCounter<283&&hCounter+vCounter>=518&&hCounter+vCounter<553)
        colour<=right[11:0];
      else if(hCounter>=283&&hCounter<307&&hCounter+vCounter>=518&&hCounter+vCounter<553)
        colour<=right[23:12];
      else if(hCounter>=307&&hCounter<331&&hCounter+vCounter>=518&&hCounter+vCounter<553)
        colour<=right[35:24];
      else if(hCounter>=259&&hCounter<283&&hCounter+vCounter>=553&&hCounter+vCounter<588)
        colour<=right[47:36];
      else if(hCounter>=283&&hCounter<307&&hCounter+vCounter>=553&&hCounter+vCounter<588)
        colour<=right[59:48];
      else if(hCounter>=307&&hCounter<331&&hCounter+vCounter>=553&&hCounter+vCounter<588)
        colour<=right[71:60];
      else if(hCounter>=259&&hCounter<283&&hCounter+vCounter>=588&&hCounter+vCounter<623)
        colour<=right[83:72];
      else if(hCounter>=283&&hCounter<307&&hCounter+vCounter>=588&&hCounter+vCounter<623)
        colour<=right[95:84];
      else if(hCounter>=307&&hCounter<331&&hCounter+vCounter>=588&&hCounter+vCounter<623)
        colour<=right[107:96];
  //liti_above
      else if(hCounter+vCounter>=374&&hCounter+vCounter<422&&hCounter<=vCounter+144&&hCounter>vCounter+96)
        colour<=above[11:0];
      else if(hCounter+vCounter>=422&&hCounter+vCounter<470&&hCounter<=vCounter+144&&hCounter>vCounter+96)
        colour<=above[23:12];
      else if(hCounter+vCounter>=470&&hCounter+vCounter<518&&hCounter<=vCounter+144&&hCounter>vCounter+96)
        colour<=above[35:24];
      else if(hCounter+vCounter>=374&&hCounter+vCounter<422&&hCounter<=vCounter+96&&hCounter>vCounter+48)
        colour<=above[47:36];
      else if(hCounter+vCounter>=422&&hCounter+vCounter<470&&hCounter<=vCounter+96&&hCounter>vCounter+48)
        colour<=above[59:48];
      else if(hCounter+vCounter>=470&&hCounter+vCounter<518&&hCounter<=vCounter+96&&hCounter>vCounter+48)
        colour<=above[71:60];
      else if(hCounter+vCounter>=374&&hCounter+vCounter<422&&hCounter<=vCounter+48&&hCounter>vCounter)
        colour<=above[83:72];
      else if(hCounter+vCounter>=422&&hCounter+vCounter<470&&hCounter<=vCounter+48&&hCounter>vCounter)
        colour<=above[95:84];
      else if(hCounter+vCounter>=470&&hCounter+vCounter<518&&hCounter<=vCounter+48&&hCounter>vCounter)
        colour<=above[107:96];
  //below_side
      else if(((hCounter>=422&&hCounter<424)||(hCounter>=439&&hCounter<441)||(hCounter>=457&&hCounter<459)||(hCounter>=475&&hCounter<476))&&vCounter>=272&&vCounter<326)
        colour<=C_BLACK;
      else if(hCounter>=424&&hCounter<439&&((vCounter>=272&&vCounter<274)||(vCounter>=289&&vCounter<291)||(vCounter>=307&&vCounter<309)||(vCounter>=324&&vCounter<326)))
        colour<=C_BLACK;
      else if(hCounter>=441&&hCounter<457&&((vCounter>=272&&vCounter<274)||(vCounter>=289&&vCounter<291)||(vCounter>=307&&vCounter<309)||(vCounter>=324&&vCounter<326)))
        colour<=C_BLACK;
      else if(hCounter>=459&&hCounter<475&&((vCounter>=272&&vCounter<274)||(vCounter>=289&&vCounter<291)||(vCounter>=307&&vCounter<309)||(vCounter>=324&&vCounter<326)))
        colour<=C_BLACK;
      else if(hCounter>=424&&hCounter<439&&vCounter>=274&&vCounter<289)
        colour<=below[11:0];
      else if(hCounter>=441&&hCounter<457&&vCounter>=274&&vCounter<289)
        colour<=below[23:12];
      else if(hCounter>=459&&hCounter<475&&vCounter>=274&&vCounter<289)
        colour<=below[35:24];
      else if(hCounter>=424&&hCounter<439&&vCounter>=291&&vCounter<307)
        colour<=below[47:36];
      else if(hCounter>=441&&hCounter<457&&vCounter>=291&&vCounter<307)
        colour<=below[59:48];
      else if(hCounter>=459&&hCounter<475&&vCounter>=291&&vCounter<307)
        colour<=below[71:60];
      else if(hCounter>=424&&hCounter<439&&vCounter>=309&&vCounter<324)
        colour<=below[83:72];
      else if(hCounter>=441&&hCounter<457&&vCounter>=309&&vCounter<324)
        colour<=below[95:84];
      else if(hCounter>=459&&hCounter<475&&vCounter>=309&&vCounter<324)
        colour<=below[107:96]; 
  //left_side
    else if(((hCounter>=356&&hCounter<358)||(hCounter>=373&&hCounter<375)||(hCounter>=391&&hCounter<393)||(hCounter>=409&&hCounter<411))&&vCounter>=206&&vCounter<260)
      colour<=C_BLACK;
    else if(hCounter>=358&&hCounter<373&&((vCounter>=206&&vCounter<208)||(vCounter>=223&&vCounter<225)||(vCounter>=241&&vCounter<243)||(vCounter>=258&&vCounter<260)))
      colour<=C_BLACK;
    else if(hCounter>=375&&hCounter<391&&((vCounter>=206&&vCounter<208)||(vCounter>=223&&vCounter<225)||(vCounter>=241&&vCounter<243)||(vCounter>=258&&vCounter<260)))
      colour<=C_BLACK;
    else if(hCounter>=393&&hCounter<409&&((vCounter>=206&&vCounter<208)||(vCounter>=223&&vCounter<225)||(vCounter>=241&&vCounter<243)||(vCounter>=258&&vCounter<260)))
      colour<=C_BLACK;
    else if(hCounter>=358&&hCounter<373&&vCounter>=208&&vCounter<223)
      colour<=left[11:0];
    else if(hCounter>=375&&hCounter<391&&vCounter>=208&&vCounter<223)
      colour<=left[23:12];
    else if(hCounter>=393&&hCounter<409&&vCounter>=208&&vCounter<223)
      colour<=left[35:24];
    else if(hCounter>=358&&hCounter<373&&vCounter>=225&&vCounter<241)
      colour<=left[47:36];
    else if(hCounter>=375&&hCounter<391&&vCounter>=225&&vCounter<241)
      colour<=left[59:48];
    else if(hCounter>=393&&hCounter<409&&vCounter>=225&&vCounter<241)
      colour<=left[71:60];
    else if(hCounter>=358&&hCounter<373&&vCounter>=243&&vCounter<258)
      colour<=left[83:72];
    else if(hCounter>=375&&hCounter<391&&vCounter>=243&&vCounter<258)
      colour<=left[95:84];
    else if(hCounter>=393&&hCounter<409&&vCounter>=243&&vCounter<258)
      colour<=left[107:96];
//front_side
    else if(((hCounter>=422&&hCounter<424)||(hCounter>=439&&hCounter<441)||(hCounter>=457&&hCounter<459)||(hCounter>=474&&hCounter<476))&&vCounter>=206&&vCounter<260)
      colour<=C_BLACK;
    else if(hCounter>=424&&hCounter<439&&((vCounter>=206&&vCounter<208)||(vCounter>=223&&vCounter<225)||(vCounter>=241&&vCounter<243)||(vCounter>=258&&vCounter<260)))
      colour<=C_BLACK;
    else if(hCounter>=441&&hCounter<457&&((vCounter>=206&&vCounter<208)||(vCounter>=223&&vCounter<225)||(vCounter>=241&&vCounter<243)||(vCounter>=258&&vCounter<260)))
      colour<=C_BLACK;
    else if(hCounter>=459&&hCounter<474&&((vCounter>=206&&vCounter<208)||(vCounter>=223&&vCounter<225)||(vCounter>=241&&vCounter<243)||(vCounter>=258&&vCounter<260)))
      colour<=C_BLACK;
    else if(hCounter>=424&&hCounter<439&&vCounter>=208&&vCounter<223)
      colour<=front[11:0];
    else if(hCounter>=441&&hCounter<457&&vCounter>=208&&vCounter<223)
      colour<=front[23:12];
    else if(hCounter>=459&&hCounter<474&&vCounter>=208&&vCounter<223)
      colour<=front[35:24];
    else if(hCounter>=424&&hCounter<439&&vCounter>=225&&vCounter<243)
      colour<=front[47:36];
    else if(hCounter>=441&&hCounter<457&&vCounter>=225&&vCounter<243)
      colour<=front[59:48];
    else if(hCounter>=459&&hCounter<474&&vCounter>=225&&vCounter<243)
      colour<=front[71:60];
    else if(hCounter>=424&&hCounter<439&&vCounter>=243&&vCounter<258)
      colour<=front[83:72];
    else if(hCounter>=441&&hCounter<457&&vCounter>=243&&vCounter<258)
      colour<=front[95:84];
    else if(hCounter>=459&&hCounter<474&&vCounter>=243&&vCounter<258)
      colour<=front[107:96]; 
//right_side
    else if(((hCounter>=488&&hCounter<490)||(hCounter>=505&&hCounter<507)||(hCounter>=523&&hCounter<525)||(hCounter>=540&&hCounter<542))&&vCounter>=206&&vCounter<260)
      colour<=C_BLACK;
    else if(hCounter>=490&&hCounter<505&&((vCounter>=206&&vCounter<208)||(vCounter>=223&&vCounter<225)||(vCounter>=241&&vCounter<243)||(vCounter>=258&&vCounter<260)))
      colour<=C_BLACK;
    else if(hCounter>=507&&hCounter<523&&((vCounter>=206&&vCounter<208)||(vCounter>=223&&vCounter<225)||(vCounter>=241&&vCounter<243)||(vCounter>=258&&vCounter<260)))
      colour<=C_BLACK;
    else if(hCounter>=525&&hCounter<540&&((vCounter>=206&&vCounter<208)||(vCounter>=223&&vCounter<225)||(vCounter>=241&&vCounter<243)||(vCounter>=258&&vCounter<260)))
      colour<=C_BLACK;
    else if(hCounter>=490&&hCounter<505&&vCounter>=208&&vCounter<223)
      colour<=right[11:0];
    else if(hCounter>=507&&hCounter<523&&vCounter>=208&&vCounter<223)
      colour<=right[23:12];
    else if(hCounter>=525&&hCounter<540&&vCounter>=208&&vCounter<223)
      colour<=right[35:24];
    else if(hCounter>=490&&hCounter<505&&vCounter>=225&&vCounter<241)
      colour<=right[47:36];
    else if(hCounter>=507&&hCounter<523&&vCounter>=225&&vCounter<241)
      colour<=right[59:48];
    else if(hCounter>=525&&hCounter<540&&vCounter>=225&&vCounter<241)
      colour<=right[71:60];
    else if(hCounter>=490&&hCounter<505&&vCounter>=243&&vCounter<258)
      colour<=right[83:72];
    else if(hCounter>=507&&hCounter<523&&vCounter>=243&&vCounter<258)
      colour<=right[95:84];
    else if(hCounter>=525&&hCounter<540&&vCounter>=243&&vCounter<258)
      colour<=right[107:96];
//back_side
    else if(((hCounter>=554&&hCounter<556)||(hCounter>=571&&hCounter<573)||(hCounter>=589&&hCounter<591)||(hCounter>=606&&hCounter<608))&&vCounter>=206&&vCounter<260)
      colour<=C_BLACK;
    else if(hCounter>=556&&hCounter<571&&((vCounter>=206&&vCounter<208)||(vCounter>=223&&vCounter<225)||(vCounter>=241&&vCounter<243)||(vCounter>=258&&vCounter<260)))
      colour<=C_BLACK;
    else if(hCounter>=573&&hCounter<589&&((vCounter>=206&&vCounter<208)||(vCounter>=223&&vCounter<225)||(vCounter>=241&&vCounter<243)||(vCounter>=258&&vCounter<260)))
      colour<=C_BLACK;
    else if(hCounter>=591&&hCounter<606&&((vCounter>=206&&vCounter<208)||(vCounter>=223&&vCounter<225)||(vCounter>=241&&vCounter<243)||(vCounter>=258&&vCounter<260)))
      colour<=C_BLACK;
    else if(hCounter>=556&&hCounter<571&&vCounter>=208&&vCounter<223)
      colour<=back[11:0];
    else if(hCounter>=573&&hCounter<589&&vCounter>=208&&vCounter<223)
      colour<=back[23:12];
    else if(hCounter>=591&&hCounter<606&&vCounter>=208&&vCounter<223)
      colour<=back[35:24];
    else if(hCounter>=556&&hCounter<571&&vCounter>=225&&vCounter<241)
      colour<=back[47:36];
    else if(hCounter>=573&&hCounter<589&&vCounter>=225&&vCounter<241)
      colour<=back[59:48];
    else if(hCounter>=591&&hCounter<606&&vCounter>=225&&vCounter<241)
      colour<=back[71:60];
    else if(hCounter>=556&&hCounter<571&&vCounter>=243&&vCounter<258)
      colour<=back[83:72];
    else if(hCounter>=573&&hCounter<589&&vCounter>=243&&vCounter<258)
      colour<=back[95:84];
    else if(hCounter>=591&&hCounter<606&&vCounter>=243&&vCounter<258)
      colour<=back[107:96];
//above_side
    else if(((hCounter>=422&&hCounter<424)||(hCounter>=439&&hCounter<441)||(hCounter>=457&&hCounter<459)||(hCounter>=474&&hCounter<476))&&vCounter>=140&&vCounter<194)
      colour<=C_BLACK;
    else if(hCounter>=424&&hCounter<439&&((vCounter>=140&&vCounter<142)||(vCounter>=157&&vCounter<159)||(vCounter>=175&&vCounter<177)||(vCounter>=192&&vCounter<194)))
      colour<=C_BLACK;
    else if(hCounter>=441&&hCounter<457&&((vCounter>=140&&vCounter<142)||(vCounter>=157&&vCounter<159)||(vCounter>=175&&vCounter<177)||(vCounter>=192&&vCounter<194)))
      colour<=C_BLACK;
    else if(hCounter>=459&&hCounter<474&&((vCounter>=140&&vCounter<142)||(vCounter>=157&&vCounter<159)||(vCounter>=175&&vCounter<177)||(vCounter>=192&&vCounter<194)))
      colour<=C_BLACK;
    else if(hCounter>=424&&hCounter<439&&vCounter>=142&&vCounter<157)
      colour<=above[11:0];
    else if(hCounter>=441&&hCounter<457&&vCounter>=142&&vCounter<157)
      colour<=above[23:12];
    else if(hCounter>=459&&hCounter<474&&vCounter>=142&&vCounter<157)
      colour<=above[35:24];
    else if(hCounter>=424&&hCounter<439&&vCounter>=159&&vCounter<175)
      colour<=above[47:36];
    else if(hCounter>=441&&hCounter<457&&vCounter>=159&&vCounter<175)
      colour<=above[59:48];
    else if(hCounter>=459&&hCounter<474&&vCounter>=159&&vCounter<175)
      colour<=above[71:60];
    else if(hCounter>=424&&hCounter<439&&vCounter>=177&&vCounter<192)
      colour<=above[83:72];
    else if(hCounter>=441&&hCounter<457&&vCounter>=177&&vCounter<192)
      colour<=above[95:84];
    else if(hCounter>=459&&hCounter<474&&vCounter>=177&&vCounter<192)
      colour<=above[107:96]; 
    //标题
    else if(hCounter>=157&&hCounter<189&&vCounter>=20&&vCounter<52)
      begin
          i=51-vCounter;
          j=188-hCounter;
          i=i/2;
          j=j/2;
          a=16*i+j;
          if(mo[a]==1)
          colour<=C_BLACK;
          else
          colour<=C_WHITE;
      end
    else if(hCounter>=199&&hCounter<231&&vCounter>=20&&vCounter<52)
      begin
      i=51-vCounter;
      j=230-hCounter;
      i=i/2;
      j=j/2;
      a=16*i+j;
      if(fang[a]==1)
      colour<=C_BLACK;
      else
      colour<=C_WHITE;
      end
      else if(hCounter>=241&&hCounter<273&&vCounter>=20&&vCounter<52)
      begin
      i=51-vCounter;
      j=272-hCounter;
      i=i/2;
      j=j/2;
      a=16*i+j;
      if(fu[a]==1)
      colour<=C_BLACK;
      else
      colour<=C_WHITE;
      end
    else if(hCounter>=283&&hCounter<315&&vCounter>=20&&vCounter<52)
      begin
      i=51-vCounter;
      j=314-hCounter;
      i=i/2;
      j=j/2;
      a=16*i+j;
      if(yuan[a]==1)
      colour<=C_BLACK;
      else
      colour<=C_WHITE;
      end
    else if(hCounter>=325&&hCounter<357&&vCounter>=20&&vCounter<52)
      begin
      i=51-vCounter;
      j=356-hCounter;
      i=i/2;
      j=j/2;
      a=16*i+j;
      if(jiao[a]==1)
      colour<=C_BLACK;
      else
      colour<=C_WHITE;
      end
    else if(hCounter>=367&&hCounter<399&&vCounter>=20&&vCounter<52)
      begin
      i=51-vCounter;
      j=398-hCounter;
      i=i/2;
      j=j/2;
      a=16*i+j;
      if(xue[a]==1)
      colour<=C_BLACK;
      else
      colour<=C_WHITE;
      end
    else if(hCounter>=409&&hCounter<441&&vCounter>=20&&vCounter<52)
      begin
      i=51-vCounter;
      j=440-hCounter;
      i=i/2;
      j=j/2;
      a=16*i+j;
      if(xi[a]==1)
      colour<=C_BLACK;
      else
      colour<=C_WHITE;
      end
    else if(hCounter>=451&&hCounter<483&&vCounter>=20&&vCounter<52)
      begin
      i=51-vCounter;
      j=482-hCounter;
      i=i/2;
      j=j/2;
      a=16*i+j;
      if(tong[a]==1)
      colour<=C_BLACK;
      else
      colour<=C_WHITE;
      end
      //模式显示
    else if(hCounter>=30&&hCounter<62&&vCounter>=300&&vCounter<332)
      begin
      i=331-vCounter;
      j=61-hCounter;
      i=i/2;
      j=j/2;
      a=16*i+j;
      if(lian[a]==1&&rst==1)
      colour<=C_BLACK;
      else
      colour<=C_WHITE;
      end
    else if(hCounter>=72&&hCounter<104&&vCounter>=300&&vCounter<332)
      begin
      i=331-vCounter;
      j=103-hCounter;
      i=i/2;
      j=j/2;
      a=16*i+j;
      if(xu[a]==1&&rst==1)
      colour<=C_BLACK;
      else
      colour<=C_WHITE;
      end
    else if(hCounter>=114&&hCounter<146&&vCounter>=300&&vCounter<332)
      begin
      i=331-vCounter;
      j=145-hCounter;
      i=i/2;
      j=j/2;
      a=16*i+j;
      if(xian[a]==1&&rst==1)
      colour<=C_BLACK;
      else
      colour<=C_WHITE;
      end
    else if(hCounter>=156&&hCounter<188&&vCounter>=300&&vCounter<332)
      begin
      i=331-vCounter;
      j=187-hCounter;
      i=i/2;
      j=j/2;
      a=16*i+j;
      if(shi[a]==1&&rst==1)
      colour<=C_BLACK;
      else
      colour<=C_WHITE;
      end
    else if(hCounter>=30&&hCounter<62&&vCounter>=342&&vCounter<374)
      begin
      i=373-vCounter;
      j=61-hCounter;
      i=i/2;
      j=j/2;
      a=16*i+j;
      if(bu[a]==1&&rst==0)
      colour<=C_BLACK;
      else
      colour<=C_WHITE;
      end
    else if(hCounter>=72&&hCounter<104&&vCounter>=342&&vCounter<374)
      begin
      i=373-vCounter;
      j=103-hCounter;
      i=i/2;
      j=j/2;
      a=16*i+j;
      if(jin[a]==1&&rst==0)
      colour<=C_BLACK;
      else
      colour<=C_WHITE;
      end
    else if(hCounter>=114&&hCounter<146&&vCounter>=342&&vCounter<374)
      begin
      i=373-vCounter;
      j=145-hCounter;
      i=i/2;
      j=j/2;
      a=16*i+j;
      if(xian[a]==1&&rst==0)
      colour<=C_BLACK;
      else
      colour<=C_WHITE;
      end
    else if(hCounter>=156&&hCounter<188&&vCounter>=342&&vCounter<374)
      begin
      i=373-vCounter;
      j=187-hCounter;
      i=i/2;
      j=j/2;
      a=16*i+j;
      if(shi[a]==1&&rst==0)
      colour<=C_BLACK;
      else
      colour<=C_WHITE;
      end
      //显示字符
    else if(hCounter>=30&&hCounter<62&&vCounter>=80&&vCounter<96)
      begin
      i=95-vCounter;
      j=61-hCounter;
      i=i/2;
      j=j/2;
      a=16*i+j;
      if(U[a]==1&&state==5'b00000)
        begin colour<=C_BLACK;end
      else if(U[a])
        colour<=C_GREY;
      else
        colour<=C_WHITE;
      end
    else if(hCounter>=74&&hCounter<106&&vCounter>=80&&vCounter<96)
      begin
      i=95-vCounter;
      j=105-hCounter;
      i=i/2;
      j=j/2;
      a=16*i+j;
      if(U1[a]==1&&state==5'b00001)
        begin colour<=C_BLACK;end
      else if(U1[a])
        colour<=C_GREY;
      else
        colour<=C_WHITE;
      end
    else if(hCounter>=118&&hCounter<150&&vCounter>=80&&vCounter<96)
      begin
      i=95-vCounter;
      j=149-hCounter;
      i=i/2;
      j=j/2;
      a=16*i+j;
      if(U2[a]==1&&state==5'b00010)
        begin colour<=C_BLACK;end
      else if(U2[a])
        colour<=C_GREY;
      else
        colour<=C_WHITE;
      end
    else if(hCounter>=30&&hCounter<62&&vCounter>=106&&vCounter<122)
      begin
      i=121-vCounter;
      j=61-hCounter;
      i=i/2;
      j=j/2;
      a=16*i+j;
      if(D[a]==1&&state==5'b00011)
        begin colour<=C_BLACK;end
      else if(D[a])
        colour<=C_GREY;
      else
        colour<=C_WHITE;
      end
    else if(hCounter>=74&&hCounter<106&&vCounter>=106&&vCounter<122)
      begin
      i=121-vCounter;
      j=105-hCounter;
      i=i/2;
      j=j/2;
      a=16*i+j;
      if(D1[a]==1&&state==5'b00100)
        begin colour<=C_BLACK;end
      else if(D1[a])
        colour<=C_GREY;
      else
        colour<=C_WHITE;
      end
    else if(hCounter>=118&&hCounter<150&&vCounter>=106&&vCounter<122)
      begin
      i=121-vCounter;
      j=149-hCounter;
      i=i/2;
      j=j/2;
      a=16*i+j;
      if(D2[a]==1&&state==5'b00101)
        begin colour<=C_BLACK;end
      else if(D2[a])
        colour<=C_GREY;
      else
        colour<=C_WHITE;
      end
    else if(hCounter>=30&&hCounter<62&&vCounter>=132&&vCounter<148)
      begin
      i=147-vCounter;
      j=61-hCounter;
      i=i/2;
      j=j/2;
      a=16*i+j;
      if(F[a]==1&&state==5'b00110)
        begin colour<=C_BLACK;end
      else if(F[a])
        colour<=C_GREY;
      else
        colour<=C_WHITE;
      end
    else if(hCounter>=74&&hCounter<106&&vCounter>=132&&vCounter<148)
    begin
    i=147-vCounter;
    j=105-hCounter;
    i=i/2;
    j=j/2;
    a=16*i+j;
    if(F1[a]==1&&state==5'b00111)
      begin colour<=C_BLACK;end
    else if(F1[a])
      colour<=C_GREY;
    else
      colour<=C_WHITE;
    end
    else if(hCounter>=118&&hCounter<150&&vCounter>=132&&vCounter<148)
    begin
    i=147-vCounter;
    j=149-hCounter;
    i=i/2;
    j=j/2;
    a=16*i+j;
    if(F2[a]==1&&state==5'b01000)
      begin colour<=C_BLACK;end
    else if(F2[a])
      colour<=C_GREY;
    else
      colour<=C_WHITE;
    end
    else if(hCounter>=30&&hCounter<62&&vCounter>=158&&vCounter<174)
    begin
    i=173-vCounter;
    j=61-hCounter;
    i=i/2;
    j=j/2;
    a=16*i+j;
    if(B[a]==1&&state==5'b01001)
      begin colour<=C_BLACK;end
    else if(B[a])
      colour<=C_GREY;
    else
      colour<=C_WHITE;
    end
    else if(hCounter>=74&&hCounter<106&&vCounter>=158&&vCounter<174)
    begin
    i=173-vCounter;
    j=105-hCounter;
    i=i/2;
    j=j/2;
    a=16*i+j;
    if(B1[a]==1&&state==5'b01010)
      begin colour<=C_BLACK;end
    else if(B1[a])
      colour<=C_GREY;
    else
      colour<=C_WHITE;
    end
    else if(hCounter>=118&&hCounter<150&&vCounter>=158&&vCounter<174)
    begin
    i=173-vCounter;
    j=149-hCounter;
    i=i/2;
    j=j/2;
    a=16*i+j;
    if(B2[a]==1&&state==5'b01011)
      begin colour<=C_BLACK;end
    else if(B2[a])
      colour<=C_GREY;
    else
      colour<=C_WHITE;
    end
    else if(hCounter>=30&&hCounter<62&&vCounter>=184&&vCounter<200)
    begin
    i=199-vCounter;
    j=61-hCounter;
    i=i/2;
    j=j/2;
    a=16*i+j;
    if(R[a]==1&&state==5'b01100)
      begin colour<=C_BLACK;end
    else if(R[a])
      colour<=C_GREY;
    else
      colour<=C_WHITE;
    end
    else if(hCounter>=74&&hCounter<106&&vCounter>=184&&vCounter<200)
    begin
    i=199-vCounter;
    j=105-hCounter;
    i=i/2;
    j=j/2;
    a=16*i+j;
    if(R1[a]==1&&state==5'b01101)
      begin colour<=C_BLACK;end
    else if(R1[a])
      colour<=C_GREY;
    else
      colour<=C_WHITE;
    end
    else if(hCounter>=118&&hCounter<150&&vCounter>=184&&vCounter<200)
    begin
    i=199-vCounter;
    j=149-hCounter;
    i=i/2;
    j=j/2;
    a=16*i+j;
    if(R2[a]==1&&state==5'b01110)
      begin colour<=C_BLACK;end
    else if(R2[a])
      colour<=C_GREY;
    else
      colour<=C_WHITE;
    end
    else if(hCounter>=30&&hCounter<62&&vCounter>=210&&vCounter<226)
    begin
    i=225-vCounter;
    j=61-hCounter;
    i=i/2;
    j=j/2;
    a=16*i+j;
    if(L[a]==1&&state==5'b01111)
      begin colour<=C_BLACK;end
    else if(L[a])
      colour<=C_GREY;
    else
      colour<=C_WHITE;
    end
    else if(hCounter>=74&&hCounter<106&&vCounter>=210&&vCounter<226)
    begin
    i=225-vCounter;
    j=105-hCounter;
    i=i/2;
    j=j/2;
    a=16*i+j;
    if(L1[a]==1&&state==5'b10000)
      begin colour<=C_BLACK;end
    else if(L1[a])
      colour<=C_GREY;
    else
      colour<=C_WHITE;
    end
    else if(hCounter>=118&&hCounter<150&&vCounter>=210&&vCounter<226)
      begin
      i=225-vCounter;
      j=149-hCounter;
      i=i/2;
      j=j/2;
      a=16*i+j;
      if(L2[a]==1&&state==5'b10001)
        begin colour<=C_BLACK;end
      else if(L2[a])
        colour<=C_GREY;
      else
        colour<=C_WHITE;
      end
    else if(hCounter>=0&&hCounter<320&&vCounter>=0&&vCounter<240) begin
        if(hCounter == 40 ||hCounter ==  120||hCounter == 200) begin
            colour <= C_BLACK;
        end else if(vCounter == 40 ||vCounter ==  120||vCounter == 200) begin
            colour <= C_BLACK;
        end else begin
            colour <= {frame_pixel[15:12],frame_pixel[10:7],frame_pixel[4:1]};
        end
    end
    else if(hCounter>=0&&hCounter<320&&vCounter>=240&&vCounter<480) begin
        if(hCounter == 40 ||hCounter ==  120||hCounter == 200) begin
            colour <= C_BLACK;
        end else if(vCounter == 280 ||vCounter ==  360||vCounter == 440) begin
            colour <= C_BLACK;
        end else begin
            colour <= {frame_pixel_reader[15:12],frame_pixel_reader[10:7],frame_pixel_reader[4:1]};
        end
    end
    else
      colour<=C_WHITE;
  end


parameter address_max = 320 * 240;
reg[16:0] address;
assign frame_addr = address;
always @ (posedge clk25) begin
    if(hCounter>=0&&hCounter<320&&vCounter>=0&&vCounter<240)
        address <= address + 1;
    else if(address >= address_max-1)
        address <= 0;
end

parameter address2_max = 320 * 240;
reg[16:0] address2;
assign frame_addr_reader = {2'b0,address2};
always @ (posedge clk25) begin
    if(hCounter>=0&&hCounter<320&&vCounter>=240&&vCounter<480)
        address2 <= address2 + 1;
    else if(address2 >= address2_max-1)
        address2 <= 0;
end



 
   always@(posedge clk25)
   begin
            if( hCounter == hMaxCount-1 )begin//行扫描最大
   				hCounter <=  10'b0;
   				if (vCounter == vMaxCount-1 )//场扫描最大屏幕归零
   					vCounter <=  10'b0;
   				else
   					vCounter <= vCounter+1;//否则向下一行
   				end
   			else
   				hCounter <= hCounter+1;//该行继续扫描
   
   			if (blank ==0) begin          //blank ==0为数据有效期 blank ==1为消隐期
   				vga_red   <= colour[11:8];
   				vga_green <= colour[7:4];
   				vga_blue  <= colour[3:0];
   				end
   			else begin//blank==1数据无效
   				vga_red   <= 4'b0;
   				vga_green <= 4'b0;
   				vga_blue  <= 4'b0;
   			     end;
   	
   			if(  vCounter  >= 480 || vCounter  < 0) begin    //场计数器大于等于480后开始进入场消隐期
   				blank <= 1;
   				end
   			else begin
   				if ( hCounter  < 640 && hCounter  >= 0) begin  //行计数器在0到639期间为行有效期
   					blank <= 0;
   					end
   				else
   					blank <= 1;
   				end;
   	
   			// Are we in the hSync pulse? (one has been added to include frame_buffer_latency)
   			//parameter hStartSync   = 640+16;
            //parameter hEndSync     = 640+16+96;
            //每一行有一个96个点周期的行同步信号
   			if( hCounter > hStartSync && hCounter <= hEndSync)
   				vga_hsync <= hsync_active;
   			else
   				vga_hsync <= ~ hsync_active;
   			
   
   			// Are we in the vSync pulse?
   			//parameter vStartSync   = 480+10;
            //parameter vEndSync     = 480+10+2;
            //每一场有一个2个行周期的场同步信号
   			if( vCounter >= vStartSync && vCounter < vEndSync )
   				vga_vsync <= vsync_active;
   			else
   				vga_vsync <= ~ vsync_active;
   end 
endmodule

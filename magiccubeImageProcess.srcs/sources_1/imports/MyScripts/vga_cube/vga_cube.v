`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/02/09 08:47:54
// Design Name: 
// Module Name: vga1
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

module vga_cube(
input clk25,
input [107:0]front,
input [107:0]left,
input [107:0]right,
input [107:0]back,
input [107:0]above,
input [107:0]below,
output reg[3:0] vga_red,
output reg[3:0] vga_green,
output reg[3:0] vga_blue,
output reg vga_hsync,
output reg vga_vsync
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
    reg blank;
   initial   hCounter = 10'b0;
   initial   vCounter = 10'b0;  
   initial   blank = 1'b1;    
   parameter C_WHITE =  12'b111111111111;
   parameter C_BLACK =  12'b000000000000;
   parameter U = 64'h42_42_42_42_42_42_24_18;
   parameter F = 64'h7e_40_40_40_7e_40_40_40;
   parameter R = 64'h7e_42_42_42_7c_48_44_42;
   parameter L = 64'h40_40_40_40_40_40_40_7e;
   parameter B = 64'h7c_42_42_7c_42_42_42_7c;
   parameter D = 64'h78_44_42_42_42_42_44_78;
   parameter shun = 256'h000447fe5420544455fe55045524552455245524552455245420445884840302;
   parameter ni   = 256'h0208411030a017fc00400248f2481248124813f8124810401080290647fc0000;
   parameter fan  = 256'h001000783f80200020003ff824082410221022202140208041404230840e1804;
   reg [11:0] colour;
  always@(*)
  begin
  //below_side
      if(((hCounter>=194&&hCounter<196)||(hCounter>=226&&hCounter<230)||(hCounter>=260&&hCounter<264)||(hCounter>=294&&hCounter<296))&&vCounter>=332&&vCounter<434)
        colour<=C_BLACK;
      else if(hCounter>=196&&hCounter<226&&((vCounter>=332&&vCounter<334)||(vCounter>=364&&vCounter<368)||(vCounter>=398&&vCounter<402)||(vCounter>=432&&vCounter<434)))
        colour<=C_BLACK;
      else if(hCounter>=230&&hCounter<260&&((vCounter>=332&&vCounter<334)||(vCounter>=364&&vCounter<368)||(vCounter>=398&&vCounter<402)||(vCounter>=432&&vCounter<434)))
        colour<=C_BLACK;
      else if(hCounter>=264&&hCounter<294&&((vCounter>=332&&vCounter<334)||(vCounter>=364&&vCounter<368)||(vCounter>=398&&vCounter<402)||(vCounter>=432&&vCounter<434)))
        colour<=C_BLACK;
      else if(hCounter>=196&&hCounter<226&&vCounter>=334&&vCounter<364)
        colour<=below[11:0];
      else if(hCounter>=230&&hCounter<260&&vCounter>=334&&vCounter<364)
        colour<=below[23:12];
      else if(hCounter>=264&&hCounter<294&&vCounter>=334&&vCounter<364)
        colour<=below[35:24];
      else if(hCounter>=196&&hCounter<226&&vCounter>=368&&vCounter<398)
        colour<=below[47:36];
      else if(hCounter>=230&&hCounter<260&&vCounter>=368&&vCounter<398)
        colour<=below[59:48];
      else if(hCounter>=264&&hCounter<294&&vCounter>=368&&vCounter<398)
        colour<=below[71:60];
      else if(hCounter>=196&&hCounter<226&&vCounter>=402&&vCounter<432)
        colour<=below[83:72];
      else if(hCounter>=230&&hCounter<260&&vCounter>=402&&vCounter<432)
        colour<=below[95:84];
      else if(hCounter>=264&&hCounter<294&&vCounter>=402&&vCounter<432)
        colour<=below[107:96]; 
  //left_side
    else if(((hCounter>=46&&hCounter<48)||(hCounter>=78&&hCounter<82)||(hCounter>=112&&hCounter<116)||(hCounter>=146&&hCounter<148))&&vCounter>=187&&vCounter<289)
      colour<=C_BLACK;
    else if(hCounter>=48&&hCounter<78&&((vCounter>=187&&vCounter<189)||(vCounter>=219&&vCounter<223)||(vCounter>=253&&vCounter<257)||(vCounter>=287&&vCounter<289)))
      colour<=C_BLACK;
    else if(hCounter>=82&&hCounter<112&&((vCounter>=187&&vCounter<189)||(vCounter>=219&&vCounter<223)||(vCounter>=253&&vCounter<257)||(vCounter>=287&&vCounter<289)))
      colour<=C_BLACK;
    else if(hCounter>=116&&hCounter<146&&((vCounter>=187&&vCounter<189)||(vCounter>=219&&vCounter<223)||(vCounter>=253&&vCounter<257)||(vCounter>=287&&vCounter<289)))
      colour<=C_BLACK;
    else if(hCounter>=48&&hCounter<78&&vCounter>=189&&vCounter<219)
      colour<=left[11:0];
    else if(hCounter>=82&&hCounter<112&&vCounter>=189&&vCounter<219)
      colour<=left[23:12];
    else if(hCounter>=116&&hCounter<146&&vCounter>=189&&vCounter<219)
      colour<=left[35:24];
    else if(hCounter>=48&&hCounter<78&&vCounter>=223&&vCounter<253)
      colour<=left[47:36];
    else if(hCounter>=82&&hCounter<112&&vCounter>=223&&vCounter<253)
      colour<=left[59:48];
    else if(hCounter>=116&&hCounter<146&&vCounter>=223&&vCounter<253)
      colour<=left[71:60];
    else if(hCounter>=48&&hCounter<78&&vCounter>=257&&vCounter<287)
      colour<=left[83:72];
    else if(hCounter>=82&&hCounter<112&&vCounter>=257&&vCounter<287)
      colour<=left[95:84];
    else if(hCounter>=116&&hCounter<146&&vCounter>=257&&vCounter<287)
      colour<=left[107:96];
//front_side
    else if(((hCounter>=194&&hCounter<196)||(hCounter>=226&&hCounter<230)||(hCounter>=260&&hCounter<264)||(hCounter>=294&&hCounter<296))&&vCounter>=187&&vCounter<289)
      colour<=C_BLACK;
    else if(hCounter>=196&&hCounter<226&&((vCounter>=187&&vCounter<189)||(vCounter>=219&&vCounter<223)||(vCounter>=253&&vCounter<257)||(vCounter>=287&&vCounter<289)))
      colour<=C_BLACK;
    else if(hCounter>=230&&hCounter<260&&((vCounter>=187&&vCounter<189)||(vCounter>=219&&vCounter<223)||(vCounter>=253&&vCounter<257)||(vCounter>=287&&vCounter<289)))
      colour<=C_BLACK;
    else if(hCounter>=264&&hCounter<294&&((vCounter>=187&&vCounter<189)||(vCounter>=219&&vCounter<223)||(vCounter>=253&&vCounter<257)||(vCounter>=287&&vCounter<289)))
      colour<=C_BLACK;
    else if(hCounter>=196&&hCounter<226&&vCounter>=189&&vCounter<219)
      colour<=front[11:0];
    else if(hCounter>=230&&hCounter<260&&vCounter>=189&&vCounter<219)
      colour<=front[23:12];
    else if(hCounter>=264&&hCounter<294&&vCounter>=189&&vCounter<219)
      colour<=front[35:24];
    else if(hCounter>=196&&hCounter<226&&vCounter>=223&&vCounter<253)
      colour<=front[47:36];
    else if(hCounter>=230&&hCounter<260&&vCounter>=223&&vCounter<253)
      colour<=front[59:48];
    else if(hCounter>=264&&hCounter<294&&vCounter>=223&&vCounter<253)
      colour<=front[71:60];
    else if(hCounter>=196&&hCounter<226&&vCounter>=257&&vCounter<287)
      colour<=front[83:72];
    else if(hCounter>=230&&hCounter<260&&vCounter>=257&&vCounter<287)
      colour<=front[95:84];
    else if(hCounter>=264&&hCounter<294&&vCounter>=257&&vCounter<287)
      colour<=front[107:96]; 
//right_side
    else if(((hCounter>=342&&hCounter<344)||(hCounter>=374&&hCounter<378)||(hCounter>=408&&hCounter<412)||(hCounter>=442&&hCounter<444))&&vCounter>=187&&vCounter<289)
      colour<=C_BLACK;
    else if(hCounter>=344&&hCounter<374&&((vCounter>=187&&vCounter<189)||(vCounter>=219&&vCounter<223)||(vCounter>=253&&vCounter<257)||(vCounter>=287&&vCounter<289)))
      colour<=C_BLACK;
    else if(hCounter>=378&&hCounter<408&&((vCounter>=187&&vCounter<189)||(vCounter>=219&&vCounter<223)||(vCounter>=253&&vCounter<257)||(vCounter>=287&&vCounter<289)))
      colour<=C_BLACK;
    else if(hCounter>=412&&hCounter<442&&((vCounter>=187&&vCounter<189)||(vCounter>=219&&vCounter<223)||(vCounter>=253&&vCounter<257)||(vCounter>=287&&vCounter<289)))
      colour<=C_BLACK;
    else if(hCounter>=344&&hCounter<374&&vCounter>=189&&vCounter<219)
      colour<=right[11:0];
    else if(hCounter>=378&&hCounter<408&&vCounter>=189&&vCounter<219)
      colour<=right[23:12];
    else if(hCounter>=412&&hCounter<442&&vCounter>=189&&vCounter<219)
      colour<=right[35:24];
    else if(hCounter>=344&&hCounter<374&&vCounter>=223&&vCounter<253)
      colour<=right[47:36];
    else if(hCounter>=378&&hCounter<408&&vCounter>=223&&vCounter<253)
      colour<=right[59:48];
    else if(hCounter>=412&&hCounter<442&&vCounter>=223&&vCounter<253)
      colour<=right[71:60];
    else if(hCounter>=344&&hCounter<374&&vCounter>=257&&vCounter<287)
      colour<=right[83:72];
    else if(hCounter>=378&&hCounter<408&&vCounter>=257&&vCounter<287)
      colour<=right[95:84];
    else if(hCounter>=412&&hCounter<442&&vCounter>=257&&vCounter<287)
      colour<=right[107:96];
//back_side
    else if(((hCounter>=490&&hCounter<492)||(hCounter>=522&&hCounter<526)||(hCounter>=556&&hCounter<560)||(hCounter>=590&&hCounter<592))&&vCounter>=187&&vCounter<289)
      colour<=C_BLACK;
    else if(hCounter>=492&&hCounter<522&&((vCounter>=187&&vCounter<189)||(vCounter>=219&&vCounter<223)||(vCounter>=253&&vCounter<257)||(vCounter>=287&&vCounter<289)))
      colour<=C_BLACK;
    else if(hCounter>=526&&hCounter<556&&((vCounter>=187&&vCounter<189)||(vCounter>=219&&vCounter<223)||(vCounter>=253&&vCounter<257)||(vCounter>=287&&vCounter<289)))
      colour<=C_BLACK;
    else if(hCounter>=560&&hCounter<590&&((vCounter>=187&&vCounter<189)||(vCounter>=219&&vCounter<223)||(vCounter>=253&&vCounter<257)||(vCounter>=287&&vCounter<289)))
      colour<=C_BLACK;
    else if(hCounter>=492&&hCounter<522&&vCounter>=189&&vCounter<219)
      colour<=back[11:0];
    else if(hCounter>=526&&hCounter<556&&vCounter>=189&&vCounter<219)
      colour<=back[23:12];
    else if(hCounter>=560&&hCounter<590&&vCounter>=189&&vCounter<219)
      colour<=back[35:24];
    else if(hCounter>=492&&hCounter<522&&vCounter>=223&&vCounter<253)
      colour<=back[47:36];
    else if(hCounter>=526&&hCounter<556&&vCounter>=223&&vCounter<253)
      colour<=back[59:48];
    else if(hCounter>=560&&hCounter<590&&vCounter>=223&&vCounter<253)
      colour<=back[71:60];
    else if(hCounter>=492&&hCounter<522&&vCounter>=257&&vCounter<287)
      colour<=back[83:72];
    else if(hCounter>=526&&hCounter<556&&vCounter>=257&&vCounter<287)
      colour<=back[95:84];
    else if(hCounter>=560&&hCounter<590&&vCounter>=257&&vCounter<287)
      colour<=back[107:96];
//above_side
    else if(((hCounter>=194&&hCounter<196)||(hCounter>=226&&hCounter<230)||(hCounter>=260&&hCounter<264)||(hCounter>=294&&hCounter<296))&&vCounter>=43&&vCounter<145)
      colour<=C_BLACK;
    else if(hCounter>=196&&hCounter<226&&((vCounter>=43&&vCounter<45)||(vCounter>=75&&vCounter<79)||(vCounter>=109&&vCounter<113)||(vCounter>=143&&vCounter<145)))
      colour<=C_BLACK;
    else if(hCounter>=230&&hCounter<260&&((vCounter>=43&&vCounter<45)||(vCounter>=75&&vCounter<79)||(vCounter>=109&&vCounter<113)||(vCounter>=143&&vCounter<145)))
      colour<=C_BLACK;
    else if(hCounter>=264&&hCounter<294&&((vCounter>=43&&vCounter<45)||(vCounter>=75&&vCounter<79)||(vCounter>=109&&vCounter<113)||(vCounter>=143&&vCounter<145)))
      colour<=C_BLACK;
    else if(hCounter>=196&&hCounter<226&&vCounter>=45&&vCounter<75)
      colour<=above[11:0];
    else if(hCounter>=230&&hCounter<260&&vCounter>=45&&vCounter<75)
      colour<=above[23:12];
    else if(hCounter>=264&&hCounter<294&&vCounter>=45&&vCounter<75)
      colour<=above[35:24];
    else if(hCounter>=196&&hCounter<226&&vCounter>=79&&vCounter<109)
      colour<=above[47:36];
    else if(hCounter>=230&&hCounter<260&&vCounter>=79&&vCounter<109)
      colour<=above[59:48];
    else if(hCounter>=264&&hCounter<294&&vCounter>=79&&vCounter<109)
      colour<=above[71:60];
    else if(hCounter>=196&&hCounter<226&&vCounter>=113&&vCounter<143)
      colour<=above[83:72];
    else if(hCounter>=230&&hCounter<260&&vCounter>=113&&vCounter<143)
      colour<=above[95:84];
    else if(hCounter>=264&&hCounter<294&&vCounter>=113&&vCounter<143)
      colour<=above[107:96]; 

    else
      colour<=C_WHITE;
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

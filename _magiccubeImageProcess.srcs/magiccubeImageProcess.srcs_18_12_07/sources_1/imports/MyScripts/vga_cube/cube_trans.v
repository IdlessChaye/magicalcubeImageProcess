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


module cube_trans(
input en,
input rst,
input button_in,
input clk,//100M
input clk1Hz,
input [549:0]trans,
input [26:0]front_in,
input [26:0]left_in,
input [26:0]right_in,
input [26:0]back_in,
input [26:0]above_in,
input [26:0]below_in,
output [26:0]front,
output [26:0]left,
output [26:0]right,
output [26:0]back,
output [26:0]above,
output [26:0]below,
output reg[4:0]state
    );
wire db;
reg [7:0]num;
reg [549:0] trans_now;
reg [26:0]front_now;
reg [26:0]left_now;
reg [26:0]right_now;
reg [26:0]back_now;
reg [26:0]above_now;
reg [26:0]below_now;
initial
begin
state = 5'b11111;
num = 0;
trans_now<=0;
end
button(.clk(clk),.sw(button_in),.db(db));
always@(posedge clk1Hz)
begin
if(en==0)
begin
num<=0;
trans_now<=~0;
end
else if((rst==1||(db==1&&rst==0))&&num<=110)
begin
  if(num==0)
  begin
    trans_now<=~0 & trans;
    num=num+1;
  end
  else if(num==111)
  begin
    trans_now<=trans_now;
    num<=111;
  end
  else
  begin
    trans_now<={5'b11111,trans_now[549:5]};
    num<=num+1;
  end
end
end
always@(posedge clk1Hz)
begin
if(en==0)
begin
  front_now<=front_in;
  left_now<=left_in;
  right_now<=right_in;
  back_now<=back_in;
  above_now<=above_in;
  below_now<=below_in;
  state<=5'b11111;
end
else if(num==0)
 begin
    front_now<=front_in;
    left_now<=left_in;
    right_now<=right_in;
    back_now<=back_in;
    above_now<=above_in;
    below_now<=below_in;
end
else if((rst==1||(db==1&&rst==0))&&num<=110)
begin
    case(trans_now[4:0])
    5'b11111:
    begin
    front_now<=front_now;
    left_now<=left_now;
    right_now<=right_now;
    back_now<=back_now;
    above_now<=above_now;
    below_now<=below_now;
    state<=5'b11111;
    end
    5'b00000://U
    begin
      front_now[8:0]<=right_now[8:0];
      right_now[8:0]<=back_now[8:0];
      back_now[8:0]<=left_now[8:0];
      left_now[8:0]<=front_now[8:0];
      above_now[2:0]<=above_now[20:18];
      above_now[5:3]<=above_now[11:9];
      above_now[8:6]<=above_now[2:0];
      above_now[11:9]<=above_now[23:21];
      above_now[14:12]<=above_now[14:12];
      above_now[17:15]<=above_now[5:3];
      above_now[20:18]<=above_now[26:24];
      above_now[23:21]<=above_now[17:15];
      above_now[26:24]<=above_now[8:6];
      front_now[26:9]<=front_now[26:9];
      right_now[26:9]<=right_now[26:9];
      left_now[26:9]<=left_now[26:9];
      back_now[26:9]<=back_now[26:9];
      below_now[26:0]<=below_now[26:0];
      state<=5'b00000;
    end
    5'b00001://U1
    begin
      front_now[8:0]<=left_now[8:0];
      right_now[8:0]<=front_now[8:0];
      back_now[8:0]<=right_now[8:0];
      left_now[8:0]<=back_now[8:0];
      above_now[2:0]<=above_now[8:6];
      above_now[5:3]<=above_now[17:15];
      above_now[8:6]<=above_now[26:24];
      above_now[11:9]<=above_now[5:3];
      above_now[14:12]<=above_now[14:12];
      above_now[17:15]<=above_now[23:21];
      above_now[20:18]<=above_now[2:0];
      above_now[23:21]<=above_now[11:9];
      above_now[26:24]<=above_now[20:18];
      front_now[26:9]<=front_now[26:9];
      right_now[26:9]<=right_now[26:9];
      left_now[26:9]<=left_now[26:9];
      back_now[26:9]<=back_now[26:9];
      below_now[26:0]<=below_now[26:0];
      state<=5'b00001;
    end
    5'b00010://U2
    begin
       front_now[8:0]<=back_now[8:0];
       right_now[8:0]<=left_now[8:0];
       back_now[8:0]<=front_now[8:0];
       left_now[8:0]<=right_now[8:0];
       above_now[2:0]<=above_now[26:24];
       above_now[5:3]<=above_now[23:21];
       above_now[8:6]<=above_now[20:18];
       above_now[11:9]<=above_now[17:15];
       above_now[14:12]<=above_now[14:12];
       above_now[17:15]<=above_now[11:9];
       above_now[20:18]<=above_now[8:6];
       above_now[23:21]<=above_now[5:3];
       above_now[26:24]<=above_now[2:0];
       front_now[26:9]<=front_now[26:9];
       right_now[26:9]<=right_now[26:9];
       left_now[26:9]<=left_now[26:9];
       back_now[26:9]<=back_now[26:9];
       below_now[26:0]<=below_now[26:0];
       state<=5'b00010;
    end
    5'b00100://D
    begin
    front_now[26:18]<=left_now[26:18];
    right_now[26:18]<=front_now[26:18];
    back_now[26:18]<=right_now[26:18];
    left_now[26:18]<=back_now[26:18];
    below_now[2:0]<=below_now[20:18];
    below_now[5:3]<=below_now[11:9];
    below_now[8:6]<=below_now[2:0];
    below_now[11:9]<=below_now[23:21];
    below_now[14:12]<=below_now[14:12];
    below_now[17:15]<=below_now[5:3];
    below_now[20:18]<=below_now[26:24];
    below_now[23:21]<=below_now[17:15];
    below_now[26:24]<=below_now[8:6];
    
    front_now[17:0]<=front_now[17:0];
    right_now[17:0]<=right_now[17:0];
    left_now[17:0]<=left_now[17:0];
    back_now[17:0]<=back_now[17:0];
    above_now[26:0]<=above_now[26:0];
    state<=5'b00011;     
    end
    5'b00101://D1
    begin
    front_now[26:18]<=right_now[26:18];
    right_now[26:18]<=back_now[26:18];
    back_now[26:18]<=left_now[26:18];
    left_now[26:18]<=front_now[26:18];
    below_now[2:0]<=below_now[8:6];
    below_now[5:3]<=below_now[17:15];
    below_now[8:6]<=below_now[26:24];
    below_now[11:9]<=below_now[5:3];
    below_now[14:12]<=below_now[14:12];
    below_now[17:15]<=below_now[23:21];
    below_now[20:18]<=below_now[2:0];
    below_now[23:21]<=below_now[11:9];
    below_now[26:24]<=below_now[20:18];
    front_now[17:0]<=front_now[17:0];
    right_now[17:0]<=right_now[17:0];
    left_now[17:0]<=left_now[17:0];
    back_now[17:0]<=back_now[17:0];
    above_now[26:0]<=above_now[26:0];
    state<=5'b00100;
    end
    5'b00110://D2
    begin
    front_now[26:18]<=back_now[26:18];
    right_now[26:18]<=left_now[26:18];
    back_now[26:18]<=front_now[26:18];
    left_now[26:18]<=right_now[26:18];  
    below_now[2:0]<=below_now[26:24];
    below_now[5:3]<=below_now[23:21];
    below_now[8:6]<=below_now[20:18];
    below_now[11:9]<=below_now[17:15];
    below_now[14:12]<=below_now[14:12];
    below_now[17:15]<=below_now[11:9];
    below_now[20:18]<=below_now[8:6];
    below_now[23:21]<=below_now[5:3];
    below_now[26:24]<=below_now[2:0];
    front_now[17:0]<=front_now[17:0];
    right_now[17:0]<=right_now[17:0];
    left_now[17:0]<=left_now[17:0];
    back_now[17:0]<=back_now[17:0];
    above_now[26:0]<=above_now[26:0];
    state<=5'b00101;
    end
    5'b01000://F
    begin
    above_now[20:18]<=left_now[26:24];
    above_now[23:21]<=left_now[17:15];
    above_now[26:24]<=left_now[8:6];
    right_now[2:0]<=above_now[20:18];
    right_now[11:9]<=above_now[23:21];
    right_now[20:18]<=above_now[26:24];
    below_now[2:0]<=right_now[20:18];
    below_now[5:3]<=right_now[11:9];
    below_now[8:6]<=right_now[2:0];
    left_now[8:6]<=below_now[2:0];
    left_now[17:15]<=below_now[5:3];
    left_now[26:24]<=below_now[8:6];
    
    front_now[2:0]<=front_now[20:18];
    front_now[5:3]<=front_now[11:9];
    front_now[8:6]<=front_now[2:0];
    front_now[11:9]<=front_now[23:21];
    front_now[14:12]<=front_now[14:12];
    front_now[17:15]<=front_now[5:3];
    front_now[20:18]<=front_now[26:24];
    front_now[23:21]<=front_now[17:15];
    front_now[26:24]<=front_now[8:6];
    state<=5'b00110;
    end
    5'b01001://F1
    begin
    above_now[20:18]<=right_now[2:0];
    above_now[23:21]<=right_now[11:9];
    above_now[26:24]<=right_now[20:18];
    right_now[2:0]<=below_now[8:6];
    right_now[11:9]<=below_now[5:3];
    right_now[20:18]<=below_now[2:0];
    below_now[2:0]<=left_now[8:6];
    below_now[5:3]<=left_now[17:15];
    below_now[8:6]<=left_now[26:24];
    left_now[8:6]<=above_now[26:24];
    left_now[17:15]<=above_now[23:21];
    left_now[26:24]<=above_now[20:18];
    
    front_now[2:0]<=front_now[8:6];
    front_now[5:3]<=front_now[17:15];
    front_now[8:6]<=front_now[26:24];
    front_now[11:9]<=front_now[5:3];
    front_now[14:12]<=front_now[14:12];
    front_now[17:15]<=front_now[23:21];
    front_now[20:18]<=front_now[2:0];
    front_now[23:21]<=front_now[11:9];
    front_now[26:24]<=front_now[20:18];
    state<=5'b00111;
    end
    5'b01010://F2
    begin
    above_now[20:18]<=below_now[8:6];
    above_now[23:21]<=below_now[5:3];
    above_now[26:24]<=below_now[2:0];
    right_now[2:0]<=left_now[26:24];
    right_now[11:9]<=left_now[17:15];
    right_now[20:18]<=left_now[8:6];
    below_now[2:0]<=above_now[26:24];
    below_now[5:3]<=above_now[23:21];
    below_now[8:6]<=above_now[20:18];
    left_now[8:6]<=right_now[20:18];
    left_now[17:15]<=right_now[11:9];
    left_now[26:24]<=right_now[2:0];
    front_now[2:0]<=front_now[26:24];
    front_now[5:3]<=front_now[23:21];
    front_now[8:6]<=front_now[20:18];
    front_now[11:9]<=front_now[17:15];
    front_now[14:12]<=front_now[14:12];
    front_now[17:15]<=front_now[11:9];
    front_now[20:18]<=front_now[8:6];
    front_now[23:21]<=front_now[5:3];
    front_now[26:24]<=front_now[2:0];
    state<=5'b01000;
    end
    5'b01100://B
    begin
    above_now[2:0]<=right_now[8:6];
    above_now[5:3]<=right_now[17:15];
    above_now[8:6]<=right_now[26:24];
    right_now[8:6]<=below_now[26:24];
    right_now[17:15]<=below_now[23:21];
    right_now[26:24]<=below_now[20:18];
    below_now[20:18]<=left_now[2:0];
    below_now[23:21]<=left_now[11:9];
    below_now[26:24]<=left_now[20:18];
    left_now[2:0]<=above_now[8:6];
    left_now[11:9]<=above_now[5:3];
    left_now[20:18]<=above_now[2:0];
    back_now[2:0]<=back_now[20:18];
    back_now[5:3]<=back_now[11:9];
    back_now[8:6]<=back_now[2:0];
    back_now[11:9]<=back_now[23:21];
    back_now[14:12]<=back_now[14:12];
    back_now[17:15]<=back_now[5:3];
    back_now[20:18]<=back_now[26:24];
    back_now[23:21]<=back_now[17:15];
    back_now[26:24]<=back_now[8:6];
    state<=5'b01001;
    end
    5'b01101://B1
    begin
    above_now[2:0]<=left_now[20:18];
    above_now[5:3]<=left_now[11:9];
    above_now[8:6]<=left_now[2:0];
    right_now[8:6]<=above_now[2:0];
    right_now[17:15]<=above_now[5:3];
    right_now[26:24]<=above_now[8:6];
    below_now[20:18]<=right_now[26:24];
    below_now[23:21]<=right_now[17:15];
    below_now[26:24]<=right_now[8:6];
    left_now[2:0]<=below_now[20:18];
    left_now[11:9]<=below_now[23:21];
    left_now[20:18]<=below_now[26:24];
    
    back_now[2:0]<=back_now[8:6];
    back_now[5:3]<=back_now[17:15];
    back_now[8:6]<=back_now[26:24];
    back_now[11:9]<=back_now[5:3];
    back_now[14:12]<=back_now[14:12];
    back_now[17:15]<=back_now[23:21];
    back_now[20:18]<=back_now[2:0];
    back_now[23:21]<=back_now[11:9];
    back_now[26:24]<=back_now[20:18];
    state<=5'b01010;
    end
    5'b01110://B2
    begin
    above_now[2:0]<=below_now[26:24];
    above_now[5:3]<=below_now[23:21];
    above_now[8:6]<=below_now[20:18];
    right_now[8:6]<=left_now[20:18];
    right_now[17:15]<=left_now[11:9];
    right_now[26:24]<=left_now[2:0];
    below_now[20:18]<=above_now[8:6];
    below_now[23:21]<=above_now[5:3];
    below_now[26:24]<=above_now[2:0];
    left_now[2:0]<=right_now[26:24];
    left_now[11:9]<=right_now[17:15];
    left_now[20:18]<=right_now[8:6];
    
    back_now[2:0]<=back_now[26:24];
    back_now[5:3]<=back_now[23:21];
    back_now[8:6]<=back_now[20:18];
    back_now[11:9]<=back_now[17:15];
    back_now[14:12]<=back_now[14:12];
    back_now[17:15]<=back_now[11:9];
    back_now[20:18]<=back_now[8:6];
    back_now[23:21]<=back_now[5:3];
    back_now[26:24]<=back_now[2:0];
    state<=5'b01011;
    end
    5'b10000://R
    begin
    above_now[8:6]<=front_now[8:6];
    above_now[17:15]<=front_now[17:15];
    above_now[26:24]<=front_now[26:24];
    front_now[8:6]<=below_now[8:6];
    front_now[17:15]<=below_now[17:15];
    front_now[26:24]<=below_now[26:24];
    below_now[8:6]<=back_now[20:18];
    below_now[17:15]<=back_now[11:9];
    below_now[26:24]<=back_now[2:0];
    back_now[2:0]<=above_now[26:24];
    back_now[11:9]<=above_now[17:15];
    back_now[20:18]<=above_now[8:6];
    
    right_now[2:0]<=right_now[20:18];
    right_now[5:3]<=right_now[11:9];
    right_now[8:6]<=right_now[2:0];
    right_now[11:9]<=right_now[23:21];
    right_now[14:12]<=right_now[14:12];
    right_now[17:15]<=right_now[5:3];
    right_now[20:18]<=right_now[26:24];
    right_now[23:21]<=right_now[17:15];
    right_now[26:24]<=right_now[8:6];
    state<=5'b01100;
    end
    5'b10001://R1
    begin
    above_now[8:6]<=back_now[20:18];
    above_now[17:15]<=back_now[11:9];
    above_now[26:24]<=back_now[2:0];
    front_now[8:6]<=above_now[8:6];
    front_now[17:15]<=above_now[17:15];
    front_now[26:24]<=above_now[26:24];
    below_now[8:6]<=front_now[8:6];
    below_now[17:15]<=front_now[17:15];
    below_now[26:24]<=front_now[26:24];
    back_now[2:0]<=below_now[26:24];
    back_now[11:9]<=below_now[17:15];
    back_now[20:18]<=below_now[8:6];
    
    right_now[2:0]<=right_now[8:6];
    right_now[5:3]<=right_now[17:15];
    right_now[8:6]<=right_now[26:24];
    right_now[11:9]<=right_now[5:3];
    right_now[14:12]<=right_now[14:12];
    right_now[17:15]<=right_now[23:21];
    right_now[20:18]<=right_now[2:0];
    right_now[23:21]<=right_now[11:9];
    right_now[26:24]<=right_now[20:18];
    state<=5'b01101;
    end
    5'b10010://R2
    begin
    above_now[8:6]<=below_now[8:6];
    above_now[17:15]<=below_now[17:15];
    above_now[26:24]<=below_now[26:24];
    front_now[8:6]<=back_now[20:18];
    front_now[17:15]<=back_now[11:9];
    front_now[26:24]<=back_now[2:0];
    below_now[8:6]<=above_now[8:6];
    below_now[17:15]<=above_now[17:15];
    below_now[26:24]<=above_now[26:24];
    back_now[2:0]<=front_now[26:24];
    back_now[11:9]<=front_now[17:15];
    back_now[20:18]<=front_now[8:6];
    
    right_now[2:0]<=right_now[26:24];
    right_now[5:3]<=right_now[23:21];
    right_now[8:6]<=right_now[20:18];
    right_now[11:9]<=right_now[17:15];
    right_now[14:12]<=right_now[14:12];
    right_now[17:15]<=right_now[11:9];
    right_now[20:18]<=right_now[8:6];
    right_now[23:21]<=right_now[5:3];
    right_now[26:24]<=right_now[2:0];
    state<=5'b01110;
    end
    5'b10100://L
    begin
    above_now[2:0]<=back_now[26:24];
    above_now[11:9]<=back_now[17:15];
    above_now[20:18]<=back_now[8:6];
    front_now[2:0]<=above_now[2:0];
    front_now[11:9]<=above_now[11:9];
    front_now[20:18]<=above_now[20:18];
    below_now[2:0]<=front_now[2:0];
    below_now[11:9]<=front_now[11:9];
    below_now[20:18]<=front_now[20:18];
    back_now[8:6]<=below_now[20:18];
    back_now[17:15]<=below_now[11:9];
    back_now[26:24]<=below_now[2:0];
    
    left_now[2:0]<=left_now[20:18];
    left_now[5:3]<=left_now[11:9];
    left_now[8:6]<=left_now[2:0];
    left_now[11:9]<=left_now[23:21];
    left_now[14:12]<=left_now[14:12];
    left_now[17:15]<=left_now[5:3];
    left_now[20:18]<=left_now[26:24];
    left_now[23:21]<=left_now[17:15];
    left_now[26:24]<=left_now[8:6];
    state<=5'b01111;
    end
    5'b10101://L1
    begin
    above_now[2:0]<=front_now[2:0];
    above_now[11:9]<=front_now[11:9];
    above_now[20:18]<=front_now[20:18];
    front_now[2:0]<=below_now[2:0];
    front_now[11:9]<=below_now[11:9];
    front_now[20:18]<=below_now[20:18];
    below_now[2:0]<=back_now[26:24];
    below_now[11:9]<=back_now[17:15];
    below_now[20:18]<=back_now[8:6];
    back_now[8:6]<=above_now[20:18];
    back_now[17:15]<=above_now[11:9];
    back_now[26:24]<=above_now[2:0];
    
    left_now[2:0]<=left_now[8:6];
    left_now[5:3]<=left_now[17:15];
    left_now[8:6]<=left_now[26:24];
    left_now[11:9]<=left_now[5:3];
    left_now[14:12]<=left_now[14:12];
    left_now[17:15]<=left_now[23:21];
    left_now[20:18]<=left_now[2:0];
    left_now[23:21]<=left_now[11:9];
    left_now[26:24]<=left_now[20:18];
    state<=5'b10000;
    end
    5'b10110://L2
    begin
    above_now[2:0]<=below_now[2:0];
    above_now[11:9]<=below_now[11:9];
    above_now[20:18]<=below_now[20:18];
    front_now[2:0]<=back_now[26:24];
    front_now[11:9]<=back_now[17:15];
    front_now[20:18]<=back_now[8:6];
    below_now[2:0]<=above_now[2:0];
    below_now[11:9]<=above_now[11:9];
    below_now[20:18]<=above_now[20:18];
    back_now[8:6]<=front_now[20:18];
    back_now[17:15]<=front_now[11:9];
    back_now[26:24]<=front_now[2:0];
    
    left_now[2:0]<=left_now[26:24];
    left_now[5:3]<=left_now[23:21];
    left_now[8:6]<=left_now[20:18];
    left_now[11:9]<=left_now[17:15];
    left_now[14:12]<=left_now[14:12];
    left_now[17:15]<=left_now[11:9];
    left_now[20:18]<=left_now[8:6];
    left_now[23:21]<=left_now[5:3];
    left_now[26:24]<=left_now[2:0];
    state<=5'b10001;
    end
    endcase
end
else
begin
  state=5'b11111;
end
end
assign front=front_now;
assign left=left_now;
assign right=right_now;
assign back=back_now;
assign above=above_now;
assign below=below_now;
endmodule

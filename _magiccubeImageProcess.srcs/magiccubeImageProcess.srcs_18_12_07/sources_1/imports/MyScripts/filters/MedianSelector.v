 /* this program can get the median data for median filter module on github
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
module MedianSeletor #(parameter N = 8) (
input            clk,
input            rst,

input      [N-1:0] Data1,
input      [N-1:0] Data2,
input      [N-1:0] Data3,

input      [N-1:0] Data4,
input      [N-1:0] Data5,
input      [N-1:0] Data6,

input      [N-1:0] Data7,
input      [N-1:0] Data8,
input      [N-1:0] Data9,

output reg [N-1:0] Median  //3�?3列全体中�?
);

localparam M = N - 1;

reg [M:0]Max1;
reg [M:0]Max2;
reg [M:0]Max3;


reg [M:0]Med1;
reg [M:0]Med2;
reg [M:0]Med3;


reg [M:0]Min1;
reg [M:0]Min2;
reg [M:0]Min3;


reg [M:0]Min_of_Max;
reg [M:0]Med_of_Med;
reg [M:0]Max_of_Min;


always@(negedge rst or posedge clk)
    if(rst) begin
        Max1 <= 0;
        Max2 <= 0;
        Max3 <= 0;

        Med1 <= 0;
        Med2 <= 0;
        Med3 <= 0;

        Min1 <= 0;
        Min2 <= 0;
        Min3 <= 0;

        Min_of_Max <= 0;
        Med_of_Med <= 0;
        Max_of_Min <= 0;

        Median <= 0;
    end else begin
        if(Data1 >= Data2 && Data1 >= Data3) //找到各行�?大�??//第一�?
            Max1 <= Data1;
        else if(Data2 >= Data1 && Data2 >= Data3)
            Max1 <= Data2;
        else if(Data3 >= Data1 && Data3 >= Data2)
            Max1 <= Data3;
        //第二�?
        if(Data4 >= Data5 && Data4 >= Data6)
            Max2 <= Data4;
        else if(Data5 >= Data4 && Data5 >= Data6)
            Max2 <= Data5;
        else if(Data6 >= Data4 && Data6 >= Data5)
            Max2 <= Data6;
        //第三�?
        if(Data7 >= Data8 && Data7 >= Data9)
            Max3 <= Data7;
        else if(Data8 >= Data7 && Data8 >= Data9)
            Max3 <= Data8;
        else if(Data9 >= Data7 && Data9 >= Data8)
            Max3 <= Data9;

    //找到各行中�??
    //第一�?
        if((Data1 >= Data2 && Data1 <= Data3) || (Data1 >= Data3 && Data1 <= Data2))
            Med1 <= Data1;
        else if((Data2 >= Data1 && Data2 <= Data3) || (Data2 >= Data3 && Data2 <= Data1))
            Med1 <= Data2;
        else if((Data3 >= Data1 && Data3 <= Data2) || (Data3 >= Data2 && Data3 <= Data1))
            Med1 <= Data3;
        //第二�?
        if((Data4 >= Data5 && Data4 <= Data6) || (Data4 >= Data6 && Data4 <= Data5))
            Med2 <= Data4;
        else if((Data5 >= Data4 && Data5 <= Data6) || (Data5 >= Data6 && Data5 <= Data4))
            Med2 <= Data5;
        else if((Data6 >= Data4 && Data6 <= Data5) || (Data6 >= Data5 && Data6 <= Data4))
            Med2 <= Data6;
        //第三�?
        if((Data7 >= Data8 && Data7 <= Data9) || (Data7 >= Data9 && Data7 <= Data8))
            Med3 <= Data7;
        else if((Data8 >= Data7 && Data8 <= Data9) || (Data8 >= Data9 && Data8 <= Data7))
            Med3 <= Data8;
        else if((Data9 >= Data7 && Data9 <= Data8) || (Data9 >= Data8 && Data9 <= Data7))
            Med3 <= Data9;

        //找到各行�?小�??
        //第一�?
        if(Data1 <= Data2 && Data1 <= Data3)
            Min1 <= Data1;
        else if(Data2 <= Data1 && Data2 <= Data3)
            Min1 <= Data2;
        else if(Data3 <= Data1 && Data3 <= Data2)
            Min1 <= Data3;
        //第二�?
        if(Data4 <= Data5 && Data4 <= Data6)
            Min2 <= Data4;
        else if(Data5 <= Data4 && Data5 <= Data6)
            Min2 <= Data5;
        else if(Data6 <= Data4 && Data6 <= Data5)
            Min2 <= Data6;
        //第三�?
        if(Data7 <= Data8 && Data7 <= Data9)
            Min3 <= Data7;
        else if(Data8 <= Data7 && Data8 <= Data9)
            Min3 <= Data8;
        else if(Data9 <= Data7 && Data9 <= Data8)
            Min3 <= Data9;


        //找到�?大�?�列的最小�??
        if(Max1 <= Max2 && Max1 <= Max3)
            Min_of_Max <= Max1;
        else if(Max2 <= Max1 && Max2 <= Max3)
            Min_of_Max <= Max2;
        else if(Max3 <= Max1 && Max3 <= Max2)
            Min_of_Max <= Max3;

        //找到中�?�列的中�?
        if((Med1 >= Med2 && Med1 <= Med3) || (Med1 >= Med3 && Med1 <= Med2))
            Med_of_Med <= Med1;
        else if((Med2 >= Med1 && Med2 <= Med3) || (Med2 >= Med3 && Med2 <= Med1))
            Med_of_Med <= Med2;
        else if((Med3 >= Med1 && Med3 <= Med2) || (Med3 >= Med2 && Med3 <= Med1))
            Med_of_Med <= Med3;

        //找到�?小�?�列的最大�??
        if(Min1 >= Min2 && Min1 >= Min3)
            Max_of_Min <= Min1;
        else if(Min2 >= Min1 && Min2 >= Min3)
            Max_of_Min <= Min2;
        else if(Min3 >= Min1 && Min3 >= Min2)
            Max_of_Min <= Min3;

        //找到三行三列的全体中�?
        if((Min_of_Max >= Med_of_Med && Min_of_Max <= Max_of_Min) || (Min_of_Max >= Max_of_Min && Min_of_Max <= Med_of_Med))
            Median <= Min_of_Max;
        else if((Med_of_Med >= Min_of_Max && Med_of_Med <= Max_of_Min) || (Med_of_Med >= Max_of_Min && Med_of_Med <= Min_of_Max))
            Median <= Med_of_Med;
        else if((Max_of_Min >= Min_of_Max && Max_of_Min <= Med_of_Med) || (Max_of_Min >= Med_of_Med && Max_of_Min <= Min_of_Max))
            Median <= Max_of_Min;
    end

endmodule

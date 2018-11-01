 /* this program is to transfer rgb888 into hsv988
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

module rgb2hsv_clk (
    input pclk,
    input rst, // high_power work

    input enable, // high_power work
    input[23:0] RGB24,
    output[24:0] HSV25,

    output reg hsv_done
);

wire[7:0] Red,Green,Blue;
assign Red = RGB24[23:16];
assign Green = RGB24[15:8];
assign Blue = RGB24[7:0];
reg[7:0] R_reg,G_reg,B_reg;

reg[8:0] Hue;
reg[7:0] Saturation,Value;
assign HSV25[24:16] = Hue;
assign HSV25[15:8] = Saturation;
assign HSV25[7:0] = Value;

reg[7:0] max,min;

reg[14:0] h_dividend;
reg[7:0] h_divisor;
wire[14:0] h_quotient;
reg[8:0] h_add;
reg[16:0] s_dividend;
reg[7:0] s_divisor;
wire[16:0] s_quotient;
reg[7:0] v;
reg sign_flag;

reg enable_div = 0;
wire clac_done;
wire[31:0] yshang_h,yshang_s;

assign h_quotient = yshang_h[14:0];
assign s_quotient = yshang_s[16:0];



localparam s_idle           = 3'b000;
localparam s_init           = 3'b001;
localparam s_div_work       = 3'b011;
localparam s_ready          = 3'b010;
localparam s_done           = 3'b110;
reg [2:0] status = s_idle;

always@(posedge pclk) begin
    if(rst) begin
        R_reg <= 0;
        G_reg <= 0;
        B_reg <= 0;
        Hue <= 0;
        Saturation <= 0;
        Value <= 0;
        hsv_done <= 0;

        status <= s_idle;
    end else begin
        case(status) 
            s_idle: begin
                if(enable) begin
                    R_reg <= Red;
                    G_reg <= Green;
                    B_reg <= Blue;

                    if(Red >= Green) begin
                        if(Red >= Blue) begin
                            max <= Red;
                        end else begin
                            max <= Blue;
                        end
                    end else begin
                        if(Green >= Blue) begin
                            max <= Green;
                        end else begin
                            max <= Blue;
                        end
                    end
                    if(Red <= Green) begin
                        if(Red <= Blue) begin
                            min <= Red;
                        end else begin
                            min <= Blue;
                        end
                    end else begin
                        if(Green <= Blue) begin
                            min <= Green;
                        end else begin
                            min <= Blue;
                        end
                    end                    

                    status <= s_init;
                end else begin
                    R_reg <= 0;
                    G_reg <= 0;
                    B_reg <= 0;
                    hsv_done <= 0;

                    status <= s_idle;                    
                end
            end
            s_init: begin
                if(max == min) begin
                    sign_flag <= 0;
                    h_dividend <= 0;
                    h_divisor <= 1;
                    h_add <= 0;
                    s_dividend <= 0;
                    s_divisor <= 1;
                    v <= max;
                end else if(max == R_reg && G_reg >= B_reg) begin
                    sign_flag <= 0;
                    h_dividend <= 60 * (G_reg - B_reg);
                    h_divisor <= max - min;
                    h_add <= 0;
                    s_dividend <= 255 * (max - min);
                    s_divisor <= max;
                    v <= max;
                end else if(max == R_reg && G_reg < B_reg) begin
                    sign_flag <= 1;
                    h_dividend <= 60 * (B_reg - G_reg);
                    h_divisor <= max - min;
                    h_add <= 360;
                    s_dividend <= 255 * (max - min);
                    s_divisor <= max;
                    v <= max;        
                end else if(max == G_reg) begin
                    if(B_reg >= R_reg) begin
                        sign_flag <= 0;
                        h_dividend <= 60 * (B_reg - R_reg);
                        h_divisor <= max - min;
                        h_add <= 120;
                        s_dividend <= 255 * (max - min);
                        s_divisor <= max;
                        v <= max;          
                    end else begin
                        sign_flag <= 1;
                        h_dividend <= 60 * (R_reg - B_reg);
                        h_divisor <= max - min;
                        h_add <= 120;
                        s_dividend <= 255 * (max - min);
                        s_divisor <= max;
                        v <= max; 
                    end
                end else if(max == B_reg) begin
                    if(R_reg >= G_reg) begin
                        sign_flag <= 0;
                        h_dividend <= 60 * (R_reg - G_reg);
                        h_divisor <= max - min;
                        h_add <= 240;
                        s_dividend <= 255 * (max - min);
                        s_divisor <= max;
                        v <= max;       
                    end else begin
                        sign_flag <= 1;
                        h_dividend <= 60 * (G_reg - R_reg);
                        h_divisor <= max - min;
                        h_add <= 240;
                        s_dividend <= 255 * (max - min);
                        s_divisor <= max;
                        v <= max; 
                    end
                end

                enable_div <= 1;

                status <= s_div_work;
            end
            s_div_work: begin
                enable_div <= 0;
                if(clac_done) begin
                    status <= s_done;
                end else begin
                    status <= s_div_work;
                end
            end
            s_done: begin
                if(sign_flag == 0) 
                    Hue <= (h_quotient + h_add);
                else
                    Hue <= (h_add - h_quotient); 
                Saturation <= s_quotient;
                Value <= v;
                hsv_done <= 1'b1;   

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

// this module needs 34 clks, and all needs 
div_rill_clk div_rill_clk_h (
    .clk(pclk),
    .rst(rst),
    .enable(enable_div),
    .done(clac_done),
    .a({17'b0,h_dividend}),
    .b({24'b0,h_divisor}),
    .yshang(yshang_h),
    .yyushu()
);

div_rill_clk div_rill_clk_s (
    .clk(pclk),
    .rst(rst),
    .enable(enable_div),
    .done(),
    .a({15'b0,s_dividend}),
    .b({24'b0,s_divisor}),
    .yshang(yshang_s),
    .yyushu()
);

endmodule
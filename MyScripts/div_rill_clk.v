/*
* module:div_rill_clk
* file name:div_rill_clk.v
* syn:not yet
* author:rill
* date:2014-04-10
* modified by chaye
* data:2018-10-19
*/

module div_rill_clk (
    input clk,
    input rst, // high_power work

    input enable, // high_power work
    input [31:0] a, 
    input [31:0] b,

    output reg [31:0] yshang,
    output reg [31:0] yyushu,

    output reg done
);

reg[31:0] tempa;
reg[31:0] tempb;
reg[63:0] temp_a;
reg[63:0] temp_b;

reg [31:0] i;


parameter s_idle =  4'b0000;
parameter s_init =  4'b0001;
parameter s_calc1 = 4'b0011;
parameter s_calc2 = 4'b0010;
parameter s_ready = 4'b0110;
parameter s_done =  4'b0111;
reg [3:0] status = s_idle;

always @(posedge clk) begin
    if(rst) begin
        i <= 32'h0;
        tempa <= 32'h1;
        tempb <= 32'h1;
        yshang <= 32'h1;
        yyushu <= 32'h1;
        done <= 1'b0;
        status <= s_idle;
    end else begin
        case(status)
            s_idle: begin
                if(enable) begin
                    tempa <= a;
                    tempb <= b;

                    status <= s_init;
                end else begin
                    i <= 32'h0;
                    tempa <= 32'h1;
                    tempb <= 32'h1;
                    done <= 1'b0;
                    
                    status <= s_idle;
                end
            end
            s_init: begin
                temp_a = {32'h00000000,tempa};
                temp_b = {tempb,32'h00000000};
                
                status <= s_calc1;
            end
            s_calc1: begin
                if(i < 32) begin
                    temp_a = {temp_a[62:0],1'b0};
                    
                    status <= s_calc2;
                end else begin
                    status <= s_done;
                end
            end
            s_calc2: begin
                if(temp_a[63:32] >= tempb) begin
                    temp_a = temp_a - temp_b + 1'b1;
                end else begin
                    temp_a = temp_a;
                end
                i <= i + 1'b1;  

                status <= s_calc1;
            end
            s_done: begin
                yshang <= temp_a[31:0];
                yyushu <= temp_a[63:32];
                done <= 1'b1;
                
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

endmodule
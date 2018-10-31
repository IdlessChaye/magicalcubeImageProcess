module hsv2color_coding (
    input clk,
    input rst,

    input enable,

    input[24:0] hsv25,
    output reg[2:0] color_coding,

    output reg done
);


reg[8:0] Hue;
reg[7:0] Saturation;


/*  
    color1 : 000 white     0   0   255
    color2 : 001 yellow    60  255 255
    color3 : 010 blue      240 255 255
    color4 : 011 green     120 255 255
    color5 : 100 red       0   255 255
    color6 : 101 orange    30  255 255
                 qing      180 255 255
                 pinhong   300 255 255
*/
localparam  color1_coding = 3'b000,
            color2_coding = 3'b001,
            color3_coding = 3'b010,
            color4_coding = 3'b011,
            color5_coding = 3'b100,
            color6_coding = 3'b101;

localparam  //color1_Hue = 0, // because it's white, so ignore this
            color2_Hue = 60,
            color3_Hue = 240,
            color4_Hue = 120,
            color5_Hue = 0,
            color6_Hue = 30;
localparam  color_margin = 15; 
// because min = 30 - 0 = 30, so margin = 30 / 2 = 15



localparam s_idle    = 3'b000;
localparam s_init    = 3'b001;
localparam s_trans   = 3'b011;
localparam s_done    = 3'b010;
localparam s_ready   = 3'b110;
reg[2:0] status = s_idle;

always@(posedge clk) begin
    if(rst) begin
        done <= 0;
        color_coding <= 3'b111;
        Hue <= 0;
        Saturation <= 0;

        status <= s_idle;
    end else begin
        case(status) 
            s_idle: begin
                done <= 0;
                Hue <= 0;
                Saturation <= 0;

                if(enable) begin
                    status <= s_init;
                end else begin
                    status <= s_idle;
                end
            end
            s_init: begin
                Hue <= hsv25[24:16];
                Saturation <= hsv25[15:8];

                status <= s_trans;
            end
            s_trans: begin
                if(Saturation <= 2*color_margin) begin
                    color_coding <= color1_coding;
                end else if(Hue>color2_Hue-color_margin && Hue<color2_Hue+color_margin) begin
                    color_coding <= color2_coding;
                end else if(Hue>color3_Hue-color_margin && Hue<color3_Hue+color_margin) begin
                    color_coding <= color3_coding;
                end else if(Hue>color4_Hue-color_margin && Hue<color4_Hue+color_margin) begin
                    color_coding <= color4_coding;
                end else if((Hue>360-color_margin&&Hue<=360) || (Hue>=0&&Hue<color_margin)) begin
                    color_coding <= color5_coding;
                end else if(Hue>color6_Hue-color_margin && Hue<color6_Hue+color_margin) begin
                    color_coding <= color6_coding;
                end else begin
                    color_coding <= 3'b111;
                end

                status <= s_done;
            end
            s_done: begin
                done <= 1;

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
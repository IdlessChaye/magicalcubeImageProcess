module magic_side_data_set (
    input clk,
    input rst,

    input enable,

    input[8:0] position_coding,
    input[2:0] color_coding,
    output reg[26:0] oneside_dout,

    output reg done
);





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

        status <= s_idle;
    end else begin
        case(status) 
            s_idle: begin
                done <= 0;

                if(enable) begin
                    status <= s_init;
                end else begin
                    status <= s_idle;
                end
            end
            s_init: begin

                status <= s_trans;
            end
            s_trans: begin

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
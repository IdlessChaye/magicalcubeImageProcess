`timescale 1ns / 1ns
module super_stop_watch_test(
        output[3:0] en0,en1,
        output[7:0] sseg0,sseg1,
        input[31:0] show_data,
        input clk
    );
    
    scan_hex_led_disp scan_hex_led_disp_unit0 (
        .clk(clk),.reset(1'b0),
        .hex3(show_data[15:12]),.hex2(show_data[11:8]),.hex1(show_data[7:4]),.hex0(show_data[3:0]),
        .dp(4'b0100),.en(en0),.sseg(sseg0)
    );
    scan_hex_led_disp scan_hex_led_disp_unit1 (
        .clk(clk),.reset(1'b0),
        .hex3(show_data[31:28]),.hex2(show_data[27:24]),.hex1(show_data[23:20]),.hex0(show_data[19:16]),
        .dp(4'b0101),.en(en1),.sseg(sseg1)
    );
endmodule
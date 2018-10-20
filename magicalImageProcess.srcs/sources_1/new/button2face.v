`timescale 1ns / 1ns
module button2face (
    input[5:0] face_select_signals,
    output[2:0] face_select
    );
    reg[2:0] face_select_reg = 0;
    assign face_select = face_select_reg;
    always @ *
        case(face_select_signals)
            6'b000001: face_select_reg = 3'b001;
            6'b000001: face_select_reg = 3'b010;
            6'b000001: face_select_reg = 3'b011;
            6'b000001: face_select_reg = 3'b100;
            6'b000001: face_select_reg = 3'b101;
            6'b000001: face_select_reg = 3'b110;
            default: face_select_reg = 3'b111;
        endcase
    
`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: Xilinx
// Engineer: Zhenyu Li
// 
// Create Date: 02/07/2015 08:56:03 AM
// Design Name: Interface IP
// Module Name: cam_ov7670_ov7725
// Project Name: cam_ov7670_ov7725
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

module cam_ov7670_ov7725 (
    input pclk,
    input vsync,
    input href,
    input[7:0] d,
    output[9:0] H_cnt,
    output[9:0] V_cnt,
    output[16:0] addr,
    output reg[15:0] dout,
    output reg we,
    output wclk
);

reg [15:0] d_latch = 16'b0;
reg [16:0] address = 17'b0;
reg [16:0] address_next = 17'b0;
reg [1:0] wr_hold = 2'b0;

assign addr = address;
assign wclk = pclk;

reg[9:0]hcnt,vcnt;
 
assign H_cnt = (hcnt/2>=0&&hcnt/2<321)?hcnt/2:0;
assign V_cnt = (vcnt>=0  &&vcnt<240)  ?vcnt  :0;

always@(posedge pclk) begin 
    if(vsync ==1) begin
        address <=17'b0;
        address_next <= 17'b0;
        wr_hold <=  2'b0;
    end
    else begin
        if(address<76800)
            address <= address_next;
        else
            address <= 76800;
            
        we      <=  wr_hold[1];
        wr_hold <= {wr_hold[0],(href&&(!wr_hold[0]))};
        d_latch <= {d_latch[7:0],d};

        if(wr_hold[1]==1) begin
            address_next <=address_next+1;
            dout[15:0] <= {d_latch[15:11],d_latch[10:5],d_latch[4:0]};
        end
    end
end

wire newVsignal;
assign newVsignal = hcnt == 641? 1'b1 : 1'b0;

always@(posedge pclk) begin 
    if(vsync ==1) begin
        vcnt <= 0;
        hcnt <= 0;
    end
    else begin         
        if(newVsignal) begin
            vcnt <= vcnt+1;
            hcnt <= 0;
        end
        else if(href==1) begin
            hcnt <= hcnt+1;
        end
    end
end

endmodule

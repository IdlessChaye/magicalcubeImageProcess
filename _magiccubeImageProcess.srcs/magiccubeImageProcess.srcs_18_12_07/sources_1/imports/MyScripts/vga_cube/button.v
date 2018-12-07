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

module button(
input clk,reset,
input sw,
output reg db
    );
localparam[2:0]
  zero = 3'b000,
  wait1_1 = 3'b001,
  wait1_2 = 3'b010,
  wait1_3 = 3'b011,
  one = 3'b100,
  wait0_1 = 3'b101,
  wait0_2 = 3'b110,
  wait0_3 = 3'b111;
 localparam N = 20;
 reg[N-1:0]q_reg;
 wire[N-1:0]q_next;
 wire m_tick;
 reg[2:0] state_reg,state_next;
//10ms计数发生器
always@(posedge clk)
  q_reg<=q_next;
assign q_next = q_reg + 1;
assign m_tick = (q_reg == 0 )?1'b1:1'b0;
always @(posedge clk,posedge reset)
  if(reset)
    state_reg<=zero;
  else
    state_reg<=state_next;
always @ *
  begin
    state_next = state_reg;
    db = 1'b0;
    case(state_reg)
      zero:
        if(sw)
          state_next = wait1_1;
      wait1_1:
        if(~sw)
          state_next = zero;
        else if (m_tick)
          state_next = wait1_2;
      wait1_2:
        if(~sw)
          state_next = zero;
        else if(m_tick)
        state_next = wait1_3;
      wait1_3:
        if(~sw)
          state_next = zero;    
        else if(m_tick)
          state_next = one;
      one:
        begin
          db = 1'b1;
          if(~sw)
          state_next = wait0_1;
        end
      wait0_1:
        begin
          db = 1'b1;
          if(sw)
            state_next = one;
          else if(m_tick)
            state_next = wait0_2;
        end
      wait0_2:
        begin
          db = 1'b1;
          if(sw)
            state_next = one;
          else if(m_tick)
            state_next = wait0_3;
          end
      wait0_3:
        begin
          db = 1'b1;
          if(sw)
            state_next = one;
          else if(m_tick)
            state_next = zero;
          end
      default: state_next = zero;
     endcase
    end
endmodule

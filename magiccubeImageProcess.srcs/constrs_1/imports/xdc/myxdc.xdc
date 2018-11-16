#    xdc file
#    Copyright (C) 2018 IdlessChaye
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License along
#    with this program; if not, write to the Free Software Foundation, Inc.,
#    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.



set_property PACKAGE_PIN P17 [get_ports clk_in]
set_property IOSTANDARD LVCMOS33 [get_ports clk_in]

set_property PACKAGE_PIN R1 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]


#OV7725 Data signals
set_property PACKAGE_PIN H14 [get_ports {OV7725_D[7]}]
set_property PACKAGE_PIN G14 [get_ports {OV7725_D[6]}]
set_property PACKAGE_PIN F14 [get_ports {OV7725_D[5]}]
set_property PACKAGE_PIN F16 [get_ports {OV7725_D[4]}]
set_property PACKAGE_PIN H16 [get_ports {OV7725_D[3]}]
set_property PACKAGE_PIN G16 [get_ports {OV7725_D[2]}]
set_property PACKAGE_PIN D15 [get_ports {OV7725_D[1]}]
set_property PACKAGE_PIN C15 [get_ports {OV7725_D[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {OV7725_D[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {OV7725_D[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {OV7725_D[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {OV7725_D[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {OV7725_D[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {OV7725_D[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {OV7725_D[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {OV7725_D[0]}]
#OV7725 Control signals
set_property PACKAGE_PIN D17 [get_ports OV7725_XCLK]
set_property PACKAGE_PIN E17 [get_ports OV7725_PCLK]
set_property PACKAGE_PIN J13 [get_ports OV7725_HREF]
set_property PACKAGE_PIN K13 [get_ports OV7725_VSYNC]
set_property PACKAGE_PIN G17 [get_ports OV7725_SIOD]
set_property PACKAGE_PIN H17 [get_ports OV7725_SIOC]
set_property IOSTANDARD LVCMOS33 [get_ports OV7725_HREF]
set_property IOSTANDARD LVCMOS33 [get_ports OV7725_PCLK]
set_property IOSTANDARD LVCMOS33 [get_ports OV7725_SIOC]
set_property IOSTANDARD LVCMOS33 [get_ports OV7725_SIOD]
set_property IOSTANDARD LVCMOS33 [get_ports OV7725_VSYNC]
set_property IOSTANDARD LVCMOS33 [get_ports OV7725_XCLK]
#IIC port"OV7725_SIOD" must be pulled up
set_property PULLUP true [get_ports OV7725_SIOD]
#Whatsthis
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets OV7725_PCLK]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets OV7725_VSYNC]


#super_stop_watch
set_property PACKAGE_PIN D4 [get_ports {sseg0[0]}]
set_property PACKAGE_PIN E3 [get_ports {sseg0[1]}]
set_property PACKAGE_PIN D3 [get_ports {sseg0[2]}]
set_property PACKAGE_PIN F4 [get_ports {sseg0[3]}]
set_property PACKAGE_PIN F3 [get_ports {sseg0[4]}]
set_property PACKAGE_PIN E2 [get_ports {sseg0[5]}]
set_property PACKAGE_PIN D2 [get_ports {sseg0[6]}]
set_property PACKAGE_PIN H2 [get_ports {sseg0[7]}]
set_property PACKAGE_PIN B4 [get_ports {sseg1[0]}]
set_property PACKAGE_PIN A4 [get_ports {sseg1[1]}]
set_property PACKAGE_PIN A3 [get_ports {sseg1[2]}]
set_property PACKAGE_PIN B1 [get_ports {sseg1[3]}]
set_property PACKAGE_PIN A1 [get_ports {sseg1[4]}]
set_property PACKAGE_PIN B3 [get_ports {sseg1[5]}]
set_property PACKAGE_PIN B2 [get_ports {sseg1[6]}]
set_property PACKAGE_PIN D5 [get_ports {sseg1[7]}]
set_property PACKAGE_PIN G6 [get_ports {en0[0]}]
set_property PACKAGE_PIN E1 [get_ports {en0[1]}]
set_property PACKAGE_PIN F1 [get_ports {en0[2]}]
set_property PACKAGE_PIN G1 [get_ports {en0[3]}]
set_property PACKAGE_PIN H1 [get_ports {en1[0]}]
set_property PACKAGE_PIN C1 [get_ports {en1[1]}]
set_property PACKAGE_PIN C2 [get_ports {en1[2]}]
set_property PACKAGE_PIN G2 [get_ports {en1[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {en1[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {en1[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {en1[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {en1[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {en0[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {en0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {en0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {en0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg1[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg1[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg1[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg1[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg1[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg1[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg1[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg1[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg0[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg0[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg0[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg0[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg0[7]}]


#debug single signal
set_property PACKAGE_PIN F6 [get_ports signal0]
set_property IOSTANDARD LVCMOS33 [get_ports signal0]
set_property PACKAGE_PIN G4 [get_ports signal1]
set_property IOSTANDARD LVCMOS33 [get_ports signal1]
set_property PACKAGE_PIN G3 [get_ports signal2]
set_property IOSTANDARD LVCMOS33 [get_ports signal2]
set_property PACKAGE_PIN J4 [get_ports signal3]
set_property IOSTANDARD LVCMOS33 [get_ports signal3]
#done_top
set_property PACKAGE_PIN K2 [get_ports done_top]
set_property IOSTANDARD LVCMOS33 [get_ports done_top]


#side_select_signals
set_property PACKAGE_PIN M4 [get_ports {side_select_signals[0]}]
set_property PACKAGE_PIN R2 [get_ports {side_select_signals[1]}]
set_property PACKAGE_PIN P2 [get_ports {side_select_signals[2]}]
set_property PACKAGE_PIN P3 [get_ports {side_select_signals[3]}]
set_property PACKAGE_PIN P4 [get_ports {side_select_signals[4]}]
set_property PACKAGE_PIN P5 [get_ports {side_select_signals[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {side_select_signals[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {side_select_signals[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {side_select_signals[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {side_select_signals[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {side_select_signals[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {side_select_signals[5]}]


#sram
set_property PACKAGE_PIN V15 [get_ports sram_ce_r]
set_property PACKAGE_PIN R10 [get_ports sram_lb_r]
set_property PACKAGE_PIN T16 [get_ports sram_oe_r]
set_property PACKAGE_PIN R16 [get_ports sram_ub_r]
set_property PACKAGE_PIN V16 [get_ports sram_we_r]
set_property PACKAGE_PIN U17 [get_ports {sram_data[0]}]
set_property PACKAGE_PIN U18 [get_ports {sram_data[1]}]
set_property PACKAGE_PIN U16 [get_ports {sram_data[2]}]
set_property PACKAGE_PIN V17 [get_ports {sram_data[3]}]
set_property PACKAGE_PIN T11 [get_ports {sram_data[4]}]
set_property PACKAGE_PIN U11 [get_ports {sram_data[5]}]
set_property PACKAGE_PIN U12 [get_ports {sram_data[6]}]
set_property PACKAGE_PIN V12 [get_ports {sram_data[7]}]
set_property PACKAGE_PIN V10 [get_ports {sram_data[8]}]
set_property PACKAGE_PIN V11 [get_ports {sram_data[9]}]
set_property PACKAGE_PIN U14 [get_ports {sram_data[10]}]
set_property PACKAGE_PIN V14 [get_ports {sram_data[11]}]
set_property PACKAGE_PIN T13 [get_ports {sram_data[12]}]
set_property PACKAGE_PIN U13 [get_ports {sram_data[13]}]
set_property PACKAGE_PIN T9  [get_ports {sram_data[14]}]
set_property PACKAGE_PIN T10 [get_ports {sram_data[15]}]

set_property PACKAGE_PIN T15 [get_ports {sram_addr[0]}]
set_property PACKAGE_PIN T14 [get_ports {sram_addr[1]}]
set_property PACKAGE_PIN N16 [get_ports {sram_addr[2]}]
set_property PACKAGE_PIN N15 [get_ports {sram_addr[3]}]
set_property PACKAGE_PIN M17 [get_ports {sram_addr[4]}]
set_property PACKAGE_PIN M16 [get_ports {sram_addr[5]}]
set_property PACKAGE_PIN P18 [get_ports {sram_addr[6]}]
set_property PACKAGE_PIN N17 [get_ports {sram_addr[7]}]
set_property PACKAGE_PIN P14 [get_ports {sram_addr[8]}]
set_property PACKAGE_PIN N14 [get_ports {sram_addr[9]}]
set_property PACKAGE_PIN T18 [get_ports {sram_addr[10]}]
set_property PACKAGE_PIN R18 [get_ports {sram_addr[11]}]
set_property PACKAGE_PIN M13 [get_ports {sram_addr[12]}]
set_property PACKAGE_PIN R13 [get_ports {sram_addr[13]}]
set_property PACKAGE_PIN R12 [get_ports {sram_addr[14]}]
set_property PACKAGE_PIN M18 [get_ports {sram_addr[15]}]
set_property PACKAGE_PIN L18 [get_ports {sram_addr[16]}]
set_property PACKAGE_PIN L16 [get_ports {sram_addr[17]}]
set_property PACKAGE_PIN L15 [get_ports {sram_addr[18]}]

set_property IOSTANDARD LVCMOS33 [get_ports sram_ce_r]
set_property IOSTANDARD LVCMOS33 [get_ports sram_lb_r]
set_property IOSTANDARD LVCMOS33 [get_ports sram_oe_r]
set_property IOSTANDARD LVCMOS33 [get_ports sram_ub_r]
set_property IOSTANDARD LVCMOS33 [get_ports sram_we_r]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[0]}]


#load_image_data_button S0 
set_property PACKAGE_PIN R11 [get_ports load_image_data_button]
set_property IOSTANDARD LVCMOS33 [get_ports load_image_data_button]


#set_side_data_button S1
set_property PACKAGE_PIN R17 [get_ports set_side_data_button]
set_property IOSTANDARD LVCMOS33 [get_ports set_side_data_button]







#from tongtong
set_property IOSTANDARD LVCMOS33 [get_ports {vga_blue[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_blue[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_blue[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_blue[0]}]
set_property PACKAGE_PIN E7 [get_ports {vga_blue[3]}]
set_property PACKAGE_PIN E5 [get_ports {vga_blue[2]}]
set_property PACKAGE_PIN E6 [get_ports {vga_blue[1]}]
set_property PACKAGE_PIN C7 [get_ports {vga_blue[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_green[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_green[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_green[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_green[0]}]
set_property PACKAGE_PIN D8 [get_ports {vga_green[3]}]
set_property PACKAGE_PIN A5 [get_ports {vga_green[2]}]
set_property PACKAGE_PIN A6 [get_ports {vga_green[1]}]
set_property PACKAGE_PIN B6 [get_ports {vga_green[0]}]
set_property PACKAGE_PIN B7 [get_ports {vga_red[3]}]
set_property PACKAGE_PIN C5 [get_ports {vga_red[2]}]
set_property PACKAGE_PIN C6 [get_ports {vga_red[1]}]
set_property PACKAGE_PIN F5 [get_ports {vga_red[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_red[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_red[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_red[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_red[0]}]
set_property PACKAGE_PIN D7 [get_ports vga_hsync]
set_property PACKAGE_PIN C4 [get_ports vga_vsync]
set_property IOSTANDARD LVCMOS33 [get_ports vga_hsync]
set_property IOSTANDARD LVCMOS33 [get_ports vga_vsync]


#from OV7670
set_property IOSTANDARD LVCMOS33 [get_ports pwdm]
set_property IOSTANDARD LVCMOS33 [get_ports reset_cam]
set_property PACKAGE_PIN E16 [get_ports pwdm]
set_property PACKAGE_PIN E15 [get_ports reset_cam]
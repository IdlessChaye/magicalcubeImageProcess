# magicalcubeImageProcess

## Function

use ov7725 camera to get pixals of right position on the surface of magiccube, which will be transfered into 3 bits color encoding through hsv encoding.

## Outputs

  6 surfaces of magiccube * 9 squares * 3 bits color encoding.
  
## Board

Xilinx FPGA EGO1 xc7a35tcsg324

## License

GPLv2.0

## Update

#### 18.10.20 

1. finish image2magicalhsv.v
2. finish fangdou.v and button2face.v, but they are buggy

#### 18.10.29

1. image2magicalhsv.v is also buggy
2. finish div_rill_clk.v and rgb2hsv.v, they work well
3. the top file should be modified into sequential logic design 

#### 18.10.30

1. Architecture is ready
2. finish image_in_sram.v
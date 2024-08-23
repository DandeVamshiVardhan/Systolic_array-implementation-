//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
//Date        : Fri Aug 23 01:25:05 2024
//Host        : LAPTOP-7P8LB6PD running 64-bit major release  (build 9200)
//Command     : generate_target matrix_mul_soc_wrapper.bd
//Design      : matrix_mul_soc_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module matrix_mul_soc_wrapper
   (clk_in1_0,
    reset,
    uart2_pl_rxd,
    uart2_pl_txd);
  input clk_in1_0;
  input reset;
  input uart2_pl_rxd;
  output uart2_pl_txd;

  wire clk_in1_0;
  wire reset;
  wire uart2_pl_rxd;
  wire uart2_pl_txd;

  matrix_mul_soc matrix_mul_soc_i
       (.clk_in1_0(clk_in1_0),
        .reset(reset),
        .uart2_pl_rxd(uart2_pl_rxd),
        .uart2_pl_txd(uart2_pl_txd));
endmodule

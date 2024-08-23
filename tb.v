`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2024 16:01:56
// Design Name: 
// Module Name: tb
// Project Name: 
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


module tb();
reg clk,load_in,weight_in;
reg reset,start;
reg [31:0]weight_d,input_d;
reg [31:0]data;
wire [31:0]mem_data1,mem_data2,mem_data3,mem_data4;


initial clk=1'b0;
always #5 clk=~clk;

controller s1(data,load_in,load_in,start,clk,reset,mem_data1,mem_data2,mem_data3,mem_data4,weight_d,input_d);


initial
fork
reset=1'b0;
start=1'b0;
load_in=1'b0;
data=32'h3f800000;
weight_d=32'h00000033;
input_d =32'h00000033;
#1 reset=1'b1;
#2 load_in=1'b1;
#4 load_in=1'b0;
#10data=32'h40000000;
#13 load_in=1'b1;
#15 load_in=1'b0;
#20data=32'h40400000;
#26 load_in=1'b1;
#29 load_in=1'b0;
#30data=32'h40800000;
#37 load_in=1'b1;
#39load_in=1'b0;
#40 data=32'h3f800000;
#42 load_in=1'b1;
#45 load_in=1'b0;
#50 data=32'h40000000;
#51 load_in=1'b1;
#52 load_in=1'b0;
#60 data=32'h40400000;
#61 load_in=1'b1;
#62 load_in=1'b0;
#70 data=32'h40800000;
#71 load_in=1'b1;
#72 load_in=1'b0;
#80 data=32'h40800000;
#81 load_in=1'b1;
#83 start=1'b1;
join
endmodule

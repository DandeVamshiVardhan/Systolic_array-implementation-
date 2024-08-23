`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2024 00:04:25
// Design Name: 
// Module Name: processing_element_tb
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


module processing_element_tb();
reg [31:0]in1,in2;
reg clk;
wire [31:0]out1;
adder m2(in1,in2,clk,out1);

initial clk=1'b0; always #5 clk=~clk;

initial 
fork
in1=32'b0_00000000_00000000000000000000000;
in2=32'b0_00000000_00000000000000000000000;
#5 in1=32'b1_00000001_11100000000000000000000;
#5 in2=32'b0_01111111_00000000000000000000000;
join
endmodule

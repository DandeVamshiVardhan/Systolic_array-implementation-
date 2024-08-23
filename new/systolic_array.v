`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2024 14:51:57
// Design Name: 
// Module Name: project
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


`include"pe.v"
`define PEROW 9
`define PECOL 9
module systolic_array(input clk,
                     input reset,
                     input load,
                     input[32*`PEROW-1:0]weight_data,
                     input[32*`PECOL-1:0]input_data,
                     output[31:0]mem_data1,mem_data2,mem_data3,mem_data4);
                     
 wire [31:0]data1[0:`PEROW][0:`PECOL-1];
 wire [31:0]data2[0:`PEROW-1][0:`PECOL]; 
 wire [31:0]data3[0:`PEROW-1][0:`PECOL-1];
 reg [31:0]output_memory[0:8][0:8];
 
 assign {data1[0][0],data1[0][1],data1[0][2],data1[0][3],data1[0][4],
        data1[0][5],data1[0][6],data1[0][7],data1[0][8]}=input_data;
 assign {data2[0][0],data2[1][0],data2[2][0],data2[3][0],data2[4][0],
        data2[5][0],data2[6][0],data2[7][0],data2[8][0]}=weight_data;
 
 
 // assigning output data;
assign mem_data1=output_memory[0][0];
assign mem_data2=output_memory[0][1];
assign mem_data3=output_memory[1][0];
assign mem_data4=output_memory[1][1];


integer l,k;




always @(posedge clk,negedge reset)
if(reset==1'b0) begin  for(l=0;l<9;l=l+1)
                                      for(k=0;k<9;k=k+1) begin output_memory[l][k]<=32'b0; end
                                       end
else if(load) begin   for(l=0;l<9;l=l+1)
                                for(k=0;k<9;k=k+1) begin output_memory[l][k]<=data3[l][k]; end   end
 
 

genvar i,j;
generate 
    for(i=0;i<`PEROW;i=i+1) begin
         for(j=0;j<`PECOL;j=j+1)
                begin 
         processing_element pe(.north(data1[i][j]),
                             .west(data2[i][j]), 
                             .clk(clk),
                             .reset(reset),
                             .outport(data3[i][j]),
                             .east(data2[i][j+1]),
                             .south(data1[i+1][j]));
                    end
  end
endgenerate       


endmodule








 


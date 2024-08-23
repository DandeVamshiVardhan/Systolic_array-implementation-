`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2024 17:03:21
// Design Name: 
// Module Name: controller controls the operations to be performed on systolic array
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Dependencies: 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include"project.v"
`include"pe.v"


module controller(input [31:0]data,input load_in,weight_in,start,input clk,reset,output [31:0]mem_data1,mem_data2,mem_data3,mem_data4,input [31:0]weight_d,input_d);

 reg [31:0]input_memory[0:8][0:8];            // input memory to store input data;
 reg [31:0]weight_memory[0:8][0:8];           // weight memory to store weoght data;
 integer i,j;
 reg [3:0]row,row1,col,col1;
 reg [4:0]count;


always @(posedge load_in,negedge reset)       // loading of input data
if(reset==1'b0) begin  for(i=0;i<9;i=i+1)
                              for(j=0;j<9;j=j+1) begin input_memory[i][j]<=32'b0;  end 
                end
 else   input_memory[row][col]<=data;         
                
                
                
always @(posedge weight_in,negedge reset)        // loading of weight data
if(reset==1'b0) begin  for(i=0;i<9;i=i+1)
                              for(j=0;j<9;j=j+1) begin  weight_memory[i][j]<=32'b0; end 
                              end

 else weight_memory[row1][col1]<=data;                                     
                
                
                
                
always @(posedge load_in,negedge reset)          // controlling row and col for input data loading
if(reset==1'b0) begin row<=4'b0;  col<=4'b0;    end
else begin if(col==(input_d[3:0]-1'b1)) begin row<=row+1'b1;col=4'b0000; end else col<=col+1'b1; end




always @(posedge weight_in,negedge reset)        // controlling row1 and col1 for weight data loading
if(reset==1'b0) begin row1<=4'b0;  col1<=4'b0;    end
else begin if(col1==(weight_d[3:0]-1'b1)) begin row1<=row1+1'b1; col1<=4'b0000; end  else col1<=col1+1'b1; end
 
wire load,step,inc;



assign step=(count>=(input_d[7:4]+input_d[3:0]-1'b1))&(count>=(weight_d[7:3]+weight_d[3:0]-1'b1));   //end shifting if count==17 so after that only zeros are given 



always @(posedge clk,negedge reset)
if(reset==1'b0) count<=5'b0; 
else if(inc) count<=count+1'b1; 


reg [287:0]weight_array;
reg [287:0]input_array;

reg g;

always @*                   //   mux for input array
begin
input_array={288{1'b0}};
if(g)
begin
case(count)
5'b00000:input_array={input_memory[0][0],{8{32'b0}}};
5'b00001:input_array={input_memory[1][0],input_memory[0][1],{7{32'b0}}};
5'b00010:input_array={input_memory[2][0],input_memory[1][1],input_memory[0][2],{6{32'b0}}};
5'b00011:input_array={input_memory[3][0],input_memory[2][1],input_memory[1][2],input_memory[0][3],{5{32'b0}}};
5'b00100:input_array={input_memory[4][0],input_memory[3][1],input_memory[2][2],input_memory[1][3],
                       input_memory[0][4],{4{32'b0}}};
5'b00101:input_array={input_memory[5][0],input_memory[4][1],input_memory[3][2],input_memory[2][3],
                       input_memory[1][4],input_memory[0][5],{3{32'b0}}};
5'b00110:input_array={input_memory[6][0],input_memory[5][1],input_memory[4][2],input_memory[3][3],
                       input_memory[2][4],input_memory[1][5],input_memory[0][6],{2{32'b0}}};
5'b00111:input_array={input_memory[7][0],input_memory[6][1],input_memory[5][2],input_memory[4][3],
                       input_memory[3][4],input_memory[2][5],input_memory[1][6],input_memory[0][7],{1{32'b0}}};
5'b01000:input_array={input_memory[8][0],input_memory[7][1],input_memory[6][2],input_memory[5][3],
                       input_memory[4][4],input_memory[3][5],input_memory[2][6],input_memory[1][7],
                       input_memory[0][8]};
5'b01001:input_array={32'b0,input_memory[8][1],input_memory[7][2],input_memory[6][3],
                       input_memory[5][4],input_memory[4][5],input_memory[3][6],input_memory[2][7],
                       input_memory[1][8]};
5'b01010:input_array={32'b0,32'b0,input_memory[8][2],input_memory[7][3],
                       input_memory[6][4],input_memory[5][5],input_memory[4][6],input_memory[3][7],
                       input_memory[2][8]};
5'b01011:input_array={32'b0,32'b0,32'b0,input_memory[8][3],
                       input_memory[7][4],input_memory[6][5],input_memory[5][6],input_memory[4][7],
                       input_memory[3][8]};                      

5'b01100:input_array={32'b0,32'b0,32'b0,32'b0,
                       input_memory[8][4],input_memory[7][5],input_memory[6][6],input_memory[5][7],
                       input_memory[4][8]};
5'b01101:input_array={32'b0,32'b0,32'b0,32'b0,32'b0,input_memory[8][5],input_memory[7][6],input_memory[6][7],
                       input_memory[5][8]};
5'b01110:input_array={32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,input_memory[8][6],input_memory[7][7],
                       input_memory[6][8]};
5'b01111:input_array={32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,input_memory[8][7],
                       input_memory[7][8]};
5'b10000:input_array={{256{1'b0}},input_memory[8][8]};
default:input_array={288{1'b0}};
endcase
end
else input_array={288{1'b0}};
end


                
always @*                        // mux for weight array
begin
weight_array={288{1'b0}};                        
if(g)
begin
case(count)
5'b00000:weight_array={weight_memory[0][0],{8{32'b0}}};
5'b00001:weight_array={weight_memory[0][1],weight_memory[1][0],{7{32'b0}}};
5'b00010:weight_array={weight_memory[0][2],weight_memory[1][1],weight_memory[2][0],{6{32'b0}}};
5'b00011:weight_array={weight_memory[0][3],weight_memory[1][2],weight_memory[2][1],weight_memory[3][0],{5{32'b0}}};
5'b00100:weight_array={weight_memory[0][4],weight_memory[1][3],weight_memory[2][2],weight_memory[3][1],
         weight_memory[4][0],{4{32'b0}}};
5'b00101:weight_array={weight_memory[0][5],weight_memory[1][4],weight_memory[2][3],weight_memory[3][2],
                       weight_memory[4][1],weight_memory[5][0],{3{32'b0}}};
5'b00110:weight_array={weight_memory[0][6],weight_memory[1][5],weight_memory[2][4],weight_memory[3][3],
                       weight_memory[4][2],weight_memory[5][1],weight_memory[6][0],{2{32'b0}}};
5'b00111:weight_array={weight_memory[0][7],weight_memory[1][6],weight_memory[2][5],weight_memory[3][4],
                       weight_memory[4][3],weight_memory[5][2],weight_memory[6][1],weight_memory[7][0],32'b0};
5'b01000:weight_array={weight_memory[0][8],weight_memory[1][7],weight_memory[2][6],weight_memory[3][5],
                       weight_memory[4][4],weight_memory[5][3],weight_memory[6][2],weight_memory[7][1],
                       weight_memory[8][0]};
5'b01001:weight_array={32'b0,weight_memory[1][8],weight_memory[2][7],weight_memory[3][6],
                       weight_memory[4][5],weight_memory[5][4],weight_memory[6][3],weight_memory[7][2],
                       weight_memory[8][1]};
5'b01010:weight_array={32'b0,32'b0,weight_memory[2][8],weight_memory[3][7],
                       weight_memory[4][6],weight_memory[5][5],weight_memory[6][4],weight_memory[7][3],
                       weight_memory[8][2]};
5'b01011:weight_array={32'b0,32'b0,32'b0,weight_memory[3][8],
                       weight_memory[4][7],weight_memory[5][6],weight_memory[6][5],weight_memory[7][4],
                       weight_memory[8][3]};                      

5'b01100:weight_array={32'b0,32'b0,32'b0,32'b0,
                       weight_memory[4][8],weight_memory[5][7],weight_memory[6][6],weight_memory[7][5],
                       weight_memory[8][4]};
5'b01101:weight_array={32'b0,32'b0,32'b0,32'b0,
                       32'b0,weight_memory[5][8],weight_memory[6][7],weight_memory[7][6],
                       weight_memory[8][5]};
5'b01110:weight_array={32'b0,32'b0,32'b0,32'b0,
                       32'b0,32'b0,weight_memory[6][8],weight_memory[7][7],
                       weight_memory[8][6]};
5'b01111:weight_array={32'b0,32'b0,32'b0,32'b0,
                       32'b0,32'b0,32'b0,weight_memory[7][8],
                       weight_memory[8][7]};
5'b10000:weight_array={{256{1'b0}},weight_memory[8][8]};
default:weight_array={288{1'b0}};
endcase
end 
else weight_array={288{1'b0}};
end



always @(posedge clk,negedge reset)   // one clock delay for g so that input starts enetring into data at
if(reset==1'b0)   begin g<=1'b0;  end    // correct time
else begin g<=start;  end 


systolic_array sa1((g&clk),reset,load,weight_array,input_array,mem_data1,mem_data2,mem_data3,mem_data4);
fsm m1(clk,reset,start,step,inc,load);





endmodule







// fsm to control operation
module fsm(input clk,reset,start,step,output reg inc,output reg load);

reg [1:0]state,nstate;



always @(posedge clk,negedge reset)
if(reset==1'b0) state<=2'b0;
else state<=nstate;




always @*
begin
inc=1'b0;
load=1'b0;
nstate=2'b00;
case(state)
2'b00: if(start) nstate=2'b01; else nstate=2'b00;
2'b01: if(step) nstate=2'b10; else begin inc=1'b1; nstate=2'b01; end
2'b10: begin load=1'b1; nstate=2'b11; end
2'b11: nstate=2'b11;
default: nstate=2'b00;
endcase
end



endmodule
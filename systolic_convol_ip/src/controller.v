`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.08.2024 23:29:42
// Design Name: 
// Module Name: controller
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


`include"systolic_array.v"   
`include"pe.v"


module controller(input [31:0]data,input load_in,weight_in,start,input clk,reset,output [31:0]mem_data1,mem_data2,mem_data3,mem_data4,input [31:0]weight_d,input_d);

 reg [31:0]input_memory[0:8][0:8];            // input memory to store input data;
 reg [31:0]weight_memory[0:8][0:8];           // weight memory to store weoght data;
 
 integer i,j;
 
 reg [3:0]row,row1,col,col1;
 
 reg [4:0]count;
 
 reg [31:0]v_memory[0:8][0:8];                // to store correct data format of input image




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
else begin if(col1==(weight_d[3:0]-1'b1)) begin row1<=row1+1'b1; col1<=4'b0000; end 
                                                else col1<=col1+1'b1; end
                                                
              
               
                                                
 
reg [3:0]v_row,v_col,w_row,w_col;    // to control data flow into virtual memory


reg [3:0]r_bias,c_bias;               // for adding bias to the actual one

 
wire clk1=(start&clk);



always @(posedge clk1,negedge reset)    // v_row and v_col controlling logic
if(reset==1'b0) begin v_row<=4'b0;  v_col=4'b0;   end
else  begin
       if((v_row==((input_d[7:4]*input_d[3:0])-1'b1))&&(v_col!=(((weight_d[7:4]-input_d[7:4]+1'b1)*(weight_d[3:0]-input_d[3:0]+1'b1))-1'b1)))  
                                                                      begin v_col<=v_col+1'b1;  v_row<=4'b0; end    
                         else if(v_row!=((input_d[7:4]*input_d[3:0])-1'b1)) v_row<=v_row+1'b1;  
                                                                                                  end
      
                       
           
always @(posedge clk1,negedge reset)   // counters that store the bias 
if(reset==1'b0) begin r_bias<=4'b0; c_bias<=4'b0; end                        
else begin 
if((w_col==(input_d[3:0]-1'b1))&&(w_row==(input_d[7:4]-1'b1))) 
       begin  if(((w_col+c_bias)==(weight_d[3:0]-1'b1))&&((w_row+r_bias)!=(weight_d[7:4]-1'b1)))  begin r_bias<=r_bias+1'b1; c_bias<=4'b0;    end
               else if((w_col+c_bias)!=(weight_d[3:0]-1'b1)) c_bias<=c_bias+1'b1;           end
                                 
                     
                      end


reg g,h;

  
always @(posedge clk1,negedge reset)       // counters used to control row and col
if(reset==1'b0) begin w_row<=4'b0; w_col<=4'b0; end 
else begin   if((w_col==(input_d[3:0]-1'b1))&&(w_row!=(input_d[7:4]-1'b1))) begin w_row<=w_row+1'b1;  w_col<=4'b0; end
            else if(w_col!=(input_d[3:0]-1'b1)) w_col<=w_col+1'b1;    
           else if((w_col==(input_d[3:0]-1'b1))&&(w_row==(input_d[7:4]-1'b1))&&(((w_col+c_bias)!=(weight_d[3:0]-1'b1))|((w_row+r_bias)!=(weight_d[7:4]-1'b1)))) 
                                   begin w_row<=4'b0; w_col<=4'b0; end
                  end
                                                
                                                                
          
             

             
             
always @(posedge clk1,negedge reset)    // loading data into virtual memory and implementing shifting configuration
if(reset==1'b0) begin  for(i=0;i<9;i=i+1)
                              for(j=0;j<9;j=j+1) begin  v_memory[i][j]<=32'b0; end 
                                                                                        end
 else if(g==1'b0)
          
                     begin v_memory[v_row][v_col]<=weight_memory[w_row+r_bias][w_col+c_bias];   end
 
 else   begin
            if((count>=5'b0)&&(g==1'b1))  begin v_memory[0][0]<=v_memory[1][0];
                       v_memory[1][0]<=v_memory[2][0];
                       v_memory[2][0]<=v_memory[3][0];
                       v_memory[3][0]<=v_memory[4][0];
                       v_memory[4][0]<=v_memory[5][0];
                       v_memory[5][0]<=v_memory[6][0];
                       v_memory[6][0]<=v_memory[7][0];
                       v_memory[7][0]<=v_memory[8][0];
                       v_memory[8][0]<=32'b0;     end

            if((count>=5'b00001)&&(g==1'b1))  begin v_memory[0][1]<=v_memory[1][1];
                       v_memory[1][1]<=v_memory[2][1];
                       v_memory[2][1]<=v_memory[3][1];
                       v_memory[3][1]<=v_memory[4][1];
                       v_memory[4][1]<=v_memory[5][1];
                       v_memory[5][1]<=v_memory[6][1];
                       v_memory[6][1]<=v_memory[7][1];
                       v_memory[7][1]<=v_memory[8][1];
                       v_memory[8][1]<=32'b0;     end

          if((count>=5'b00010)&&(g==1'b1))  begin v_memory[0][2]<=v_memory[1][2];
                       v_memory[1][2]<=v_memory[2][2];
                       v_memory[2][2]<=v_memory[3][2];
                       v_memory[3][2]<=v_memory[4][2];
                       v_memory[4][2]<=v_memory[5][2];
                       v_memory[5][2]<=v_memory[6][2];
                       v_memory[6][2]<=v_memory[7][2];
                       v_memory[7][2]<=v_memory[8][2];
                       v_memory[8][2]<=32'b0;     end

          if((count>=5'b00011)&&(g==1'b1))  begin v_memory[0][3]<=v_memory[1][3];
                       v_memory[1][3]<=v_memory[2][3];
                       v_memory[2][3]<=v_memory[3][3];
                       v_memory[3][3]<=v_memory[4][3];
                       v_memory[4][3]<=v_memory[5][3];
                       v_memory[5][3]<=v_memory[6][3];
                       v_memory[6][3]<=v_memory[7][3];
                       v_memory[7][3]<=v_memory[8][3];
                       v_memory[8][3]<=32'b0;     end

           if((count>=5'b00100)&&(g==1'b1))  begin v_memory[0][4]<=v_memory[1][4];
                       v_memory[1][4]<=v_memory[2][4];
                       v_memory[2][4]<=v_memory[3][4];
                       v_memory[3][4]<=v_memory[4][4];
                       v_memory[4][4]<=v_memory[5][4];
                       v_memory[5][4]<=v_memory[6][4];
                       v_memory[6][4]<=v_memory[7][4];
                       v_memory[7][4]<=v_memory[8][4];
                       v_memory[8][4]<=32'b0;     end

          if((count>=5'b00101)&&(g==1'b1))  begin v_memory[0][5]<=v_memory[1][5];
                       v_memory[1][5]<=v_memory[2][5];
                       v_memory[2][5]<=v_memory[3][5];
                       v_memory[3][5]<=v_memory[4][5];
                       v_memory[4][5]<=v_memory[5][5];
                       v_memory[5][5]<=v_memory[6][5];
                       v_memory[6][5]<=v_memory[7][5];
                       v_memory[7][5]<=v_memory[8][5];
                       v_memory[8][5]<=32'b0;     end
                       
          if((count>=5'b00110)&&(g==1'b1))  begin v_memory[0][6]<=v_memory[1][6];
                       v_memory[1][6]<=v_memory[2][6];
                       v_memory[2][6]<=v_memory[3][6];
                       v_memory[3][6]<=v_memory[4][6];
                       v_memory[4][6]<=v_memory[5][6];
                       v_memory[5][6]<=v_memory[6][6];
                       v_memory[6][6]<=v_memory[7][6];
                       v_memory[7][6]<=v_memory[8][6];
                       v_memory[8][6]<=32'b0;     end

         if((count>=5'b00111)&&(g==1'b1))  begin v_memory[0][7]<=v_memory[1][7];
                       v_memory[1][7]<=v_memory[2][7];
                       v_memory[2][7]<=v_memory[3][7];
                       v_memory[3][7]<=v_memory[4][7];
                       v_memory[4][7]<=v_memory[5][7];
                       v_memory[5][7]<=v_memory[6][7];
                       v_memory[6][7]<=v_memory[7][7];
                       v_memory[7][7]<=v_memory[8][7];
                       v_memory[8][7]<=32'b0;     end
         if((count>=5'b01000)&&(g==1'b1))  begin v_memory[0][8]<=v_memory[1][8];
                       v_memory[1][8]<=v_memory[2][8];
                       v_memory[2][8]<=v_memory[3][8];
                       v_memory[3][8]<=v_memory[4][8];
                       v_memory[4][8]<=v_memory[5][8];
                       v_memory[5][8]<=v_memory[6][8];
                       v_memory[6][8]<=v_memory[7][8];
                       v_memory[7][8]<=v_memory[8][8];
                       v_memory[8][8]<=32'b0;     end
                     
     
end
 
 
wire start1=(((w_col+c_bias)==(weight_d[3:0]-1'b1))&&((w_row+r_bias)==(weight_d[7:4]-1'b1)));          




always @(posedge clk,negedge reset)   // one clock delay for g so that input starts enetring into data at
if(reset==1'b0)   begin g<=1'b0;  h<=1'b0; end    // correct time
else begin g<=start1; h<=g; end 



reg [31:0]v_input[0:8];

reg [3:0]i_row,i_col;

reg [3:0]v_irow;


always @(posedge clk1,negedge reset)     // 
if(reset==1'b0) begin i_row<=4'b0; i_col<=4'b0; v_irow<=4'b0; end
else begin   if((i_col==(input_d[3:0]-1'b1))&&(i_row!=(input_d[7:4]-1'b1))) begin v_irow<=v_irow+1'b1; i_col<=4'b0; i_row<=i_row+1'b1; end
                 else if((i_col!=(input_d[3:0]-1'b1))) begin v_irow<=v_irow+1'b1; i_col<=i_col+1'b1; end
                  end
                  
                  
always @(posedge clk1,negedge reset)
if(reset==1'b0) begin  for(i=0;i<9;i=i+1) v_input[i]<=32'b0;  end   
else begin    if((count>=5'b0)&&(g==1'b1)) begin v_input[8]<=v_input[7];
                      v_input[7]<=v_input[6];
                      v_input[6]<=v_input[5];
                      v_input[5]<=v_input[4];
                      v_input[4]<=v_input[3];
                      v_input[3]<=v_input[2];
                      v_input[2]<=v_input[1];
                      v_input[1]<=v_input[0];
                      v_input[0]<=32'b0; end
                       else v_input[4'b1000-(input_d[7:4]*input_d[3:0]-1'b1)+v_irow]<=input_memory[i_row][i_col];
                                  
                                     end      

      
      
  

wire [31:0]w_array1=((count>=5'b0)&&(g==1'b1))?v_memory[0][0]:32'b0;
wire [31:0]w_array2=((count>=5'b00001)&&(g==1'b1))?v_memory[0][1]:32'b0;
wire [31:0]w_array3=((count>=5'b00010)&&(g==1'b1))?v_memory[0][2]:32'b0;
wire [31:0]w_array4=((count>=5'b00011)&&(g==1'b1))?v_memory[0][3]:32'b0;
wire [31:0]w_array5=((count>=5'b00100)&&(g==1'b1))?v_memory[0][4]:32'b0;
wire [31:0]w_array6=((count>=5'b00101)&&(g==1'b1))?v_memory[0][5]:32'b0;
wire [31:0]w_array7=((count>=5'b00110)&&(g==1'b1))?v_memory[0][6]:32'b0;
wire [31:0]w_array8=((count>=5'b00111)&&(g==1'b1))?v_memory[0][7]:32'b0;
wire [31:0]w_array9=((count>=5'b01000)&&(g==1'b1))?v_memory[0][8]:32'b0;

wire [287:0]w_array={w_array1,w_array2,w_array3,w_array4,w_array5,w_array6,w_array7,w_array8,w_array9};



wire load,inc,step;

always @(posedge clk,negedge reset)
if(reset==1'b0) count<=5'b0;
else if(inc&g) count<=count+1'b1;



assign step=(count>=5'b10010);

systolic_array sa1(clk,reset,load,w_array,{v_input[8],{8{32'b0}}},mem_data1,mem_data2,mem_data3,mem_data4);
fsm f1(clk,reset,start1,step,inc,load);


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
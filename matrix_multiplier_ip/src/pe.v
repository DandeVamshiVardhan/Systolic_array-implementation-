`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2024 15:34:33
// Design Name: 
// Module Name: pe
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


//processing elemnt devoloped with 356 luts only
module adder1(input [31:0]a,b,output [31:0]o);

// almost structural modelling of circuit fixedpointadder
wire [7:0]count;

wire exponent_checker=(a[30:23]>=b[30:23]);
wire compare=~(a[31]^b[31]);
wire [7:0]exponent_diff=(exponent_checker==1'b1)?(a[30:23]+~b[30:23]+1'b1):(b[30:23]+~a[30:23]+1'b1);

wire [24:0]shifted=(exponent_checker==1'b1)?({25{|b}}&{1'b1,b[22:0]}):({25{|a}}&{1'b1,a[22:0]});
wire [24:0]shifted1;

rightshifted RS1(shifted,exponent_diff,shifted1);

wire [24:0]normal1=(exponent_checker==1'b1)?{25{|a}}&{1'b1,a[22:0]}:{25{|b}}&{1'b1,b[22:0]};

wire shifted1_sign;
wire  normal1_sign; 

assign {shifted1_sign,normal1_sign}=(exponent_checker==1'b1)?{b[31],a[31]}:{a[31],b[31]};

wire compare1=(normal1>=shifted1);

wire sign=(compare1==1'b1)?normal1_sign:shifted1_sign;

wire [24:0]arithmetic_out=(compare==1'b1)?(shifted1+normal1):(compare1==1'b1)?(normal1+~shifted1+1'b1):(shifted1+~normal1+1'b1);

wire arithmetic_checker=(|arithmetic_out);

priorityencoder pe1(arithmetic_out[22:0],count);

wire [7:0]exponent_add=(arithmetic_out[24]==1'b1)?1'b1:(arithmetic_out[23]==1'b1)?1'b0:~count+1'b1;
wire [22:0]shifted2;

leftshifted LS1(arithmetic_out[22:0],count,shifted2);

wire [22:0]mantissa_out=(arithmetic_out[24]==1'b1)?arithmetic_out[23:1]:(arithmetic_out[23]==1'b1)?arithmetic_out[22:0]:shifted2;
 
wire [7:0]exponent_grt=(exponent_checker==1'b1)?(a[30:23]):(b[30:23]);
 
wire [7:0]exponent = exponent_grt+exponent_add;

assign o={32{arithmetic_checker}}&{sign,exponent,mantissa_out};
 

endmodule







// priority encoder module
module priorityencoder(input [22:0]mantissa,output reg[7:0]count);
// priority encoder
always @(mantissa)
begin
count=58'b00000000;
casex(mantissa)
23'b1xxxxxxxxxxxxxxxxxxxxxx:count=8'b00000001;
23'b01xxxxxxxxxxxxxxxxxxxxx:count=8'b00000010;
23'b001xxxxxxxxxxxxxxxxxxxx:count=8'b00000011;
23'b0001xxxxxxxxxxxxxxxxxxx:count=8'b00000100;
23'b00001xxxxxxxxxxxxxxxxxx:count=8'b00000101;
23'b000001xxxxxxxxxxxxxxxxx:count=8'b00000110;
23'b0000001xxxxxxxxxxxxxxxx:count=8'b00000111;
23'b00000001xxxxxxxxxxxxxxx:count=8'b00001000;
23'b000000001xxxxxxxxxxxxxx:count=8'b00001001;
23'b0000000001xxxxxxxxxxxxx:count=8'b00001010;
23'b00000000001xxxxxxxxxxxx:count=8'b00001011;
23'b000000000001xxxxxxxxxxx:count=8'b00001100;
23'b0000000000001xxxxxxxxxx:count=8'b00001101;
23'b00000000000001xxxxxxxxx:count=8'b00001110;
23'b000000000000001xxxxxxxx:count=8'b00001111;
23'b0000000000000001xxxxxxx:count=8'b00010000;
23'b00000000000000001xxxxxx:count=8'b00010001;
23'b000000000000000001xxxxx:count=8'b00010010;
23'b0000000000000000001xxxx:count=8'b00010011;
23'b00000000000000000001xxx:count=8'b00010100;
23'b000000000000000000001xx:count=8'b00010101;
23'b0000000000000000000001x:count=8'b00010110;
23'b00000000000000000000001:count=8'b00010111;
default:count=8'b00000000;
endcase
end
endmodule






// multiplier fixed point 
module multiplier(input [31:0]a,b,output [31:0]o);
// structural modelling of multiplier
wire zero=((|a)&(|b));

wire sign=a[31]^b[31];

wire [47:0]multiplied=({1'b1,a[22:0]})*({1'b1,b[22:0]});

wire [7:0]exponent=a[30:23]+b[30:23]-8'b01111111+multiplied[47];

wire [22:0]mantissa_out=(multiplied[47]==1'b1)?multiplied[46:24]:multiplied[45:23];

assign o=(zero==1'b1)?{sign,exponent,mantissa_out}:32'b0;



endmodule



// module for rightshifting
module rightshifted(input [24:0]shifted,input[7:0]exponent_diff,output reg[24:0]shifted1);

// right shifted module
always@(shifted,exponent_diff)
begin
shifted1=25'b0;
case(exponent_diff)
8'b00000000:shifted1=shifted;
8'b00000001:shifted1={1'b0,shifted[23:1]};
8'b00000010:shifted1={{2{1'b0}},shifted[23:2]};
8'b00000011:shifted1={{3{1'b0}},shifted[23:3]};
8'b00000100:shifted1={{4{1'b0}},shifted[23:4]};
8'b00000101:shifted1={{5{1'b0}},shifted[23:5]};
8'b00000110:shifted1={{6{1'b0}},shifted[23:6]};
8'b00000111:shifted1={{7{1'b0}},shifted[23:7]};
8'b00001000:shifted1={{8{1'b0}},shifted[23:8]};
8'b00001001:shifted1={{9{1'b0}},shifted[23:9]};
8'b00001010:shifted1={{10{1'b0}},shifted[23:10]};
8'b00001011:shifted1={{11{1'b0}},shifted[23:11]};
8'b00001100:shifted1={{12{1'b0}},shifted[23:12]};
8'b00001101:shifted1={{13{1'b0}},shifted[23:13]};
8'b00001110:shifted1={{14{1'b0}},shifted[23:14]};
8'b00001111:shifted1={{15{1'b0}},shifted[23:15]};
8'b00010000:shifted1={{16{1'b0}},shifted[23:16]};
8'b00010001:shifted1={{17{1'b0}},shifted[23:17]};
8'b00010010:shifted1={{18{1'b0}},shifted[23:18]};
8'b00010011:shifted1={{19{1'b0}},shifted[23:19]};
8'b00010100:shifted1={{20{1'b0}},shifted[23:20]};
8'b00010101:shifted1={{21{1'b0}},shifted[23:21]};
8'b00010110:shifted1={{22{1'b0}},shifted[23:22]};
8'b00010111:shifted1={{23{1'b0}},shifted[23]};
default:shifted1=25'b0;
endcase
end
endmodule



module processing_element(input [31:0]north,west,input clk,reset,output reg [31:0]outport,east,south);

// design of overall processing element
wire [31:0]out,o;

adder1 m1(out,outport,o);
multiplier m2(north,west,out);

always @(posedge clk,negedge reset)  
if(reset==1'b0) begin outport<=32'b0; east<=32'b0; south<=32'b0; end
else begin outport<=o; east<=west; south<=north; end


endmodule


module leftshifted(input [22:0]shifted,input [7:0]exponent_diff,output reg [22:0]shifted1);

// leftshifted circuit
always@(shifted,exponent_diff)
begin
shifted1=23'b0;
case(exponent_diff)
8'b00000000:shifted1=shifted;
8'b00000001:shifted1={shifted[21:0],1'b0};
8'b00000010:shifted1={shifted[20:0],{2{1'b0}}};
8'b00000011:shifted1={shifted[19:0],{3{1'b0}}};
8'b00000100:shifted1={shifted[18:0],{4{1'b0}}};
8'b00000101:shifted1={shifted[17:0],{5{1'b0}}};
8'b00000110:shifted1={shifted[16:0],{6{1'b0}}};
8'b00000111:shifted1={shifted[15:0],{7{1'b0}}};
8'b00001000:shifted1={shifted[14:0],{8{1'b0}}};
8'b00001001:shifted1={shifted[13:0],{9{1'b0}}};
8'b00001010:shifted1={shifted[12:0],{10{1'b0}}};
8'b00001011:shifted1={shifted[11:0],{11{1'b0}}};
8'b00001100:shifted1={shifted[10:0],{12{1'b0}}};
8'b00001101:shifted1={shifted[9:0],{13{1'b0}}};
8'b00001110:shifted1={shifted[8:0],{14{1'b0}}};
8'b00001111:shifted1={shifted[7:0],{15{1'b0}}};
8'b00010000:shifted1={shifted[6:0],{16{1'b0}}};
8'b00010001:shifted1={shifted[5:0],{17{1'b0}}};
8'b00010010:shifted1={shifted[4:0],{18{1'b0}}};
8'b00010011:shifted1={shifted[3:0],{19{1'b0}}};
8'b00010100:shifted1={shifted[2:0],{20{1'b0}}};
8'b00010101:shifted1={shifted[1:0],{21{1'b0}}};
8'b00010110:shifted1={shifted[0],{22{1'b0}}};
default:shifted1=23'b0;
endcase
end
endmodule


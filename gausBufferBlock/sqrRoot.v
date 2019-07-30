`timescale 1ns/100ps
module sqrRoot(clk,invalue,outvalue);
input clk;
input [31:0]invalue;
output [31:0]outvalue;
wire clk;
wire [31:0]invalue;
wire [31:0]outvalue;
reg signed [31:0]inverter;
reg signed [31:0]invalReg1;
reg signed [31:0]invalReg2;
reg signed [31:0]subReg;
parameter SUBTRACTOR = 32'h5F3759DF;

assign outvalue[31:0] = inverter[31:0]/invalReg2[31:0];

always @(posedge clk)
	begin
		invalReg2[31:0] = invalReg1[31:0] - subReg[31:0]; 
	end
	
always @(posedge clk)
	begin
		invalReg1[31:0] = invalue[31:0] >> 1;
		inverter = 1;
		subReg =SUBTRACTOR;
		
	end
	
endmodule
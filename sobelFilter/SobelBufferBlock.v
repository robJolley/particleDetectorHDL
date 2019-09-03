`timescale 1ns/100ps
module sobelBufferBlock(clk,popBufferEn,reset,readData,BufferA,BufferB,BufferC,BufferD);
parameter STARTADDRESS = 0,  ENDADDRESS = 2097151,BEATS = 3, PAUSE = 1, PIXW = 24;

input clk, popBufferEn,reset;
input [63:0]readData;
output [63:0]BufferA;
output [63:0]BufferB;
output [63:0]BufferC;
output [63:0]BufferD;

wire clk, popBufferEn,started,process,reset;
wire [63:0]readData;
reg [63:0]BufferA;
reg [63:0]BufferB;
reg [63:0]BufferC;
reg [63:0]BufferD;
wire [23:0]pixelCounter;
reg [63:0]regBufferB;
reg [63:0]regBufferC;
reg [63:0]regBufferD;
reg [63:0]regBufferBH;
reg [63:0]regBufferCH;

wire nclk;

assign nclk = !clk;

beatCounter
	#(.MINPIXEL(STARTADDRESS),.MAXPIXEL(ENDADDRESS),.BEATS(BEATS),.PAUSE(PAUSE),.PIXELCOUNTERWIDTH(PIXW)
	) bufferCounterBlock(clk,popBufferEn,reset,process,started,pixelCounter);



	
always@(posedge nclk)
	begin
		if (process == 1)
			begin
				regBufferB <= readData;
				regBufferC <= regBufferBH;
				regBufferD <= regBufferCH;

			end
		if (process == 0 && started == 1)
			begin
				BufferD <= regBufferD;
				BufferC <= regBufferC;
				BufferB <= regBufferB;
				BufferA <= readData;

			end
	end

always@(posedge clk)
	begin
		if (process == 1)
			begin
				regBufferBH <= regBufferB;
				regBufferCH <= regBufferC;


			end
	end
	
always@(posedge clk)
	if(reset == 1)
		begin
			regBufferB = 0;
			regBufferC = 0;
			regBufferD = 0;
			BufferA = 0;
			BufferB = 0;
			BufferC = 0;
			BufferD = 0;
		end
endmodule			
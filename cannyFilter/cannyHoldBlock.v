`timescale 1ns/100ps
module cannyHoldBlock(clk,HoldEn,reset,ShiftA,ShiftB,ShiftC,HoldOutA,HoldOutB,HoldOutC);
parameter STARTADDRESS = 770,  ENDADDRESS = 2097152 ,BEATS = 3, PAUSE = 1,COUNTSTEPHOLD = 2, PIXW = 24;//address starts in and down two pixels ends the same.  parameter can be imported to accommodate second concurrent pixel 

input clk,HoldEn,reset;
input [23:0]ShiftA;
input [23:0]ShiftB;
input [23:0]ShiftC;
output [23:0]HoldOutA;
output [23:0]HoldOutB;
output [23:0]HoldOutC;
wire clk,holdEn,started,process,reset;
wire [23:0]ShiftA;
wire [23:0]ShiftB;
wire [23:0]ShiftC;
wire [23:0]pixelCounter;

wire [23:0]HoldOutA;
wire [23:0]HoldOutB;
wire [23:0]HoldOutC;

reg [23:0]HoldBufferA;
reg [23:0]HoldBufferB;
reg [23:0]HoldBufferC;


assign HoldOutA[23:0] = HoldBufferA[23:0];
assign HoldOutB[23:0] = HoldBufferB[23:0];
assign HoldOutC[23:0] = HoldBufferC[23:0];

beatCounter
	#(.MINPIXEL(STARTADDRESS),.MAXPIXEL(ENDADDRESS),.BEATS(BEATS),.PAUSE(PAUSE),.COUNTSTEP(COUNTSTEPHOLD),.PIXELCOUNTERWIDTH(PIXW)
	) bufferCounterBlock(clk,HoldEn,reset,process,started,pixelCounter);


always@(posedge clk)
	begin
		if (started == 1)
			begin
				HoldBufferA[23:0] <= ShiftA;//Takes gausBuffer + q1 'array' and deposits in the 64 LSB's of the 5 ShiftBuffer Block
				HoldBufferB[23:0] <= ShiftB;
				HoldBufferC[23:0] <= ShiftC;
			end
			//Basic form needs conditions for transition from one row to next.....
	end
	
always@(posedge clk)
	if(reset == 1)
		begin
			HoldBufferA = 0;
			HoldBufferB = 0;
			HoldBufferC = 0;
		end
endmodule			
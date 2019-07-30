
module HoldBlock(clk,HoldEn,reset,ShiftA,ShiftB,ShiftC,ShiftD,ShiftE,HoldOutA,HoldOutB,HoldOutC,HoldOutD,HoldOutE);
parameter STARTADDRESS = 770,  ENDADDRESS = 2097152 ,BEATS = 4, PAUSE = 1,COUNTSTEPHOLD = 2, PIXW = 24;//address starts in and down two pixels ends the same.  parameter can be imported to accommodate second concurrent pixel 

input clk,HoldEn,reset;
input [39:0]ShiftA;
input [39:0]ShiftB;
input [39:0]ShiftC;
input [39:0]ShiftD;
input [39:0]ShiftE;
output [39:0]HoldOutA;
output [39:0]HoldOutB;
output [39:0]HoldOutC;
output [39:0]HoldOutD;
output [39:0]HoldOutE;
wire clk,holdEn,started,process,reset;
wire [39:0]ShiftA;
wire [39:0]ShiftB;
wire [39:0]ShiftC;
wire [39:0]ShiftD;
wire [39:0]ShiftE;
wire [23:0]pixelCounter;

wire [39:0]HoldOutA;
wire [39:0]HoldOutB;
wire [39:0]HoldOutC;
wire [39:0]HoldOutD;
wire [39:0]HoldOutE;

reg [39:0]HoldBufferA;
reg [39:0]HoldBufferB;
reg [39:0]HoldBufferC;
reg [39:0]HoldBufferD;
reg [39:0]HoldBufferE;


assign HoldOutA[39:0] = HoldBufferA[39:0];
assign HoldOutB[39:0] = HoldBufferB[39:0];
assign HoldOutC[39:0] = HoldBufferC[39:0];
assign HoldOutD[39:0] = HoldBufferD[39:0];
assign HoldOutE[39:0] = HoldBufferE[39:0];

beatCounter
	#(.MINPIXEL(STARTADDRESS),.MAXPIXEL(ENDADDRESS),.BEATS(BEATS),.PAUSE(PAUSE),.COUNTSTEP(COUNTSTEPHOLD),.PIXELCOUNTERWIDTH(PIXW)
	) bufferCounterBlock(clk,HoldEn,reset,process,started,pixelCounter);


always@(posedge clk)
	begin
		if (started == 1 && process == 1)
			begin
				HoldBufferA[39:0] <= ShiftA;//Takes gausBuffer + q1 'array' and deposits in the 64 LSB's of the 5 ShiftBuffer Block
				HoldBufferB[39:0] <= ShiftB;
				HoldBufferC[39:0] <= ShiftC;
				HoldBufferD[39:0] <= ShiftD;
				HoldBufferE[39:0] <= ShiftE;
			end
			//Basic form needs conditions for transition from one row to next.....
	end
	
always@(posedge clk)
	if(reset == 1)
		begin
			HoldBufferA = 0;
			HoldBufferB = 0;
			HoldBufferC = 0;
			HoldBufferD = 0;
			HoldBufferE = 0;			
		end
endmodule			
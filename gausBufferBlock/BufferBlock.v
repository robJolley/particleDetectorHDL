module BufferBlock(clk,popBufferEn,reset,readData,BufferA,BufferB,BufferC,BufferD);
parameter STARTADDRESS = 0,  ENDADDRESS = 2097151,BEATS = 4, PAUSE = 1, PIXW = 24;

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
reg [63:0]regBufferA;
reg [63:0]regBufferB;
reg [63:0]regBufferC;
reg [63:0]regBufferD;
reg processing;

beatCounter
	#(.MINPIXEL(STARTADDRESS),.MAXPIXEL(ENDADDRESS),.BEATS(BEATS),.PAUSE(PAUSE),.PIXELCOUNTERWIDTH(PIXW)
	) bufferCounterBlock(clk,popBufferEn,reset,process,started,pixelCounter);


always@(posedge clk)
	begin
		if (started == 1 && process == 1)
			begin
				processing <= 1;
			end
		if (process == 0)
			begin
				processing <= 0;
			end
	end
	
always@(posedge clk)
	begin
		if (process == 1)
			begin
				regBufferA <= readData;
				regBufferB <= regBufferA;
				regBufferC <= regBufferB;
				regBufferD <= regBufferC;
			end
		if (process == 0)
			begin
				BufferA <= readData;
				BufferB <= regBufferA;
				BufferC <= regBufferB;
				BufferD <= regBufferC;
			end
	end
	
always@(posedge clk)
	if(reset == 1)
		begin
			regBufferA = 0;
			regBufferB = 0;
			regBufferC = 0;
			regBufferD = 0;
			BufferA = 0;
			BufferB = 0;
			BufferC = 0;
			BufferD = 0;
		end
endmodule			
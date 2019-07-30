module ShifterBlock(clk,gausShiftEn,reset,q1,BufferA,BufferB,BufferC,BufferD,gausShiftOutA,gausShiftOutB,gausShiftOutC,gausShiftOutD,gausShiftOutE);
parameter STARTADDRESS = 0,  ENDADDRESS = 4194303,BEATS = 4, PAUSE = 1, PIXW = 24;

input clk,gausShiftEn,reset;
input [63:0]q1;
input [63:0]BufferA;
input [63:0]BufferB;
input [63:0]BufferC;
input [63:0]BufferD;
output [47:0]gausShiftOutA;
output [47:0]gausShiftOutB;
output [47:0]gausShiftOutC;
output [47:0]gausShiftOutD;
output [47:0]gausShiftOutE;
wire clk,gausShiftEn,started,process,reset;
wire [63:0]BufferA;
wire [63:0]BufferB;
wire [63:0]BufferC;
wire [63:0]BufferD;
wire [23:0]pixelCounter;
wire [47:0]gausShiftOutA;
wire [47:0]gausShiftOutB;
wire [47:0]gausShiftOutC;
wire [47:0]gausShiftOutD;
wire [47:0]gausShiftOutE;
reg [127:0]gausShiftBufferA;
reg [127:0]gausShiftBufferB;
reg [127:0]gausShiftBufferC;
reg [127:0]gausShiftBufferD;
reg [127:0]gausShiftBufferE;

assign gausShiftOutE[47:0] = gausShiftBufferA[127:80];
assign gausShiftOutD[47:0] = gausShiftBufferB[127:80];
assign gausShiftOutC[47:0] = gausShiftBufferC[127:80];
assign gausShiftOutB[47:0] = gausShiftBufferD[127:80];
assign gausShiftOutA[47:0] = gausShiftBufferE[127:80];

beatCounter
	#(.MINPIXEL(STARTADDRESS),.MAXPIXEL(ENDADDRESS),.BEATS(BEATS),.PAUSE(PAUSE),.PIXELCOUNTERWIDTH(PIXW)
	) bufferCounterBlock(clk,gausShiftEn,reset,process,started,pixelCounter);


always@(posedge clk)
	begin
		if (started == 1 && process == 1)
			begin
				gausShiftBufferA[127:16] <= gausShiftBufferA[111:0];//Shifting 16 bits to MSB
				gausShiftBufferB[127:16] <= gausShiftBufferB[111:0];
				gausShiftBufferC[127:16] <= gausShiftBufferC[111:0];
				gausShiftBufferD[127:16] <= gausShiftBufferD[111:0];
				gausShiftBufferE[127:16] <= gausShiftBufferE[111:0];
			end
		if (started == 1 && process == 0)
			begin
				gausShiftBufferB[63:0] <= BufferA;//Takes gausBuffer + q1 'array' and deposits in the 64 LSB's of the 5 ShiftBuffer Block
				gausShiftBufferC[63:0] <= BufferB;
				gausShiftBufferD[63:0] <= BufferC;
				gausShiftBufferE[63:0] <= BufferD;
				gausShiftBufferA[63:0] <= q1;
			end
	end
	
always@(posedge clk)
	if(reset == 1)
		begin
		//	gausShiftBufferA = 0;
		//	gausShiftBufferB = 0;
		//	gausShiftBufferC = 0;
		//	gausShiftBufferD = 0;
		//	gausShiftBufferE = 0;			
		end
endmodule			
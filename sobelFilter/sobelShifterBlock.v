`timescale 1ns/100ps
module sobelShifterBlock(clk,sobelShiftEn,reset,q1,BufferA,BufferB,BufferC,sobelShiftOutA,sobelShiftOutB,sobelShiftOutC,sobelShiftOutD);
parameter STARTADDRESS = 0,  ENDADDRESS = 4194303,BEATS = 3, PAUSE = 1, PIXW = 24;

input clk,sobelShiftEn,reset;
input [63:0]q1;
input [63:0]BufferA;
input [63:0]BufferB;
input [63:0]BufferC;

output [31:0]sobelShiftOutA;
output [31:0]sobelShiftOutB;
output [31:0]sobelShiftOutC;
output [31:0]sobelShiftOutD;

wire clk,sobelShiftEn,started,process,reset;
wire [63:0]BufferA;
wire [63:0]BufferB;
wire [63:0]BufferC;

wire [23:0]pixelCounter;
wire [31:0]sobelShiftOutA;
wire [31:0]sobelShiftOutB;
wire [31:0]sobelShiftOutC;
wire [31:0]sobelShiftOutD;

reg [127:0]sobelShiftBufferA;
reg [127:0]sobelShiftBufferB;
reg [127:0]sobelShiftBufferC;
reg [127:0]sobelShiftBufferD;
reg [63:0]QA;


assign sobelShiftOutA[31:0] = sobelShiftBufferA[127:95];
assign sobelShiftOutB[31:0] = sobelShiftBufferB[127:95];
assign sobelShiftOutC[31:0] = sobelShiftBufferC[127:95];
assign sobelShiftOutD[31:0] = sobelShiftBufferD[127:95];


beatCounter
	#(.MINPIXEL(STARTADDRESS),.MAXPIXEL(ENDADDRESS),.BEATS(BEATS),.PAUSE(PAUSE),.PIXELCOUNTERWIDTH(PIXW)
	) bufferCounterBlock(clk,sobelShiftEn,reset,process,started,pixelCounter);


always@(posedge clk)
	begin
		if (started == 1 && process == 1)
			begin
				sobelShiftBufferA[127:16] <= sobelShiftBufferA[111:0];//Shifting 16 bits to MSB
				sobelShiftBufferB[127:16] <= sobelShiftBufferB[111:0];
				sobelShiftBufferC[127:16] <= sobelShiftBufferC[111:0];
				sobelShiftBufferD[127:16] <= sobelShiftBufferD[111:0];
			end
		if (started == 1 && process == 0)//May require its own block
			begin
				sobelShiftBufferA[127:64] <= sobelShiftBufferA[111:48];//Shifting 16 bits to MSB
				sobelShiftBufferB[127:64] <= sobelShiftBufferB[111:48];
				sobelShiftBufferC[127:64] <= sobelShiftBufferC[111:48];
				sobelShiftBufferD[127:64] <= sobelShiftBufferD[111:48];
			//Its possible this is not allowed.... ########
				sobelShiftBufferA[63:0] <= BufferA;//Takes sobelBuffer + q1 'array' and deposits in the 64 LSB's of the 5 ShiftBuffer Block
				sobelShiftBufferB[63:0] <= BufferB;
				sobelShiftBufferC[63:0] <= BufferC;
				sobelShiftBufferD[63:0] <= q1;
			end
	end
	
always@(posedge clk)
	if(reset == 1)
		begin
		//	sobelShiftBufferA = 0;
		//	sobelShiftBufferB = 0;
		//	sobelShiftBufferC = 0;
		//	sobelShiftBufferD = 0;
		//	sobelShiftBufferE = 0;			
		end
endmodule			
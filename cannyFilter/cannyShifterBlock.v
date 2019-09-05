`timescale 1ns/100ps
module cannyShifterBlock(clk,cannyShiftEn,reset,q1,BufferA,BufferB,BufferC,cannyShiftOutA,cannyShiftOutB,cannyShiftOutC,cannyShiftOutD);
parameter STARTADDRESS = 0,  ENDADDRESS = 4194303,BEATS = 3, PAUSE = 1, PIXW = 24;

input clk,cannyShiftEn,reset;
input [63:0]q1;
input [63:0]BufferA;
input [63:0]BufferB;
input [63:0]BufferC;

output [31:0]cannyShiftOutA;
output [31:0]cannyShiftOutB;
output [31:0]cannyShiftOutC;
output [31:0]cannyShiftOutD;

wire clk,cannyShiftEn,started,process,reset;
wire [63:0]BufferA;
wire [63:0]BufferB;
wire [63:0]BufferC;

wire [23:0]pixelCounter;
wire [31:0]cannyShiftOutA;
wire [31:0]cannyShiftOutB;
wire [31:0]cannyShiftOutC;
wire [31:0]cannyShiftOutD;

reg [127:0]cannyShiftBufferA;
reg [127:0]cannyShiftBufferB;
reg [127:0]cannyShiftBufferC;
reg [127:0]cannyShiftBufferD;
reg [63:0]cannyShiftBufferAH;
reg [63:0]cannyShiftBufferBH;
reg [63:0]cannyShiftBufferCH;
reg [63:0]cannyShiftBufferDH;
reg [63:0]QA;
wire nclk;


assign cannyShiftOutA[31:0] = cannyShiftBufferA[127:96];
assign cannyShiftOutB[31:0] = cannyShiftBufferB[127:96];
assign cannyShiftOutC[31:0] = cannyShiftBufferC[127:96];
assign cannyShiftOutD[31:0] = cannyShiftBufferD[127:96];
assign nclk = !clk;

beatCounter
	#(.MINPIXEL(STARTADDRESS),.MAXPIXEL(ENDADDRESS),.BEATS(BEATS),.PAUSE(PAUSE),.PIXELCOUNTERWIDTH(PIXW)
	) bufferCounterBlock(clk,cannyShiftEn,reset,process,started,pixelCounter);


always@(posedge nclk)
	begin
		if (started == 1 && process == 1)
			begin
				cannyShiftBufferA[127:16] <= cannyShiftBufferA[111:0];//Shifting 16 bits to MSB
				cannyShiftBufferB[127:16] <= cannyShiftBufferB[111:0];
				cannyShiftBufferC[127:16] <= cannyShiftBufferC[111:0];
				cannyShiftBufferD[127:16] <= cannyShiftBufferD[111:0];
				cannyShiftBufferAH[63:0] <= cannyShiftBufferA[95:32];//Shifting 16 bits to MSB
				cannyShiftBufferBH[63:0] <= cannyShiftBufferB[95:32];
				cannyShiftBufferCH[63:0] <= cannyShiftBufferC[95:32];
				cannyShiftBufferDH[63:0] <= cannyShiftBufferD[95:32];				
						
			end
		if (started == 1 && process == 0)//May require its own block
			begin
				cannyShiftBufferA[127:64] <= cannyShiftBufferAH[63:0];//Shifting 16 bits to MSB
				cannyShiftBufferB[127:64] <= cannyShiftBufferBH[63:0];
				cannyShiftBufferC[127:64] <= cannyShiftBufferCH[63:0];
				cannyShiftBufferD[127:64] <= cannyShiftBufferDH[63:0];
			//Its possible this is not allowed.... ########

				
				cannyShiftBufferA[63:0] <= BufferC;//Takes cannyBuffer + q1 'array' and deposits in the 64 LSB's of the 5 ShiftBuffer Block
				cannyShiftBufferB[63:0] <= BufferB;
				cannyShiftBufferC[63:0] <= BufferA;
				cannyShiftBufferD[63:0] <= q1;
			end
	end
	
always@(posedge clk)
	if(reset == 1)
		begin
		//	cannyShiftBufferA = 0;
		//	cannyShiftBufferB = 0;
		//	cannyShiftBufferC = 0;
		//	cannyShiftBufferD = 0;
		//	cannyShiftBufferE = 0;			
		end
endmodule			
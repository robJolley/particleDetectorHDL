`timescale 1ns/100ps

module sobelFilter(clk,reset,startEn,read_addr1,q1,we2,we3,write_addr2,data2,write_addr3,data3,getNext);
input clk,reset,startEn;
input [19:0]read_addr1;
input [63:0]q1;

output we2,we3,getNext;
output [19:0]write_addr2;
output [19:0]write_addr3;
output [63:0]data2;
output [63:0]data3;
parameter STARTHOLD1 = 770,  ENDHOLD1 = (261758);//Start and stop address for four Sobel MAatrix
parameter STARTHOLD2 = 771,  ENDHOLD2 = (261259);
parameter STARTHOLD3 = 1026,  ENDHOLD3 = (262014);
parameter STARTHOLD4 = 1027,  ENDHOLD4= (262015);
parameter INITCASE = 0, CASE1 = 1; 
wire [63:0]data1;
wire [63:0]data2;
wire [63:0]data3;
wire startEn,clk,reset;
reg popBufferEn,HoldEn,sobelShiftEn,startMultiplierEn,startNormalisingEn,normPutDataEn,getNext,startMagEn,startDirEn;
reg [2:0]addressCase;
reg sobelSequence;
wire [63:0]q1;
wire [63:0]q2;
wire [63:0]q3;

wire [19:0]read_addr1;
reg [19:0]read_addr2;
reg [19:0]read_addr3;

reg [19:0]addresSchedule;
reg [23:0]sobelCount; 
wire [19:0]write_addr1;
wire [19:0]write_addr2;
wire [19:0]write_addr3;

wire [63:0]BufferA;
wire [63:0]BufferB;
wire [63:0]BufferC;
wire [63:0]BufferD;
wire [31:0]sobelShiftOutA;
wire [31:0]sobelShiftOutB;
wire [31:0]sobelShiftOutC;
wire [31:0]sobelShiftOutD;

wire [23:0]HoldOut1A;
wire [23:0]HoldOut1B;
wire [23:0]HoldOut1C;

wire [23:0]HoldOut2A;
wire [23:0]HoldOut2B;
wire [23:0]HoldOut2C;

wire [23:0]HoldOut3A;
wire [23:0]HoldOut3B;
wire [23:0]HoldOut3C;

wire [23:0]HoldOut4A;
wire [23:0]HoldOut4B;
wire [23:0]HoldOut4C;


wire [23:0]sobelShiftOutHold1A;
wire [23:0]sobelShiftOutHold1B;
wire [23:0]sobelShiftOutHold1C;


wire [23:0]sobelShiftOutHold2A;
wire [23:0]sobelShiftOutHold2B;
wire [23:0]sobelShiftOutHold2C;

wire [23:0]sobelShiftOutHold3A;
wire [23:0]sobelShiftOutHold3B;
wire [23:0]sobelShiftOutHold3C;

wire [23:0]sobelShiftOutHold4A;
wire [23:0]sobelShiftOutHold4B;
wire [23:0]sobelShiftOutHold4C;

wire [17:0]unNormalisedPixelValue1;
wire [17:0]unNormalisedPixelValue2;
wire [17:0]unNormalisedPixelValue3;
wire [17:0]unNormalisedPixelValue4;

wire signed [8:0]sobelX1;
wire signed [8:0]sobelX2;
wire signed [8:0]sobelX3;
wire signed [8:0]sobelX4;
wire signed [8:0]sobelY1;
wire signed [8:0]sobelY2;
wire signed [8:0]sobelY3;
wire signed [8:0]sobelY4;
wire [7:0]normalisedMag1;
wire [7:0]normalisedMag2;
wire [7:0]normalisedMag3;
wire [7:0]normalisedMag4;

wire [7:0]dirE1;
wire [7:0]dirE2;
wire [7:0]dirE3;
wire [7:0]dirE4;

wire we2;



assign sobelShiftOutHold1A = sobelShiftOutA[31:8];
assign sobelShiftOutHold1B = sobelShiftOutB[31:8];
assign sobelShiftOutHold1C = sobelShiftOutC[31:8];


assign sobelShiftOutHold2A = sobelShiftOutA[23:0];
assign sobelShiftOutHold2B = sobelShiftOutB[23:0];
assign sobelShiftOutHold2C = sobelShiftOutC[23:0];

assign sobelShiftOutHold3A = sobelShiftOutB[31:8];
assign sobelShiftOutHold3B = sobelShiftOutC[31:8];
assign sobelShiftOutHold3C = sobelShiftOutD[31:8];


assign sobelShiftOutHold4A = sobelShiftOutB[23:0];
assign sobelShiftOutHold4B = sobelShiftOutC[23:0];
assign sobelShiftOutHold4C = sobelShiftOutD[23:0];


//Ram memory blocks (Simulated)

//simple_ram_dual_clock  SRAM1(data1,read_addr1,write_addr1,we1,clk, clk,q1);
//simple_ram_dual_clock  SRAM2(data2,read_addr2,write_addr2,we2,clk, clk,q2);


//Buffer block used to store 4 of the 5 4 bit registers to prepare them for the shifter block.

sobelBufferBlock	BufferBlock(clk,popBufferEn,reset,q1,BufferA,BufferB,BufferC,BufferD);

//Shifter block to shift through 5x128 bit registers 16 bits at a time to populate the two hold blocks
sobelShifterBlock	ShifterBlock(clk,sobelShiftEn,reset,BufferA,BufferB,BufferC,BufferD,sobelShiftOutA,sobelShiftOutB,sobelShiftOutC,sobelShiftOutD);

//Hold block arranging the pixels in 3x3 matrix for presentation to the multiplier block
sobelHoldBlock #(.STARTADDRESS(STARTHOLD1),.ENDADDRESS(ENDHOLD1))
HolderBlock1(clk,HoldEn,reset,sobelShiftOutHold1A,sobelShiftOutHold1B,sobelShiftOutHold1C,HoldOut1A,HoldOut1B,HoldOut1C);

//Hold block arranging the pixels in 3x3 matrix for presentation to the multiplier block
sobelHoldBlock #(.STARTADDRESS(STARTHOLD2),.ENDADDRESS(ENDHOLD2))
HolderBlock2(clk,HoldEn,reset,sobelShiftOutHold2A,sobelShiftOutHold2B,sobelShiftOutHold2C,HoldOut2A,HoldOut2B,HoldOut2C);

//Hold block arranging the pixels in 3x3 matrix for presentation to the multiplier block
sobelHoldBlock #(.STARTADDRESS(STARTHOLD3),.ENDADDRESS(ENDHOLD3))
HolderBlock3(clk,HoldEn,reset,sobelShiftOutHold3A,sobelShiftOutHold3B,sobelShiftOutHold3C,HoldOut3A,HoldOut3B,HoldOut3C);

//Hold block arranging the pixels in 3x3 matrix for presentation to the multiplier block
sobelHoldBlock #(.STARTADDRESS(STARTHOLD4),.ENDADDRESS(ENDHOLD4))
HolderBlock4(clk,HoldEn,reset,sobelShiftOutHold4A,sobelShiftOutHold4B,sobelShiftOutHold4C,HoldOut4A,HoldOut4B,HoldOut4C);

//Multiplies the 3x3 pixel matrix by the Sobel filter 5x5 matrix to output to accentuate rates of change
sobelMultBlock #(.STARTADDRESS(STARTHOLD1),.ENDADDRESS(ENDHOLD1))
sobelMultBlock1(clk,startMultiplierEn,reset,HoldOut1A,HoldOut1B,HoldOut1C,sobelX1,sobelY1);

sobelMultBlock #(.STARTADDRESS(STARTHOLD2),.ENDADDRESS(ENDHOLD2))
sobelMultBlock2(clk,startMultiplierEn,reset,HoldOut2A,HoldOut2B,HoldOut2C,sobelX2,sobelY2);

sobelMultBlock #(.STARTADDRESS(STARTHOLD3),.ENDADDRESS(ENDHOLD3))
sobelMultBlock3(clk,startMultiplierEn,reset,HoldOut3A,HoldOut3B,HoldOut3C,sobelX3,sobelY3);

sobelMultBlock #(.STARTADDRESS(STARTHOLD4),.ENDADDRESS(ENDHOLD4))
sobelMultBlock4(clk,startMultiplierEn,reset,HoldOut4A,HoldOut4B,HoldOut4C,sobelX4,sobelY4);

sobelMag #(.STARTADDRESS(STARTHOLD1),.ENDADDRESS(ENDHOLD1))
sobelMag1(clk,startMagEn,reset,sobelX1,sobelY1,normalisedMag1);

sobelMag #(.STARTADDRESS(STARTHOLD2),.ENDADDRESS(ENDHOLD2))
sobelMag2(clk,startMagEn,reset,sobelX2,sobelY2,normalisedMag2);

sobelMag #(.STARTADDRESS(STARTHOLD3),.ENDADDRESS(ENDHOLD3))
sobelMag3(clk,startMagEn,reset,sobelX3,sobelY3,normalisedMag3);

sobelMag #(.STARTADDRESS(STARTHOLD4),.ENDADDRESS(ENDHOLD4))
sobelMag4(clk,startMagEn,reset,sobelX4,sobelY4,normalisedMag4);

sobelDir #(.STARTADDRESS(STARTHOLD1),.ENDADDRESS(ENDHOLD1))
sobelDir1(clk,startDirEn,reset,sobelX1,sobelY1,dirE1);

sobelDir #(.STARTADDRESS(STARTHOLD2),.ENDADDRESS(ENDHOLD2))
sobelDir2(clk,startDirEn,reset,sobelX2,sobelY2,dirE2);

sobelDir #(.STARTADDRESS(STARTHOLD3),.ENDADDRESS(ENDHOLD3))
sobelDir3(clk,startDirEn,reset,sobelX3,sobelY3,dirE3);

sobelDir #(.STARTADDRESS(STARTHOLD4),.ENDADDRESS(ENDHOLD4))
sobelDir4(clk,startDirEn,reset,sobelX4,sobelY4,dirE4);

sobelOutBlock sobelOutBlockMag(clk,startMagEn,reset,normalisedMag1,normalisedMag2,normalisedMag3,normalisedMag4,data2,we2,write_addr2);

/*
//Block to normalize the output of the multiplier to an 8 bit (pixel value)
normalisingBlock #(.STARTADDRESS(STARTHOLD1),.ENDADDRESS(ENDHOLD1))
normalisingBlock1(clk,startNormalisingEn,reset,unNormalisedPixelValue1,normalisedByte1);

normalisingBlock #(.STARTADDRESS(STARTHOLD1),.ENDADDRESS(ENDHOLD1))
normalisingBlock2(clk,startNormalisingEn,reset,unNormalisedPixelValue2,normalisedByte2);

normalisedOutDataBlock normalisedOut(clk,normPutDataEn,reset,normalisedByte1,normalisedByte2,data2,we2,write_addr2);

*/

					
	always@(posedge clk)
     begin
		case (sobelSequence)
			INITCASE:
				begin
					if(startEn == 1)
						begin
							sobelSequence = CASE1;
						end
				end
			CASE1:
				begin

					if(sobelCount == 24'd2)
						begin
							popBufferEn = 1;
							sobelShiftEn = 0;
							startMultiplierEn = 0;
							startNormalisingEn = 0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
						end
						

					if(sobelCount == 24'd4)
						begin
							popBufferEn = 0;
							sobelShiftEn = 1;
							startMultiplierEn = 0;
							startNormalisingEn = 0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
						end
					
					if(sobelCount == 24'd6)
						begin
							popBufferEn = 0;
							sobelShiftEn = 0;
							startMultiplierEn = 1;
							startNormalisingEn = 0;
							normPutDataEn = 0;
							HoldEn = 1;
							normPutDataEn = 0;
						end
						
					if(sobelCount == 24'd8)
						begin
							popBufferEn = 0;
							sobelShiftEn = 0;
							startMultiplierEn = 0;
							startMagEn =1;
							startDirEn = 1;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
						end
					if(sobelCount == 24'd10)
						begin
							popBufferEn = 0;
							sobelShiftEn = 0;
							startMultiplierEn = 0;
							startMagEn =0;
							startDirEn = 0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
						end
						
					if(sobelCount == 24'd18)
						begin
							popBufferEn = 0;
							sobelShiftEn = 0;
							startMultiplierEn = 0;
							startNormalisingEn =0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
						end
					if(sobelCount == 24'd20)
						begin
							popBufferEn = 0;
							sobelShiftEn = 0;
							startMultiplierEn = 0;
							startNormalisingEn =0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
						end
						
					if(sobelCount == 24'd2200575)
						begin
							popBufferEn = 0;
							sobelShiftEn = 0;
							startMultiplierEn = 0;
							startNormalisingEn =0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
							getNext = 1;
							
						end
						
					if(sobelCount == 24'd2200577)//Can call next fill of SRAM1 without overlapping with current read... starts read when 4/5 of the image is read.
						begin
							popBufferEn = 0;
							sobelShiftEn = 0;
							startMultiplierEn = 0;
							startNormalisingEn =0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
							getNext = 0;
						end
					if(sobelCount == 24'd2621400)//Can call next fill of SRAM1 without overlapping with current read... starts read when 4/5 of the image is read.
						begin
							sobelSequence = INITCASE;		
						end
				end

				default:
					begin
						sobelSequence = INITCASE;
					end
			endcase
		end

	
	always@(posedge clk)
     begin
		if(reset == 1)
			begin
				getNext = 0;
				popBufferEn = 0;
				sobelShiftEn = 0;
				startMultiplierEn = 0;
				startNormalisingEn = 0;
				normPutDataEn = 0;
				HoldEn = 0;
				sobelSequence = INITCASE;
				sobelCount <= 0;
			end
	end
	
	always@(posedge clk)
     begin
		if(sobelSequence == CASE1)
			begin
				if (sobelCount[7:0] == 255)
					begin			
						sobelCount <= sobelCount+ 257;//Skips every second line...
					end
				else
					begin
						sobelCount <= sobelCount+ 1;
					end
			end
		else
			begin
				sobelCount <= 0;
			end			
	end 

endmodule
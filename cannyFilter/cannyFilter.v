`timescale 1ns/100ps

module cannyFilter(clk,reset,startEn,read_addr1,read_addr2,read_addr3,q1,,q2,q3,we1,we2,we3,write_addr3,data3,getNext);
input clk,reset,startEn;
input [19:0]read_addr1;
input [19:0]read_addr2;
input [19:0]read_addr3;
input [63:0]q1;
input [63:0]q2;
input [63:0]q3;
input we1,we2;

output we3,getNext;
output [19:0]write_addr3;
output [63:0]data3;
parameter STARTHOLD1 = 770,  ENDHOLD1 = (261758);//Start and stop address for four canny MAatrix
parameter STARTHOLD2 = 771,  ENDHOLD2 = (261259);
parameter STARTHOLD3 = 1026,  ENDHOLD3 = (262014);
parameter STARTHOLD4 = 1027,  ENDHOLD4= (262015);
parameter INITCASE = 0, CASE1 = 1; 
wire [63:0]data3;
wire startEn,clk,reset;
reg popBufferEn,HoldEn,cannyShiftEn,startMultiplierEn,startNormalisingEn,normPutDataEn,getNext,startMagEn,startDirEn,outEn;
reg [2:0]addressCase;
reg cannySequence;
wire [63:0]q1;
wire [63:0]q2;
wire [63:0]q3;

wire [19:0]read_addr1;
wire [19:0]read_addr2;
wire [19:0]read_addr3;

wire [7:0]cannyOutByte1;
wire [7:0]cannyOutByte2;
wire [7:0]cannyOutByte3;
wire [7:0]cannyOutByte4;


reg outStart;

reg [19:0]addresSchedule;
reg [23:0]cannyCount; 
wire [19:0]write_addr1;
wire [19:0]write_addr2;
wire [19:0]write_addr3;

wire [63:0]BufferA;
wire [63:0]BufferB;
wire [63:0]BufferC;
wire [63:0]BufferD;
wire [31:0]cannyShiftOutA;
wire [31:0]cannyShiftOutB;
wire [31:0]cannyShiftOutC;
wire [31:0]cannyShiftOutD;

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

///////////////////
wire [63:0]BufferDirA;
wire [63:0]BufferDirB;
wire [63:0]BufferDirC;
wire [63:0]BufferDirD;
wire [31:0]cannyShiftOutDirA;
wire [31:0]cannyShiftOutDirB;
wire [31:0]cannyShiftOutDirC;
wire [31:0]cannyShiftOutDirD;

wire [23:0]HoldOut1DirA;
wire [23:0]HoldOut1DirB;
wire [23:0]HoldOut1DirC;

wire [23:0]HoldOut2DirA;
wire [23:0]HoldOut2DirB;
wire [23:0]HoldOut2DirC;

wire [23:0]HoldOut3DirA;
wire [23:0]HoldOut3DirB;
wire [23:0]HoldOut3DirC;

wire [23:0]HoldOut4DirA;
wire [23:0]HoldOut4DirB;
wire [23:0]HoldOut4DirC;

///////////////////


wire [23:0]cannyShiftOutHold1A;
wire [23:0]cannyShiftOutHold1B;
wire [23:0]cannyShiftOutHold1C;


wire [23:0]cannyShiftOutHold2A;
wire [23:0]cannyShiftOutHold2B;
wire [23:0]cannyShiftOutHold2C;

wire [23:0]cannyShiftOutHold3A;
wire [23:0]cannyShiftOutHold3B;
wire [23:0]cannyShiftOutHold3C;

wire [23:0]cannyShiftOutHold4A;
wire [23:0]cannyShiftOutHold4B;
wire [23:0]cannyShiftOutHold4C;

wire [23:0]cannyShiftOutHold1DirA;
wire [23:0]cannyShiftOutHold1DirB;
wire [23:0]cannyShiftOutHold1DirC;


wire [23:0]cannyShiftOutHold2DirA;
wire [23:0]cannyShiftOutHold2DirB;
wire [23:0]cannyShiftOutHold2DirC;

wire [23:0]cannyShiftOutHold3DirA;
wire [23:0]cannyShiftOutHold3DirB;
wire [23:0]cannyShiftOutHold3DirC;


wire [23:0]cannyShiftOutHold4DirA;
wire [23:0]cannyShiftOutHold4DirB;
wire [23:0]cannyShiftOutHold4DirC;

wire we2;

assign cannyShiftOutHold1A = cannyShiftOutA[31:8];
assign cannyShiftOutHold1B = cannyShiftOutB[31:8];
assign cannyShiftOutHold1C = cannyShiftOutC[31:8];


assign cannyShiftOutHold2A = cannyShiftOutA[23:0];
assign cannyShiftOutHold2B = cannyShiftOutB[23:0];
assign cannyShiftOutHold2C = cannyShiftOutC[23:0];

assign cannyShiftOutHold3A = cannyShiftOutB[31:8];
assign cannyShiftOutHold3B = cannyShiftOutC[31:8];
assign cannyShiftOutHold3C = cannyShiftOutD[31:8];


assign cannyShiftOutHold4A = cannyShiftOutB[23:0];
assign cannyShiftOutHold4B = cannyShiftOutC[23:0];
assign cannyShiftOutHold4C = cannyShiftOutD[23:0];

assign cannyShiftOutHold1DirA = cannyShiftOutDirA[31:8];
assign cannyShiftOutHold1DirB = cannyShiftOutDirB[31:8];
assign cannyShiftOutHold1DirC = cannyShiftOutDirC[31:8];


assign cannyShiftOutHold2DirA = cannyShiftOutDirA[23:0];
assign cannyShiftOutHold2DirB = cannyShiftOutDirB[23:0];
assign cannyShiftOutHold2DirC = cannyShiftOutDirC[23:0];

assign cannyShiftOutHold3DirA = cannyShiftOutDirB[31:8];
assign cannyShiftOutHold3DirB = cannyShiftOutDirC[31:8];
assign cannyShiftOutHold3DirC = cannyShiftOutDirD[31:8];


assign cannyShiftOutHold4DirA = cannyShiftOutDirB[23:0];
assign cannyShiftOutHold4DirB = cannyShiftOutDirC[23:0];
assign cannyShiftOutHold4DirC = cannyShiftOutDirD[23:0];


//Ram memory blocks (Simulated)

//simple_ram_dual_clock  SRAM1(data1,read_addr1,write_addr1,we1,clk, clk,q1);
//simple_ram_dual_clock  SRAM2(data2,read_addr2,write_addr2,we2,clk, clk,q2);


//Buffer block used to store 4 of the 5 4 bit registers to prepare them for the shifter block.

cannyBufferBlock cannyBufferBlock(clk,popBufferEn,reset,q1,BufferA,BufferB,BufferC,BufferD);

//Shifter block to shift through 5x128 bit registers 16 bits at a time to populate the two hold blocks
cannyShifterBlock ShifterBlock(clk,cannyShiftEn,reset,BufferA,BufferB,BufferC,BufferD,cannyShiftOutA,cannyShiftOutB,cannyShiftOutC,cannyShiftOutD);

//cannyShifterBlock	ShifterBlock(clk,cannyShiftEn,reset,A,B,C,D,cannyShiftOutA,cannyShiftOutB,cannyShiftOutC,cannyShiftOutD);
//Hold block arranging the pixels in 3x3 matrix for presentation to the multiplier block
cannyHoldBlock #(.STARTADDRESS(STARTHOLD1),.ENDADDRESS(ENDHOLD1))
HolderBlock1(clk,HoldEn,reset,cannyShiftOutHold1A,cannyShiftOutHold1B,cannyShiftOutHold1C,HoldOut1A,HoldOut1B,HoldOut1C);
cannyHoldBlock #(.STARTADDRESS(STARTHOLD1),.ENDADDRESS(ENDHOLD1))
HolderBlockDir1(clk,HoldEn,reset,cannyShiftOutHold1DirA,cannyShiftOutHold1DirB,cannyShiftOutHold1DirC,HoldOut1DirA,HoldOut1DirB,HoldOut1DirC);

//Hold block arranging the pixels in 3x3 matrix for presentation to the multiplier block
cannyHoldBlock #(.STARTADDRESS(STARTHOLD2),.ENDADDRESS(ENDHOLD2))
HolderBlock2(clk,HoldEn,reset,cannyShiftOutHold2A,cannyShiftOutHold2B,cannyShiftOutHold2C,HoldOut2A,HoldOut2B,HoldOut2C);

cannyHoldBlock #(.STARTADDRESS(STARTHOLD2),.ENDADDRESS(ENDHOLD2))
HolderBlockDir2(clk,HoldEn,reset,cannyShiftOutHold2DirA,cannyShiftOutHold2DirB,cannyShiftOutHold2DirC,HoldOut2DirA,HoldOut2DirB,HoldOut2DirC);

//Hold block arranging the pixels in 3x3 matrix for presentation to the multiplier block
cannyHoldBlock #(.STARTADDRESS(STARTHOLD3),.ENDADDRESS(ENDHOLD3))
HolderBlock3(clk,HoldEn,reset,cannyShiftOutHold3A,cannyShiftOutHold3B,cannyShiftOutHold3C,HoldOut3A,HoldOut3B,HoldOut3C);

cannyHoldBlock #(.STARTADDRESS(STARTHOLD3),.ENDADDRESS(ENDHOLD3))
HolderBlockDir3(clk,HoldEn,reset,cannyShiftOutHold3DirA,cannyShiftOutHold3DirB,cannyShiftOutHold3DirC,HoldOut3DirA,HoldOut3DirB,HoldOut3DirC);
//Hold block arranging the pixels in 3x3 matrix for presentation to the multiplier block
cannyHoldBlock #(.STARTADDRESS(STARTHOLD4),.ENDADDRESS(ENDHOLD4))
HolderBlock4(clk,HoldEn,reset,cannyShiftOutHold4A,cannyShiftOutHold4B,cannyShiftOutHold4C,HoldOut4A,HoldOut4B,HoldOut4C);

cannyHoldBlock #(.STARTADDRESS(STARTHOLD4),.ENDADDRESS(ENDHOLD4))
HolderBlockDir4(clk,HoldEn,reset,cannyShiftOutHold4DirA,cannyShiftOutHold4DirB,cannyShiftOutHold4DirC,HoldOut4A,HoldOut4B,HoldOut4C);
//Multiplies the 3x3 pixel matrix by the canny filter 5x5 matrix to output to accentuate rates of change

cannyMultBlock #(.STARTADDRESS(STARTHOLD1),.ENDADDRESS(ENDHOLD1))
cannyMultBlock1(clk,startMultiplierEn,reset,HoldOut1A,HoldOut1B,HoldOut1C,HoldOut1DirB,cannyOutByte1);

cannyMultBlock #(.STARTADDRESS(STARTHOLD2),.ENDADDRESS(ENDHOLD2))
cannyMultBlock2(clk,startMultiplierEn,reset,HoldOut2A,HoldOut2B,HoldOut2C,HoldOut2DirB,cannyOutByte2);

cannyMultBlock #(.STARTADDRESS(STARTHOLD3),.ENDADDRESS(ENDHOLD3))
cannyMultBlock3(clk,startMultiplierEn,reset,HoldOut3A,HoldOut3B,HoldOut3C,HoldOut3DirB,cannyOutByte3);

cannyMultBlock #(.STARTADDRESS(STARTHOLD4),.ENDADDRESS(ENDHOLD4))
cannyMultBlock4(clk,startMultiplierEn,reset,HoldOut4A,HoldOut4B,HoldOut4C,HoldOut4DirB,cannyOutByte4);

cannyOutBlock cannyOutBlockMag(clk,outEn,reset,cannyOutByte1,cannyOutByte2,cannyOutByte3,cannyOutByte4,data3,we3,write_addr3);


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
		case (cannySequence)
			INITCASE:
				begin
					if(startEn == 1)
						begin
							cannySequence = CASE1;
						end
				end
			CASE1:
				begin

					if(cannyCount == 24'd2)
						begin
							popBufferEn = 1;
							cannyShiftEn = 0;
							startMultiplierEn = 0;
							startNormalisingEn = 0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
							outEn = 0;
							startDirEn = 0;
							startMagEn = 0;
						end
						

					if(cannyCount == 24'd4)
						begin
							popBufferEn = 0;
							cannyShiftEn = 1;
							startMultiplierEn = 0;
							startNormalisingEn = 0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
						end
						
					if(cannyCount == 24'd6)
						begin
							popBufferEn = 0;
							cannyShiftEn = 0;
							startMultiplierEn = 0;
							startNormalisingEn = 0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
						end
					
					if(cannyCount == 24'd13)
						begin
							popBufferEn = 0;
							cannyShiftEn = 1;
							startMultiplierEn = 0;
							startNormalisingEn = 0;
							normPutDataEn = 0;
							HoldEn = 1;
							normPutDataEn = 0;
						end
						
					if(cannyCount == 24'd14)
						begin
							popBufferEn = 0;
							cannyShiftEn = 0;
							startMultiplierEn = 1;
							startNormalisingEn = 0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
						end
						
					if(cannyCount == 24'd15)
						begin
							popBufferEn = 0;
							cannyShiftEn = 0;
							startMagEn = 1;
							startDirEn = 1;
							//startMultiplierEn = 0;
							startNormalisingEn = 0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
						end
					
					if(cannyCount == 24'd16)
						begin
							popBufferEn = 0;
							cannyShiftEn = 0;
							//startMagEn = 1;
							//startDirEn = 1;
							startMultiplierEn = 0;
							startNormalisingEn = 0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
						end
						
					if(cannyCount == 24'd17)
						begin
							popBufferEn = 0;
							cannyShiftEn = 0;
							startMagEn = 0;
							startDirEn = 0;
							startMultiplierEn = 0;
							startNormalisingEn = 0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
						end						
						
					if(cannyCount == 24'd18)
						begin
							popBufferEn = 0;
							cannyShiftEn = 0;
							startMultiplierEn = 0;
							startMagEn = 0;
							startDirEn = 0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
							outEn = 1;
						end
						
					if(cannyCount == 24'd22)
						begin
							popBufferEn = 0;
							cannyShiftEn = 0;
							startMultiplierEn = 0;
							startMagEn = 0;
							startDirEn = 0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
							outEn = 0;
						end
						

					if(cannyCount == 24'd23)
						begin
							popBufferEn = 0;
							cannyShiftEn = 0;
							startMultiplierEn = 0;
							startMagEn =0;
							startDirEn = 0;
							normPutDataEn = 1;
							HoldEn = 0;
						end
						

					if(cannyCount == 24'd25)
						begin
							popBufferEn = 0;
							cannyShiftEn = 0;
							startMultiplierEn = 0;
							startNormalisingEn =0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
						end
						
					if(cannyCount == 24'd2200575)
						begin
							popBufferEn = 0;
							cannyShiftEn = 0;
							startMultiplierEn = 0;
							startNormalisingEn =0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
							getNext = 1;
							
						end
						
					if(cannyCount == 24'd2200577)//Can call next fill of SRAM1 without overlapping with current read... starts read when 4/5 of the image is read.
						begin
							popBufferEn = 0;
							cannyShiftEn = 0;
							startMultiplierEn = 0;
							startNormalisingEn =0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
							getNext = 0;
						end
					if(cannyCount == 24'd2621400)//Can call next fill of SRAM1 without overlapping with current read... starts read when 4/5 of the image is read.
						begin
							cannySequence = INITCASE;		
						end
				end

				default:
					begin
						cannySequence = INITCASE;
					end
			endcase
		end

	
	always@(posedge clk)
     begin
		if(reset == 1)
			begin
				getNext = 0;
				popBufferEn = 0;
				cannyShiftEn = 0;
				startMultiplierEn = 0;
				startNormalisingEn = 0;
				normPutDataEn = 0;
				HoldEn = 0;
				cannySequence = INITCASE;
				cannyCount <= 0;
				
			end
	end
	
	always@(posedge clk)
     begin
		if((outEn == 1) || (outStart == 1))
			begin
				outStart = 1;
			end
	end	
	
	always@(posedge clk)
     begin
		if(cannySequence == CASE1)
			begin
				if (cannyCount[7:0] == 255)
					begin			
						cannyCount <= cannyCount+ 257;//Skips every second line...
					end
				else
					begin
						cannyCount <= cannyCount+ 1;
					end
			end
		else
			begin
				cannyCount <= 0;
			end			
	end 

endmodule
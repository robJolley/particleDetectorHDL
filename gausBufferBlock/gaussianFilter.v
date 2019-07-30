`timescale 1ns/100ps

module gaussianFilter(clk,reset,startEn,read_addr1,q1,we2,write_addr2,data2,getNext);
input clk,reset,startEn;
input [19:0]read_addr1;
input [63:0]q1;
output we2,getNext;
output [19:0]write_addr2;
output [63:0]data2;
parameter STARTHOLD1 = 770,  ENDHOLD1 = (523517);
parameter STARTHOLD2 = 771,  ENDHOLD2 = (523518);
parameter INITCASE = 0, CASE1 = 1; 
wire [63:0]data1;
wire [63:0]data2;
wire startEn,clk,reset;
reg popBufferEn,HoldEn,gausShiftEn,startMultiplierEn,startNormalisingEn,normPutDataEn,getNext;
reg [2:0]addressCase;
reg gausSequence;
wire [63:0]q1;
wire [63:0]q2;
wire [19:0]read_addr1;
reg [19:0]read_addr2;
reg [19:0]addresSchedule;
reg [23:0]gaussCount; 
wire [19:0]write_addr1;
wire [19:0]write_addr2;
wire [63:0]BufferA;
wire [63:0]BufferB;
wire [63:0]BufferC;
wire [63:0]BufferD;
wire [47:0]gausShiftOutA;
wire [47:0]gausShiftOutB;
wire [47:0]gausShiftOutC;
wire [47:0]gausShiftOutD;
wire [47:0]gausShiftOutE;

wire [39:0]HoldOut1A;
wire [39:0]HoldOut1B;
wire [39:0]HoldOut1C;
wire [39:0]HoldOut1D;
wire [39:0]HoldOut1E;
wire [39:0]HoldOut2A;
wire [39:0]HoldOut2B;
wire [39:0]HoldOut2C;
wire [39:0]HoldOut2D;
wire [39:0]HoldOut2E;

wire [39:0]gausShiftOutHold1A;
wire [39:0]gausShiftOutHold1B;
wire [39:0]gausShiftOutHold1C;
wire [39:0]gausShiftOutHold1D;
wire [39:0]gausShiftOutHold1E;

wire [39:0]gausShiftOutHold2A;
wire [39:0]gausShiftOutHold2B;
wire [39:0]gausShiftOutHold2C;
wire [39:0]gausShiftOutHold2D;
wire [39:0]gausShiftOutHold2E;
wire [17:0]unNormalisedPixelValue1;
wire [17:0]unNormalisedPixelValue2;
wire [7:0]normalisedByte1;
wire [7:0]normalisedByte2;
wire we2;



assign gausShiftOutHold1A = gausShiftOutA[47:8];
assign gausShiftOutHold1B = gausShiftOutB[47:8];
assign gausShiftOutHold1C = gausShiftOutC[47:8];
assign gausShiftOutHold1D = gausShiftOutD[47:8];
assign gausShiftOutHold1E = gausShiftOutE[47:8];

assign gausShiftOutHold2A = gausShiftOutA[39:0];
assign gausShiftOutHold2B = gausShiftOutB[39:0];
assign gausShiftOutHold2C = gausShiftOutC[39:0];
assign gausShiftOutHold2D = gausShiftOutD[39:0];
assign gausShiftOutHold2E = gausShiftOutE[39:0];

//Ram memory blocks (Simulated)

//simple_ram_dual_clock  SRAM1(data1,read_addr1,write_addr1,we1,clk, clk,q1);
//simple_ram_dual_clock  SRAM2(data2,read_addr2,write_addr2,we2,clk, clk,q2);


//Buffer block used to store 4 of the 5 4 bit registers to prepare them for the shifter block.

BufferBlock  gausBufferBlock(clk,popBufferEn,reset,q1,BufferA,BufferB,BufferC,BufferD);

//Shifter block to shift through 5x128 bit registers 16 bits at a time to populate the two hold blocks
ShifterBlock gausShifterBlock(clk,gausShiftEn,reset,q1,BufferA,BufferB,BufferC,BufferD,gausShiftOutA,gausShiftOutB,gausShiftOutC,gausShiftOutD,gausShiftOutE);

//Hold block arranging the pixels in 5x5 matrix for presentation to the multiplier block
HoldBlock #(.STARTADDRESS(STARTHOLD1),.ENDADDRESS(ENDHOLD1))
HolderBlock1(clk,HoldEn,reset,gausShiftOutHold1A,gausShiftOutHold1B,gausShiftOutHold1C,gausShiftOutHold1D,gausShiftOutHold1E,HoldOut1A,HoldOut1B,HoldOut1C,HoldOut1D,HoldOut1E);

HoldBlock #(.STARTADDRESS(STARTHOLD2),.ENDADDRESS(ENDHOLD2))
HolderBlock2(clk,HoldEn,reset,gausShiftOutHold2A,gausShiftOutHold2B,gausShiftOutHold2C,gausShiftOutHold2D,gausShiftOutHold2E,HoldOut2A,HoldOut2B,HoldOut2C,HoldOut2D,HoldOut2E);
//Multiplies the 5x5 pixel matrix by the Gaussian 5x5 matrix to output smoothed pixel value (unnormalized)
multiplierBlock #(.STARTADDRESS(STARTHOLD1),.ENDADDRESS(ENDHOLD1))
multiplierBlock1(clk,startMultiplierEn,reset,HoldOut1A,HoldOut1B,HoldOut1C,HoldOut1D,HoldOut1E,unNormalisedPixelValue1);

multiplierBlock #(.STARTADDRESS(STARTHOLD2),.ENDADDRESS(ENDHOLD2))
multiplierBlock2(clk,startMultiplierEn,reset,HoldOut2A,HoldOut2B,HoldOut2C,HoldOut2D,HoldOut2E,unNormalisedPixelValue2);
//Block to normalize the output of the multiplier to an 8 bit (pixel value)
normalisingBlock #(.STARTADDRESS(STARTHOLD1),.ENDADDRESS(ENDHOLD1))
normalisingBlock1(clk,startNormalisingEn,reset,unNormalisedPixelValue1,normalisedByte1);

normalisingBlock #(.STARTADDRESS(STARTHOLD1),.ENDADDRESS(ENDHOLD1))
normalisingBlock2(clk,startNormalisingEn,reset,unNormalisedPixelValue2,normalisedByte2);

normalisedOutDataBlock normalisedOut(clk,normPutDataEn,reset,normalisedByte1,normalisedByte2,data2,we2,write_addr2);



					
	always@(posedge clk)
     begin
		case (gausSequence)
			INITCASE:
				begin
					if(startEn == 1)
						begin
							gausSequence = CASE1;
						end
				end
			CASE1:
				begin
					if(gaussCount == 24'd1)
						begin
							popBufferEn = 1;
							gausShiftEn = 0;
							startMultiplierEn = 0;
							startNormalisingEn =0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
						end
					if(gaussCount == 24'd3)
						begin
							popBufferEn = 0;
							gausShiftEn = 1;
							startMultiplierEn = 1;
							startNormalisingEn = 1;
							normPutDataEn = 0;
							HoldEn = 1;
							normPutDataEn = 0;
						end
					if(gaussCount == 24'd5)
						begin
							popBufferEn = 0;
							gausShiftEn = 0;
							startMultiplierEn = 0;
							startNormalisingEn =0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
						end
						
					if(gaussCount == 24'd18)
						begin
							popBufferEn = 0;
							gausShiftEn = 0;
							startMultiplierEn = 0;
							startNormalisingEn =0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 1;
						end
					if(gaussCount == 24'd20)
						begin
							popBufferEn = 0;
							gausShiftEn = 0;
							startMultiplierEn = 0;
							startNormalisingEn =0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
						end
						
					if(gaussCount == 24'd2200575)
						begin
							popBufferEn = 0;
							gausShiftEn = 0;
							startMultiplierEn = 0;
							startNormalisingEn =0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
							getNext = 1;
							
						end
						
					if(gaussCount == 24'd2200577)//Can call next fill of SRAM1 without overlapping with current read... starts read when 4/5 of the image is read.
						begin
							popBufferEn = 0;
							gausShiftEn = 0;
							startMultiplierEn = 0;
							startNormalisingEn =0;
							normPutDataEn = 0;
							HoldEn = 0;
							normPutDataEn = 0;
							getNext = 0;
						end
					if(gaussCount == 24'd2621400)//Can call next fill of SRAM1 without overlapping with current read... starts read when 4/5 of the image is read.
						begin
							gausSequence = INITCASE;		
						end
				end

				default:
					begin
						gausSequence = INITCASE;
					end
			endcase
		end

	
	always@(posedge clk)
     begin
		if(reset == 1)
			begin
				getNext = 0;
				popBufferEn = 0;
				gausShiftEn = 0;
				startMultiplierEn = 0;
				startNormalisingEn =0;
				normPutDataEn = 0;
				HoldEn = 0;
				gausSequence = INITCASE;
				gaussCount <= 0;
			end
	end
	
	always@(posedge clk)
     begin
		if(gausSequence == CASE1)
			begin
				gaussCount <= gaussCount+ 1;
			end
		else
			begin
				gaussCount <= 0;
			end			
	end 

endmodule
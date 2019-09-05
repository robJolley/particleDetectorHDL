`timescale 1ns/100ps

module BufferBlockTB();
parameter STARTHOLD1 = 770,  ENDHOLD1 = (523517);
parameter STARTHOLD2 = 771,  ENDHOLD2 = (523518);
parameter C0 = 3'b000, C1 = 3'b001, C2 = 3'b010, C3 = 3'b011, C4 = 3'b100; 
wire [63:0]data1;
wire [63:0]data2;
reg clk,we1,popBufferEn,HoldEn,reset,gausShiftEn,startMultiplierEn,startNormalisingEn,normPutDataEn;
reg [2:0]addressCase;
wire [63:0]q1;
wire [63:0]q2;
wire[63:0]BufferA;
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


reg [19:0]read_addr1;
reg [19:0]read_addr2;
reg [19:0]addresSchedule;
wire [19:0]write_addr1;
wire [19:0]write_addr2;

//Ram memory blocks (Simulated)

simple_ram_dual_clock  SRAM1(data1,read_addr1,write_addr1,we1,clk, clk,q1);
simple_ram_dual_clock  SRAM2(data2,read_addr2,write_addr2,we2,clk, clk,q2);


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

initial
	begin
		$readmemh("C:/hexfiles/outSRAM2.hex", SRAM1.ram);  
		$display("ramValue:",SRAM1.ram[0]);
/*		
		SRAM1.ram[0+128] <= 64'h00000000FFFFFFFF;
		SRAM1.ram[256+128] <= 64'h00000000FFFFFFFF;
		SRAM1.ram[512+128] <= 64'h00000000FFFFFFFF;
		SRAM1.ram[768+128] <= 64'h00000000FFFFFFFF;
		SRAM1.ram[1024+128] <= 64'h00000000FFFFFFFF;
		SRAM1.ram[0+129] <= 64'h00000000FFFFFFFF;
		SRAM1.ram[256+129] <= 64'h00000000FFFFFFFF;
		SRAM1.ram[512+129] <= 64'h00000000FFFFFFFF;
		SRAM1.ram[768+129] <= 64'h00000000FFFFFFFF;
		SRAM1.ram[1024+129] <= 64'h00000000FFFFFFFF;
		SRAM1.ram[0+130] <= 64'h00000000FFFFFFFF;
		SRAM1.ram[256+130] <= 64'h00000000FFFFFFFF;
		SRAM1.ram[512+130] <= 64'h00000000FFFFFFFF;
		SRAM1.ram[768+130] <= 64'h00000000FFFFFFFF;
		SRAM1.ram[1024+130] <= 64'h00000000FFFFFFFF;			
*/
		clk = 0;
		reset = 1;
		addressCase = C0;
		addresSchedule = 1024;
		#10;
		reset = 0;
		#10;
		popBufferEn = 1;
		#10;
		popBufferEn = 0;
		gausShiftEn = 1;
		startMultiplierEn = 1;
		startNormalisingEn = 1;
		HoldEn = 1;
		#10;
		popBufferEn = 0;
		gausShiftEn = 0;
		startMultiplierEn = 0;
		startNormalisingEn = 0;
		HoldEn = 0;
		#140
		normPutDataEn = 1;
		#10
		normPutDataEn = 0;
		#1000;


		#15000000;
		$writememh("C:/hexfiles/outSRAM3.hex", SRAM2.ram);
//		$writememh("C:/hexfiles/outSRAM3.hex", SRAM1.ram);
		$display("ramValue:",SRAM2.ram[0]);
		$stop;
		$finish;
	end
	always@(posedge clk)


		begin
			case(addressCase)
				C0:
					begin
						read_addr1 <= addresSchedule;
						addressCase <= C1;
					end
				C1:
					begin
						read_addr1 <= addresSchedule-256;
						addressCase <= C2;
					end
					
				C2:
					begin
						read_addr1 <= addresSchedule -(256*2);
						addressCase <= C3;
					end
				C3:
					begin
						read_addr1 <= addresSchedule -(256*3);
						addressCase <= C4;
					end
				C4:
					begin
						read_addr1 <= addresSchedule -(256*4);
						addresSchedule++;
						addressCase <= C0;
					end
			endcase
		end
					
					
//			for(addresSchedule = 1280; addresSchedule <= 50000; addresSchedule++ )
//				begin
//					read_addr1 = addresSchedule;
//					#10;
//					read_addr1 = addresSchedule-256;
//					#10;
//					//read_addr1 <= addresSchedule -(256*2);
//					#10;
//					read_addr1 = addresSchedule -(256*3);
//					#10;
//					read_addr1 = addresSchedule -(256*4);
//					#10;				
//				end


	
	always@(posedge clk)
     begin
		if(reset == 1)
			begin
				read_addr1 = 1024;
				addresSchedule = 1024;
				addressCase = C0;
			end
	end
	
	always
     begin
        clk = #5 !clk;//100mHz clock
     end
	 
	initial
		begin
			$dumpfile("bufferBlockTest1.vcd");
			$dumpvars(0,BufferBlockTB);
		end
endmodule
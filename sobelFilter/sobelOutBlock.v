module sobelOutBlock(clk,normPutDataEn,reset,normalisedByte1,normalisedByte2,normalisedByte3,normalisedByte4,outData,we,wraddr);

parameter STARTADDRESS = 0,  ENDADDRESS = 524288,BEATS = 4, PAUSE = 1,COUNTSTEPHOLD = 2, PIXELCOUNT = 24;//address starts in and down two pixels ends the same.  parameter can be imported to accommodate second concurrent pixel 
parameter 	COUNT0 = 3'b000,COUNT1 = 3'b001, COUNT2 = 3'b010, COUNT3 = 3'b011;//States for state machine

input clk,normPutDataEn,reset;
input [7:0]normalisedByte1;
input [7:0]normalisedByte2;
input [7:0]normalisedByte3;
input [7:0]normalisedByte4;
output [63:0]outData;
output we;
output [19:0]wraddr;
wire clk,normPutDataEn,started,process,reset;
wire [23:0]pixelCounter;
wire [7:0]normalisedByte1;
wire [7:0]normalisedByte2;
wire [7:0]normalisedByte3;
wire [7:0]normalisedByte4;
wire nclk;
reg [63:0]outData;
reg [63:0]out1DataHold;
reg [63:0]out1DataHold1;
reg [63:0]out2DataHold;
reg [63:0]out2DataHold1;
reg [2:0]dataSched;
reg we;
reg [19:0]wraddr;
reg [19:0]currentAddress;
reg startOutput;


assign nclk = !clk;



beatCounter
	#(.MINPIXEL(STARTADDRESS),.MAXPIXEL(ENDADDRESS),.BEATS(BEATS),.PAUSE(PAUSE),.COUNTSTEP(COUNTSTEPHOLD),.PIXELCOUNTERWIDTH(PIXELCOUNT)
	) bufferCounterBlock(clk,normPutDataEn,reset,process,started,pixelCounter);


always@(posedge nclk)
	begin
		if (started == 1)
			begin
				case(dataSched)
					COUNT0:
						begin
							out1DataHold[55:48] <=normalisedByte4;
							out1DataHold[63:56] <=normalisedByte3;
							out2DataHold[55:48] <=normalisedByte2;
							out2DataHold[63:56] <=normalisedByte1;
					//	out1DataHold[55:48] <=255;
					//	out1DataHold[63:56] <=255;
					//	out2DataHold[55:48] <=255;
					//	out2DataHold[63:56] <=255;
				//		dataSched <=COUNT1;
					//	$display("Count0");
						end
					
					COUNT1:
						begin
							out1DataHold[39:32] <= normalisedByte4;
							out1DataHold[47:40] <= normalisedByte3;
							out2DataHold[39:32] <= normalisedByte2;
							out2DataHold[47:40] <= normalisedByte1;
					//	dataSched <=COUNT2;
					//	$display("Count1");
						end
					
					COUNT2:
						begin
							out1DataHold[23:16] <= normalisedByte4;
							out1DataHold[31:24] <= normalisedByte3;
							out2DataHold[23:16] <= normalisedByte2;
							out2DataHold[31:24] <= normalisedByte1;
			//			dataSched <=COUNT3;
			//			startOutput <= 1;
					//	$display("Count2");
						end

					COUNT3:
						begin
							out1DataHold1[7:0] <= normalisedByte4;
							out1DataHold1[15:8] <= normalisedByte3;
							out2DataHold1[7:0] <= normalisedByte2;
							out2DataHold1[15:8] <= normalisedByte1;
							out2DataHold1[63:16] <=out2DataHold[63:16];
							out1DataHold1[63:16] <=out1DataHold[63:16];
							startOutput <= 1;
			//			dataSched <=COUNT0;
					//	$display("Count3");

						end
			//	default:dataSched <= COUNT0;
				endcase
			end
		end
		
always@(posedge clk)
	begin
		if (started == 1)
			begin
				case(dataSched)
					COUNT0:
						begin

							dataSched <=COUNT1;
						end
					COUNT1:
						begin

							dataSched <= COUNT2;
						//	$display("Count1");
						end

					COUNT2:
						begin
							dataSched <= COUNT3;
						//	$display("Count3");

						end
					COUNT3:
						begin

							dataSched <= COUNT0;
						//	$display("Count1");
						end
					default:dataSched <= COUNT0;
				endcase
			end
		end
				
always@(posedge clk)
	if(reset == 1)
		begin
			dataSched <= COUNT0;
			currentAddress <= STARTADDRESS;//**** Was STARTADDRESS - 1
			startOutput <= 0;
//			wraddr <= STARTADDRESS;
		end		
always@(posedge clk)//Control to output to SRAM,  64 bit is output every two clock ticks (8 pixels) 
// the second output is to the pixels below first,  when the end of the image row is reached the address jumps 256 places so that two 
//rows are addressed simultaneously and not overwritten

	if(started && startOutput)
		begin
			if(dataSched == COUNT3)
				begin
					wraddr <=currentAddress;

					we <= 0;
				end
			if(dataSched == COUNT0)
				begin

					wraddr <=currentAddress;

					outData <= out1DataHold1;
					we <= 1;
				end
				
			if(dataSched == COUNT1)
				begin
					wraddr <= currentAddress+256;
					we <= 0;
				end
			if(dataSched == COUNT2)
				begin
					we <= 1;

					if (currentAddress[7:0] == 255)
						begin
							currentAddress <= currentAddress + 257;
						end
					else
						begin
							currentAddress <= currentAddress +1;
						end
					outData <= out2DataHold1;
					we <= 1;
				end	
		end	
	

endmodule			
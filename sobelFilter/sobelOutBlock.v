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
reg [63:0]outData;
reg [63:0]out1DataHold;
reg [63:0]out2DataHold;
reg [63:0]out2DataHold1;
reg [63:0]out2DataHold2;
reg [2:0]dataSched;
reg we;
reg [19:0]wraddr;
reg [19:0]currentAddress;
reg startOutput;






beatCounter
	#(.MINPIXEL(STARTADDRESS),.MAXPIXEL(ENDADDRESS),.BEATS(BEATS),.PAUSE(PAUSE),.COUNTSTEP(COUNTSTEPHOLD),.PIXELCOUNTERWIDTH(PIXELCOUNT)
	) bufferCounterBlock(clk,normPutDataEn,reset,process,started,pixelCounter);


always@(posedge clk)
	begin
		if (started == 1)
			case(dataSched)
				COUNT3:
					begin
						out1DataHold[7:0] <= normalisedByte2;
						out1DataHold[15:8] <= normalisedByte1;
						out2DataHold[7:0] <= normalisedByte4;
						out2DataHold[15:8] <= normalisedByte3;
						dataSched <=COUNT0;
						startOutput <= 1;
					end
				COUNT2:
					begin
						out1DataHold[23:16] <= normalisedByte2;
						out1DataHold[31:24] <= normalisedByte1;
						out2DataHold[23:16] <= normalisedByte4;
						out2DataHold[31:24] <= normalisedByte3;
						dataSched <=COUNT3;
					end
				COUNT1:
					begin
						out1DataHold[39:32] <= normalisedByte2;
						out1DataHold[47:40] <= normalisedByte1;
						out2DataHold[39:32] <= normalisedByte4;
						out2DataHold[47:40] <= normalisedByte3;
						dataSched <=COUNT2;
					end
				COUNT0:
					begin
						out1DataHold[55:48] <=normalisedByte2;
						out1DataHold[63:56] <=normalisedByte1;
						out2DataHold[55:48] <=normalisedByte4;
						out2DataHold[63:56] <=normalisedByte3;
						dataSched <=COUNT1;
					end
				default:dataSched <= COUNT0;
			endcase
		end
				
always@(posedge clk)
	if(reset == 1)
		begin
			dataSched <= COUNT0;
			currentAddress <= STARTADDRESS-1;
			startOutput <= 0;
		end		
always@(posedge clk)
	if(started && startOutput)
		begin
			if(dataSched == COUNT3)
				begin
					outData <= out2DataHold1;
					wraddr <=currentAddress;
					out2DataHold1 <= out2DataHold;
					we <= 0;
				end
			if(dataSched == COUNT0)
				begin
					out2DataHold2 <= out2DataHold1;
					we <= 1;
				end
				
			if(dataSched == COUNT1)
				begin
					outData <= out2DataHold2;
					wraddr <= currentAddress+256;
					we <= 0;
				end
			if(dataSched == COUNT2)
				begin
					we <= 1;
					currentAddress <= currentAddress +1;
				end	
		end	
	

endmodule			
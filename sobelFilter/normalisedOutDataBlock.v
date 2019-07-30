module normalisedOutDataBlock(clk,normPutDataEn,reset,normalisedByte1,normalisedByte2,outData,we,wraddr);

parameter STARTADDRESS = 0,  ENDADDRESS = 524288,BEATS = 4, PAUSE = 1,COUNTSTEPHOLD = 2, PIXELCOUNT = 24;//address starts in and down two pixels ends the same.  parameter can be imported to accommodate second concurrent pixel 
parameter 	COUNT0 = 3'b000,COUNT1 = 3'b001, COUNT2 = 3'b010, COUNT3 = 3'b011;//States for state machine

input clk,normPutDataEn,reset;
input [7:0]normalisedByte1;
input [7:0]normalisedByte2;
output [63:0]outData;
output we;
output [19:0]wraddr;
wire clk,normPutDataEn,started,process,reset;
wire [23:0]pixelCounter;
wire [7:0]normalisedByte1;
wire [7:0]normalisedByte2;
reg [63:0]outData;
reg [2:0]dataSched;
reg we;
reg [19:0]wraddr;






beatCounter
	#(.MINPIXEL(STARTADDRESS),.MAXPIXEL(ENDADDRESS),.BEATS(BEATS),.PAUSE(PAUSE),.COUNTSTEP(COUNTSTEPHOLD),.PIXELCOUNTERWIDTH(PIXELCOUNT)
	) bufferCounterBlock(clk,normPutDataEn,reset,process,started,pixelCounter);


always@(posedge clk)
	begin
		if (started == 1 && process == 1)
			case(dataSched)
				COUNT3:
					begin
						outData[7:0] <= normalisedByte2;
						outData[15:8] <= normalisedByte1;
						we <=0;
						dataSched <=COUNT0;
					end
				COUNT2:
					begin
						outData[23:16] <= normalisedByte2;
						outData[31:24] <= normalisedByte1;
						we <=0;
						dataSched <=COUNT3;
					end
				COUNT1:
					begin
						outData[39:32] <= normalisedByte2;
						outData[47:40] <= normalisedByte1;
						we <=0;
						dataSched <=COUNT2;
					end
				COUNT0:
					begin
						outData[55:48] <=normalisedByte2;
						outData[63:56] <=normalisedByte1;
						we <=0;
						dataSched <=COUNT1;
						wraddr <= wraddr + 1;
					end
				default:dataSched <= COUNT0;
			endcase
				
		if (started == 1 && process == 0)
			begin
				we <=1;
			end
	end
	
always@(posedge clk)
	if(reset == 1)
		begin
			dataSched <= COUNT0;
			wraddr <= STARTADDRESS-1;
		end

endmodule			
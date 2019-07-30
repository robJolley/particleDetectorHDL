module normalisingBlock(clk,startNormalisingEn,reset,unNormalisedPixelValue,normalisedByte);

parameter STARTADDRESS = 770,  ENDADDRESS = 523518,BEATS = 4, PAUSE = 1,COUNTSTEPHOLD = 2, PIXW = 24;//address starts in and down two pixels ends the same.  parameter can be imported to accommodate second concurrent pixel 


input clk,startNormalisingEn,reset;
input [17:0]unNormalisedPixelValue;
output [7:0]normalisedByte;
wire clk,startNormalisingEn,started,process,reset;
wire [23:0]pixelCounter;
wire [17:0]unNormalisedPixelValue;
reg [7:0] normalisedByte;





beatCounter
	#(.MINPIXEL(STARTADDRESS),.MAXPIXEL(ENDADDRESS),.BEATS(BEATS),.PAUSE(PAUSE),.COUNTSTEP(COUNTSTEPHOLD),.PIXELCOUNTERWIDTH(PIXW)
	) bufferCounterBlock(clk,startNormalisingEn,reset,process,started,pixelCounter);


always@(posedge clk)
	begin
		if (started == 1 && process == 1)
			begin
				normalisedByte <=unNormalisedPixelValue/732;//Normalizing factor to reduce 18 bit result of multiplier to 8 bit pixel
			end
		if (started == 1 && process == 0)
			begin
				//Nothing to go here.
			end
	end
	
always@(posedge clk)
	if(reset == 1)
		begin
			normalisedByte <= 0;
		end

endmodule			
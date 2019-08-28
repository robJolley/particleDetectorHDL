module sobelMag(clk,startEn,reset,sobelX,sobelY,normalisedMag);

parameter STARTADDRESS = 770,  ENDADDRESS = 523518,BEATS = 4, PAUSE = 1,COUNTSTEPHOLD = 2, PIXW = 24;//address starts in and down two pixels ends the same.  parameter can be imported to accommodate second concurrent pixel 
parameter STHRESHOLD = 5632;

input clk,startEn,reset;
input signed[8:0]sobelX;
input signed[8:0]sobelY;
output [7:0]normalisedMag;
wire clk,startEn,started,process,reset;
wire [23:0]pixelCounter;
wire signed[8:0]sobelX;
wire signed[8:0]sobelY;
wire normaliseFilter;
wire signed[17:0]unnormalisedMag;
reg [7:0] normalisedMag;
reg processFlag;
reg signed[9:0]normDevider;

assign normaliseFilter = ((sobelX*sobelX + sobelY*sobelY) > 0)//STHRESHOLD);
assign unnormalisedMag = (sobelX*sobelX + sobelY*sobelY);


beatCounter
	#(.MINPIXEL(STARTADDRESS),.MAXPIXEL(ENDADDRESS),.BEATS(BEATS),.PAUSE(PAUSE),.COUNTSTEP(COUNTSTEPHOLD),.PIXELCOUNTERWIDTH(PIXW)
	) bufferCounterBlock(clk,startEn,reset,process,started,pixelCounter);


always@(posedge clk)
	begin
		if ((started == 1) && (normaliseFilter == 1))
			begin
					normalisedMag <=unnormalisedMag[16:9];//normDevider;//Truncate last 9 bits, ie divide by 512
					processFlag <= 1;
					
			end
			
		else if ((started == 1) && (normaliseFilter == 0))
			begin
					normalisedMag <= 0;
					processFlag <= 0;
			end

	end	
always@(posedge clk)
	begin
	if(reset == 1)
		begin
			normalisedMag <= 0;
			processFlag <= 0;
			normDevider <= 512;
		end
	end
endmodule			
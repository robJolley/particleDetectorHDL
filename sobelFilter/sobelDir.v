module sobelDir(clk,startEn,reset,sobelX,sobelY,dirE);

parameter STARTADDRESS = 770,  ENDADDRESS = 523518,BEATS = 4, PAUSE = 1,COUNTSTEPHOLD = 2, PIXW = 24;//address starts in and down two pixels ends the same.  parameter can be imported to accommodate second concurrent pixel 
parameter STHRESHOLD = 5632;

input clk,startEn,reset;
input signed[8:0]sobelX;
input signed[8:0]sobelY;
output [7:0]dirE;
wire clk,startEn,started,process,reset,nclk;
wire [23:0]pixelCounter;
wire signed[8:0]sobelX;
wire signed[8:0]sobelY;
wire signed[17:0] sobelY16;
reg signed[17:0] normalisedDir;
reg [7:0] dirE;
reg signed [8:0]sobMult;
wire normaliseFilter;
reg signed [17:0]oneOSix;
reg signed [17:0]six1Six;
reg signed [17:0]mThreeO5;


//assign sobelY16 = (sobelY >= 0)?{sobelY,8'b00000000}:{sobelY[8:1],9'b011111111};
//assign sobelY16 = (sobelX != 0)? ((sobelY*sobMult)/sobelX):0;
assign sobelY16 = ((sobelY*sobMult)/sobelX);
assign normaliseFilter = ((sobelX**2+ sobelY**2) > STHRESHOLD);
assign nclk =!clk;

beatCounter
	#(.MINPIXEL(STARTADDRESS),.MAXPIXEL(ENDADDRESS),.BEATS(BEATS),.PAUSE(PAUSE),.COUNTSTEP(COUNTSTEPHOLD),.PIXELCOUNTERWIDTH(PIXW)
	) bufferCounterBlock(clk,startEn,reset,process,started,pixelCounter);


always@(posedge nclk)
	begin
		if (started == 1 && normaliseFilter == 1)
			begin
				if(sobelX != 0)
					begin
						normalisedDir <= sobelY16;//May be an issue in syntheses
					end
				else
					begin
						normalisedDir <= 0;
					end
			end

	end
	
	
always@(posedge clk)
	begin
		if (started == 1 && sobelX != 0)
			begin
				if (normaliseFilter == 1)
					begin

						if ((oneOSix  < sobelY16) && (sobelY16 <= six1Six))
							begin
								dirE <= 255;
							end
						else if ((sobelY16 > six1Six) || (sobelY16 <= mThreeO5))
							begin
								dirE <= 192;
							end
						else if (( mThreeO5 < sobelY16) && (sobelY16 <=oneOSix))
							begin
								dirE <= 128;
							end
						else
							begin
								dirE <= 10;
							end
					end
			end
			
		else 
			
			begin
				dirE <= 0;
			end
	end
	
always@(posedge clk)
	if(reset == 1)
		begin
			normalisedDir <= 0;
			dirE <= 0;
			sobMult = 255;
			oneOSix = 106;
			six1Six = 616;
			mThreeO5 = -305;
		end

endmodule			
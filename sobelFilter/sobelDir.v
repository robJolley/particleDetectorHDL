module sobelDir(clk,startEn,reset,sobelX,sobelY,dirE);

parameter STARTADDRESS = 770,  ENDADDRESS = 523518,BEATS = 4, PAUSE = 1,COUNTSTEPHOLD = 2, PIXW = 24;//address starts in and down two pixels ends the same.  parameter can be imported to accommodate second concurrent pixel 


input clk,startEn,reset;
input signed[8:0]sobelX;
input signed[8:0]sobelY;
output [7:0]dirE;
wire clk,startEn,started,process,reset;
wire [23:0]pixelCounter;
wire signed[8:0]sobelX;
wire signed[8:0]sobelY;
wire signed[16:0] sobelY16;
reg signed[16:0] normalisedDir;
reg [7:0] dirE;




assign sobelY16 = {sobelY,8'b00000000};


beatCounter
	#(.MINPIXEL(STARTADDRESS),.MAXPIXEL(ENDADDRESS),.BEATS(BEATS),.PAUSE(PAUSE),.COUNTSTEP(COUNTSTEPHOLD),.PIXELCOUNTERWIDTH(PIXW)
	) bufferCounterBlock(clk,startEn,reset,process,started,pixelCounter);


always@(posedge clk)
	begin
		if (started == 1)
			begin
				if(sobelX != 0)
					begin
						normalisedDir <= sobelY16/sobelX;//May be an issue in syntheses
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
                if (106  < normalisedDir && normalisedDir <= 616)
					begin
						dirE <= 135;
					end
                else if (normalisedDir > 616 || normalisedDir <= -305)
					begin
						dirE <= 90;
					end
                else if ( -305 < normalisedDir && normalisedDir <=106)
					begin
						dirE <= 45;
					end
                else
					begin
						dirE <= 10;
					end
			end
			
		if (started == 1 && sobelX == 0)
			
			begin
				dirE = 0;
			end
	end
	
always@(posedge clk)
	if(reset == 1)
		begin
			normalisedDir <= 0;
		end

endmodule			
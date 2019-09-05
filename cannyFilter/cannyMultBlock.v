`timescale 1ns/100ps
module cannyMultBlock(clk,startMultiplierEn,reset,cannyHoldOutA,cannyHoldOutB,cannyHoldOutC,dirHoldOutB,cannyOutByte);
parameter STARTADDRESS = 770,  ENDADDRESS = 2097152/2,BEATS = 4, PAUSE = 1,COUNTSTEPHOLD = 2, PICW = 24;//address starts in and down two pixels ends the same.  parameter can be imported to accommodate second concurrent pixel 


input clk,startMultiplierEn,reset;
input [23:0]cannyHoldOutA;
input [23:0]cannyHoldOutB;
input [23:0]cannyHoldOutC;
input [23:0]dirHoldOutB;
output [7:0]cannyOutByte;
output signed [8:0]cannyY;

wire clk,startMultiplierEn,started,process,reset;
wire [23:0]pixelCounter;
wire [23:0]cannyHoldOutA;
wire [23:0]cannyHoldOutB;
wire [23:0]cannyHoldOutC;
wire [23:0]dirHoldOutB;
wire [7:0]dirE;
wire [7:0]curPoint;

wire [7:0]north;
wire [7:0]south;
wire [7:0]southEast;
wire [7:0]northWest;
wire [7:0]southWest;
wire [7:0]northEast;
wire [7:0]east;
wire [7:0]west;

reg maxDir;
 
assign dirE = dirHoldOutB[15:8];
assign curPoint = cannyHoldOutB[15:8];
assign north = cannyHoldOutA[15:8];
assign south = cannyHoldOutC[15:8];
assign southEast = cannyHoldOutC[7:0];
assign southWest = cannyHoldOutC[23:16];
assign northEast = cannyHoldOutA[7:0];
assign northWest = cannyHoldOutA[23:16];
assign east = cannyHoldOutB[7:0];
assign west = cannyHoldOutB[23:16];



beatCounter
	#(.MINPIXEL(STARTADDRESS),.MAXPIXEL(ENDADDRESS),.BEATS(BEATS),.PAUSE(PAUSE),.COUNTSTEP(COUNTSTEPHOLD),.PIXELCOUNTERWIDTH(PICW)
	) bufferCounterBlock(clk,startMultiplierEn,reset,process,started,pixelCounter);

always@(posedge clk)
	begin
		if (started == 1)
			begin
				if (curPoint > 0)
					begin
					if (dirE == 255)//NW
						begin
							maxDir <= 1

							if (northEast >= curPoint)//NE
								maxPoint <= 0;
							if (curPoint <= southWest)//SW
								maxPoint <= 0;
						end
					else if (dirE ==192)//N
						begin
							maxDir <= 1
							if (north >= curPoint)//N
								maxPoint <= 0;
							if (curPoint <= south)//S
								maxPoint <= 0;
						end
						
					else if (dirE == 128)//NE
						begin
							maxDir <= 1;
							if (northWest >= curPoint)//NW
								maxPoint <= 0;
							if (curPoint <= souhEast)//SE
								maxPoint = 0;
						end
					else//#E
						begin
							maxDir = 1
					if (west >= curPoint)//W
						maxPoint = 0;
					if (curPoint <= east)://E
						maxPoint = 0;
						end
				end
				
            if (maxPoint == 1)
				begin
					cannyOutByte <= maxDir;
				end	

	end

	
always@(posedge clk)
	if(reset == 1)
		begin

		end

endmodule			
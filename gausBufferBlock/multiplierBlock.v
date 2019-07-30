module multiplierBlock(clk,startMultiplierEn,reset,gausHoldOutA,gausHoldOutB,gausHoldOutC,gausHoldOutD,gausHoldOutE,unNormalisedPixelValue);

parameter STARTADDRESS = 770,  ENDADDRESS = 2097152,BEATS = 4, PAUSE = 1,COUNTSTEPHOLD = 2, PICW = 24;//address starts in and down two pixels ends the same.  parameter can be imported to accommodate second concurrent pixel 


input clk,startMultiplierEn,reset;
input [39:0]gausHoldOutA;
input [39:0]gausHoldOutB;
input [39:0]gausHoldOutC;
input [39:0]gausHoldOutD;
input [39:0]gausHoldOutE;
output [17:0]unNormalisedPixelValue;
wire clk,startMultiplierEn,started,process,reset;
wire [23:0]pixelCounter;
wire [39:0]gausHoldOutA;
wire [39:0]gausHoldOutB;
wire [39:0]gausHoldOutC;
wire [39:0]gausHoldOutD;
wire [39:0]gausHoldOutE;
wire [17:0]unNormalisedPixelComb;
reg [17:0]unNormalisedPixelValue;
reg [16:0]MultA1;
reg [16:0]MultA2;
reg [16:0]MultA3;
reg [16:0]MultA4;
reg [16:0]MultA5;
reg [16:0]MultB1;
reg [16:0]MultB2;
reg [16:0]MultB3;
reg [16:0]MultB4;
reg [16:0]MultB5;
reg [16:0]MultC1;
reg [16:0]MultC2;
reg [16:0]MultC3;
reg [16:0]MultC4;
reg [16:0]MultC5;
reg [16:0]MultD1;
reg [16:0]MultD2;
reg [16:0]MultD3;
reg [16:0]MultD4;
reg [16:0]MultD5;
reg [16:0]MultE1;
reg [16:0]MultE2;
reg [16:0]MultE3;
reg [16:0]MultE4;
reg [16:0]MultE5;

assign unNormalisedPixelComb = MultA1+MultA2+MultA3+MultA4+MultA5+MultB1+MultB2+MultB3+MultB4+MultB5+MultC1+MultC2+
       MultC3+MultC4+MultC5+MultD1+MultD2+MultD3+MultD4+MultD5+MultE1+MultE2+MultE3+MultE4+MultE5;


beatCounter
	#(.MINPIXEL(STARTADDRESS),.MAXPIXEL(ENDADDRESS),.BEATS(BEATS),.PAUSE(PAUSE),.COUNTSTEP(COUNTSTEPHOLD),.PIXELCOUNTERWIDTH(PICW)
	) bufferCounterBlock(clk,startMultiplierEn,reset,process,started,pixelCounter);


always@(posedge clk)
	begin
		if (started == 1 && process == 1)
			begin
				if(gausHoldOutC[23:16] >= 6)
					begin
						MultA1 <= gausHoldOutA[39:32];//Multiplying each 8 bit pixel by Gaussian factor.[5x5 matrix]
						MultA2 <= gausHoldOutA[31:24]*6;
						MultA3 <= gausHoldOutA[23:16]*12;
						MultA4 <= gausHoldOutA[15:8]*6;
						MultA5 <= gausHoldOutA[7:0];
						MultB1 <= gausHoldOutB[39:32]*6;
						MultB2 <= gausHoldOutB[31:24]*42;
						MultB3 <= gausHoldOutB[23:16]*79;
						MultB4 <= gausHoldOutB[15:8]*42;
						MultB5 <= gausHoldOutB[7:0]*6;
						MultC1 <= gausHoldOutC[39:32]*12;
						MultC2 <= gausHoldOutC[31:24]*79;
						MultC3 <= gausHoldOutC[23:16]*149;
						MultC4 <= gausHoldOutC[15:8]*79;
						MultC5 <= gausHoldOutC[7:0]*12;
						MultD1 <= gausHoldOutD[39:32]*6;				
						MultD2 <= gausHoldOutD[31:24]*42;
						MultD3 <= gausHoldOutD[23:16]*79;
						MultD4 <= gausHoldOutD[15:8]*42;
						MultD5 <= gausHoldOutD[7:0]*6;
						MultE1 <= gausHoldOutE[39:32];				
						MultE2 <= gausHoldOutE[31:24]*6;
						MultE3 <= gausHoldOutE[23:16]*12;
						MultE4 <= gausHoldOutE[15:8]*6;
						MultE5 <= gausHoldOutE[7:0];
						unNormalisedPixelValue <=unNormalisedPixelComb;
					
					end
				else
					begin
					 	MultA1 <= 0;
						MultA2 <= 0;
						MultA3 <= 0;
						MultA4 <= 0;
						MultA5 <= 0;
						MultB1 <= 0;
						MultB2 <= 0;
						MultB3 <= 0;
						MultB4 <= 0;
						MultB5 <= 0;
						MultC1 <= 0;
						MultC2 <= 0;
						MultC3 <= 0;
						MultC4 <= 0;
						MultC5 <= 0;
						MultD1 <= 0;				
						MultD2 <= 0;
						MultD3 <= 0;
						MultD4 <= 0;
						MultD5 <= 0;
						MultE1 <= 0;				
						MultE2 <= 0;
						MultE3 <= 0;
						MultE4 <= 0;
						MultE5 <= 0;
						unNormalisedPixelValue <= 0;
					end
			end
		if (started == 1 && process == 0)
			begin
				//Nothing to go here.
			end
	end
	
always@(posedge clk)
	if(reset == 1)
		begin
				MultA1 <= 0;
		        MultA2 <= 0;
                MultA3 <= 0;
                MultA4 <= 0;
                MultA5 <= 0;
                MultB1 <= 0;
                MultB2 <= 0;
                MultB3 <= 0;
                MultB4 <= 0;
                MultB5 <= 0;
                MultC1 <= 0;
                MultC2 <= 0;
                MultC3 <= 0;
                MultC4 <= 0;
                MultC5 <= 0;
                MultD1 <= 0;				
                MultD2 <= 0;
                MultD3 <= 0;
                MultD4 <= 0;
                MultD5 <= 0;
                MultE1 <= 0;				
                MultE2 <= 0;
                MultE3 <= 0;
                MultE4 <= 0;
                MultE5 <= 0;
				unNormalisedPixelValue <= 0;
		end

endmodule			
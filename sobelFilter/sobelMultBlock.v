`timescale 1ns/100ps
module sobelMultBlock(clk,startMultiplierEn,reset,sobelHoldOutA,sobelHoldOutB,sobelHoldOutC,sobelX,sobelY);
parameter STARTADDRESS = 770,  ENDADDRESS = 2097152/2,BEATS = 4, PAUSE = 1,COUNTSTEPHOLD = 2, PICW = 24;//address starts in and down two pixels ends the same.  parameter can be imported to accommodate second concurrent pixel 


input clk,startMultiplierEn,reset;
input [23:0]sobelHoldOutA;
input [23:0]sobelHoldOutB;
input [23:0]sobelHoldOutC;

output signed [8:0]sobelX;
output signed [8:0]sobelY;

wire clk,startMultiplierEn,started,process,reset;
wire [23:0]pixelCounter;
wire [23:0]sobelHoldOutA;
wire [23:0]sobelHoldOutB;
wire [23:0]sobelHoldOutC;

reg signed [8:0]sobelX;
reg signed [8:0]sobelY;

wire signed [8:0]combSobelX;

wire signed [8:0]combSobelY;

reg signed [8:0]MultA1X;
reg signed [8:0]MultA2X;
reg signed [8:0]MultA3X;
reg signed [8:0]MultB1X;
reg signed [8:0]MultB2X;
reg signed [8:0]MultB3X;
reg signed [8:0]MultC1X;
reg signed [8:0]MultC2X;
reg signed [8:0]MultC3X;

reg signed [8:0]MultA1Y;
reg signed [8:0]MultA2Y;
reg signed [8:0]MultA3Y;
reg signed [8:0]MultB1Y;
reg signed [8:0]MultB2Y;
reg signed [8:0]MultB3Y;
reg signed [8:0]MultC1Y;
reg signed [8:0]MultC2Y;
reg signed [8:0]MultC3Y;



assign combSobelX = (MultA1X+MultA2X+MultA3X+MultB1X+MultB2X+MultB3X+MultC1X+MultC2X+MultC3X);
assign combSobelY = (MultA1Y+MultA2Y+MultA3Y+MultB1Y+MultB2Y+MultB3Y+MultC1Y+MultC2Y+MultC3Y);




beatCounter
	#(.MINPIXEL(STARTADDRESS),.MAXPIXEL(ENDADDRESS),.BEATS(BEATS),.PAUSE(PAUSE),.COUNTSTEP(COUNTSTEPHOLD),.PIXELCOUNTERWIDTH(PICW)
	) bufferCounterBlock(clk,startMultiplierEn,reset,process,started,pixelCounter);

always@(posedge clk)
	begin
//		$display("X Mult: %d combSobelX: %d",$signed(MultA1X+MultA2X+MultA3X+MultB1X+MultB2X+MultB3X+MultC1X+MultC2X+MultC3X),combSobelX);
//		$display("Y Mult: %d combSobelY: %d",$signed(MultA1Y+MultA2Y+MultA3Y+MultB1Y+MultB2Y+MultB3Y+MultC1Y+MultC2Y+MultC3Y),combSobelY);
		if (started == 1)
			begin
				//Sobel x Filter multiplication
					
				MultA1X <= (sobelHoldOutA[23:16]*(-1));
				MultA2X <= 0;
				MultA3X <= (sobelHoldOutA[7:0]);
				MultB1X <= (sobelHoldOutB[23:16]*(-2));
				MultB2X <= 0;
				MultB3X <= (sobelHoldOutB[7:0]*2);
				MultC1X <= (sobelHoldOutC[23:16]*(-1));
				MultC2X <= 0;
				MultC3X <= (sobelHoldOutC[7:0]);						
				// Sobel Y Filter Multiplication 	
				MultA1Y <= (sobelHoldOutA[23:16]*(-1));
				MultA2Y <= (sobelHoldOutA[15:8]*(-2));
				MultA3Y <= (sobelHoldOutA[7:0]*(-1));
				MultB1Y <= (0);
				MultB2Y <= (0);
				MultB3Y <= (0);
				MultC1Y <= (sobelHoldOutC[23:16]);
				MultC2Y <= (sobelHoldOutC[15:8]*(2));
				MultC3Y <= (sobelHoldOutC[7:0]);
				sobelX <= combSobelX;
				sobelY <= combSobelY;
//				sobelX <= {combSobelX[12],combSobelX[7:0]};//Values contraindicated first 'sign' bit + rest of 8 bit values... 
//				sobelY <= {combSobelY[12],combSobelY[7:0]};					
			end
		else
			begin
			
				MultA1X <= 0;
				MultA2X <= 0;
				MultA3X <= 0;
				MultB1X <= 0;
				MultB2X <= 0;
				MultB3X <= 0;
				MultC1X <= 0;
				MultC2X <= 0;
				MultC3X <= 0;
			 	MultA1Y <= 0;
				MultA2Y <= 0;
				MultA3Y <= 0;
				MultB1Y <= 0;
				MultB2Y <= 0;
				MultB3Y <= 0;
				MultC1Y <= 0;
				MultC2Y <= 0;
				MultC3Y <= 0;
				sobelX <= 0;
				sobelY <= 0;
			end
	end

	
always@(posedge clk)
	if(reset == 1)
		begin
			MultA1X <= 0;
			MultA2X <= 0;
			MultA3X <= 0;
			MultB1X <= 0;
			MultB2X <= 0;
			MultB3X <= 0;
			MultC1X <= 0;
			MultC2X <= 0;
			MultC3X <= 0;
			MultA1Y <= 0;
			MultA2Y <= 0;
			MultA3Y <= 0;
			MultB1Y <= 0;
			MultB2Y <= 0;
			MultB3Y <= 0;
			MultC1Y <= 0;
			MultC2Y <= 0;
			MultC3Y <= 0;
			sobelX <= 0;
			sobelY <= 0;
		end

endmodule			
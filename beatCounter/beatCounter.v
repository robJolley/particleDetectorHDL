
module beatCounter(clk,startCounterEn,process,started,pixelCounter);

parameter 	INITCOUNT = 2'b00,COUNT0 = 2'b01, COUNT1 = 2'b10,//States for state machine.
					MINPIXEL = 0,//MIN + MAX PIXEL start and stop position for pixel counter,  counting through image,  
					MAXPIXEL = 255,
					BEATS = 4,//pattern for process where BEATS = 4 and PAUSE = 1 this is 1111011110.... 
					PAUSE = 1,
					PIXELCOUNTERWIDTH = 20;//Corresponding to image address width
					
	
		input clk, startCounterEn;
		output process, started; 
		output [PIXELCOUNTERWIDTH-1:0]pixelCounter;

	wire [PIXELCOUNTERWIDTH-1:0]pixelCounter;
	wire clk, startCounterEn;
	reg [19:0]pixelCount;
	reg [1:0]countCase = INITCOUNT;
	reg [7:0]pauseLenth;
	reg [7:0]count;//method to define length of count to number of bits in BEATS
	assign pixelCounter = pixelCount;
	assign process = (countCase == COUNT0);
	assign started = (countCase != INITCOUNT);
	
	always @(posedge clk)
		begin
			case(countCase)
				INITCOUNT :
						begin
							pixelCount = MINPIXEL;
							if(startCounterEn)
								begin
									pauseLenth<=0;
									count<=0;
									countCase<=COUNT0;
								end
						end
				COUNT0 :
						begin
							if((count !=(BEATS-1)) && (pixelCount != MAXPIXEL))
								begin
									count = count +1;
									//pixelCount = pixelCount +1;
									countCase <= COUNT0;
								end
							else if (pixelCount == MAXPIXEL)
							    begin
								    countCase <= INITCOUNT;
								end
							else if (pauseLenth == PAUSE)
								begin
									pauseLenth = 0;
									count = 0;
								end
							else
								begin
									//pauseLenth = pauseLenth + 1;
									countCase <= COUNT1;
								end
								
						end
				
				COUNT1 :
							if (pauseLenth == (PAUSE-1))
								begin
									pauseLenth = 0;
									count = 0;
									countCase <= COUNT0;
									pixelCount = pixelCount + 1;
								end
							else
								begin
									pauseLenth = pauseLenth + 1;
								end
				
				default : countCase <=INITCOUNT;
				
			
			endcase
		end	
endmodule
	
	
	


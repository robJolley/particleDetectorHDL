`timescale 1ns/100ps

module cannyMagTB();

parameter STARTHOLD1 = 770,  ENDHOLD1 = (261758);
reg signed[8:0]isd;
reg clk;
reg starter;
reg startEn;
reg reset;
wire [7:0] normalisedMag;
reg signed[8:0] cannyX;
reg signed[8:0] cannyY;

///assign cannyX = isd;
//assign cannyY = isd;

cannyMag #(.STARTADDRESS(STARTHOLD1),.ENDADDRESS(ENDHOLD1))
cannyMagtester(clk,startEn,reset,cannyX,cannyY,normalisedMag);


initial	
	begin
		clk = 0;
		startEn = 0;
		reset = 0;
		starter = 0;
		#50;
		reset = 1;
		#10;
		reset = 0;
		#10;
		startEn = 1;
		#10;
		startEn = 0;
		

		if(starter == 1)
			begin
				for(isd = -255;isd <=255;isd++)
					begin
						cannyX <= isd;
						cannyY <= isd;
						#10;
						$display("canny X + Y: %d unNormalised out: %d Normalised %d", $signed(cannyX), $signed(cannyMagtester.unnormalisedMag), normalisedMag);
					end
			end		
		#20;
		$display("This is the end");
		$stop;
		$finish;	
	end
	
always@(posedge clk)
	begin
		if(reset == 1)
			begin
				starter = 1;
			end
	end
	
	always
     begin
        clk = #5 !clk;//100mHz clock
     end
	 
	 
	initial
		begin
			$dumpfile("cannyMAGSim.fst");
			$dumpvars(0,cannyMagTB);
		end		
endmodule
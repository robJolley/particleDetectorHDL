`timescale 1ns/100ps

module beatcounterTB();

reg clk,startCounterEn;
wire process,started;
wire [19:0]pixelCounter;

beatCounter
	#(.MINPIXEL(4),.MAXPIXEL(128)
	) beatCounterBlock(clk,startCounterEn,process,started,pixelCounter);
	
initial
	begin

		clk  = 1;
		startCounterEn = 0;
		
		#1;
		
		startCounterEn = 1;
		#10;
		startCounterEn = 0;
		#10000;
		$stop;
        $finish;
	end
	
		
		
		
	always
     begin
        clk = #5 !clk;//100mHz clock
     end
	 
initial
 begin
    $dumpfile("test1.vcd");
    $dumpvars(0,beatcounterTB);
 end
endmodule
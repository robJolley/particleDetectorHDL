`timescale 1ns/100ps

module sqrRootTB();

reg clk;
reg [31:0]invalue;
wire [31:0]outvalue;
reg starter;

sqrRoot sqrt(clk,invalue,outvalue);//Approximation of square-root.  

	initial 
		begin
			clk = 0;
			invalue = 0;
			starter = 0;
			
			#10;
			starter = 1;
			#1000;
			
			$stop;
			$finish;
		end
		
always
	begin
       clk = #5 !clk;//100mHz clock
	end
	
	initial
		begin
			$dumpfile("squareRoottest1.vcd");
			$dumpvars(0,sqrRootTB);
		end
		
always@(posedge clk)
	begin
		if(starter ==1)
			begin
				$display(",Input: = %d Output: = %d",invalue+2,outvalue); 
			end
	end
	
	
	
always@(posedge clk)
	begin
		if(starter ==1)
			begin
				invalue = invalue +1;
			end
	end
	
endmodule
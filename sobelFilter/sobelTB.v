`timescale 1ns/100ps

module sobelTB();

parameter C0 = 3'b000, C1 = 3'b001, C2 = 3'b010, C3 = 3'b011,C4 = 3'b100; 
wire [63:0]data1;
wire [63:0]data2;
wire [63:0]data3;
reg clk,we1,reset,startEn;
reg [2:0]addressCase;
wire [63:0]q1;
wire [63:0]q2;
wire [63:0]q3;
wire we2,getNext;
wire [7:0]colPos;






reg [19:0]read_addr1;
reg [19:0]read_addr2;
reg [19:0]read_addr3;
reg [19:0]addresSchedule;
wire [19:0]write_addr1;
wire [19:0]write_addr2;
wire [19:0]write_addr3;

//Ram memory blocks (Simulated)
assign colPos[7:0] = addresSchedule[7:0];	
simple_ram_dual_clock  SRAM1(data1,read_addr1,write_addr1,we1,clk, clk,q1);
simple_ram_dual_clock  SRAM2(data2,read_addr2,write_addr2,we2,clk, clk,q2);
simple_ram_dual_clock  SRAM3(data3,read_addr3,write_addr3,we3,clk, clk,q3);
sobelFilter sobelFilter1(clk,reset,startEn,read_addr1,q1,we2,we3,write_addr2,data2,write_addr3,data3,getNext);



initial
	begin
		$readmemh("C:/hexfiles/outfile2.hex", SRAM1.ram);		
	//	SRAM1.ram[0] <= 64'hF0E0D0C0B0A09080;
	//	SRAM1.ram[256] <= 64'hF0E0D0C0B0A09080;
	//	SRAM1.ram[512] <= 64'hF0E0D0C0B0A09080;
	//	SRAM1.ram[768] <= 64'hF0E0D0C0B0A09080;
			

		
		$display("ramValue:",SRAM1.ram[0]);
			
		clk = 0;
		reset = 1;

		addresSchedule = 768;
		#10;
		reset = 0;
//		#10;
		startEn = 1;
		#10;
		startEn = 0;

	 	#4000000;
//		#150000;
		#10000;
		$writememh("C:/hexfiles/outSRAM4sobel.hex", SRAM2.ram);
		$writememh("C:/hexfiles/outSRAM3sobeldir.hex", SRAM3.ram);
		$display("ramValue:",SRAM2.ram[0]);
		$stop;
		$finish;
	end
	always@(posedge clk)


		begin
			case(addressCase)
				C0:
					begin
						read_addr1 <= addresSchedule;
						addressCase <= C1;
					end			
				C1:
					begin
						read_addr1 <= addresSchedule;
						addressCase <= C2;
					end
				C2:
					begin
						read_addr1 <= addresSchedule-256;
						addressCase <= C3;
					end
					
				C3:
					begin
						read_addr1 <= addresSchedule -(256*2);
						addressCase <= C4;
					end

				C4:
					begin
						read_addr1 <= addresSchedule -(256*3);
						if (colPos == 255)
							begin
								addresSchedule <= addresSchedule + 257;
							end
						else
							begin
								addresSchedule <= addresSchedule + 1;
							end
						addressCase <= C1;
					end
			endcase
		end
					
					
//			for(addresSchedule = 1280; addresSchedule <= 50000; addresSchedule++ )
//				begin
//					read_addr1 = addresSchedule;
//					#10;
//					read_addr1 = addresSchedule-256;
//					#10;
//					//read_addr1 <= addresSchedule -(256*2);
//					#10;
//					read_addr1 = addresSchedule -(256*3);
//					#10;
//					read_addr1 = addresSchedule -(256*4);
//					#10;				
//				end


	
	always@(posedge clk)
     begin
		if(reset == 1)
			begin
				read_addr1 = 0;
				addresSchedule = 768;
				addressCase = C0;
			end
	end
	
	always
     begin
        clk = #5 !clk;//100mHz clock
     end
	 
	initial
		begin
			$dumpfile("sobelSim.fst");
			$dumpvars(0,sobelTB);
		end
endmodule
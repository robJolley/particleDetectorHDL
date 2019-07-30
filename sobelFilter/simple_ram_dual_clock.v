`timescale 1ns/100ps
module simple_ram_dual_clock #(
  parameter DATA_WIDTH=64,                 //width of data bus
  parameter ADDR_WIDTH=20
  
                    //width of addresses buses
)(
  input      [DATA_WIDTH-1:0] data,       //data to be written
  input      [ADDR_WIDTH-1:0] read_addr,  //address for read operation
  input      [ADDR_WIDTH-1:0] write_addr, //address for write operation
  input                       we,         //write enable signal
  input                       read_clk,   //clock signal for read operation
  input                       write_clk,  //clock signal for write operation
  output reg [DATA_WIDTH-1:0] q           //read data
);
    
  reg [DATA_WIDTH-1:0] ram [524288]; // ** is exponentiation
  reg [ADDR_WIDTH-1:0]addrStor1;
  reg [ADDR_WIDTH-1:0]addrStor2;
 
  initial begin
  end  
  always @(posedge write_clk) begin //WRITE
    if (we) 
	begin
      ram[write_addr] = data;

//		$display("ramValue:",ram[write_addr]);
//		$display("writeAddress:",write_addr);
    end
  end
    
  always @(posedge read_clk) begin //READ
	if(read_clk)
	begin
		addrStor2 <= addrStor1;
		addrStor1 <= read_addr;
	end
  end
  always @(posedge read_clk) begin //READ  
 	q <= ram[addrStor2]; 
  end	
    
endmodule
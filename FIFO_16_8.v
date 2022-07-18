module FIFO_16_8 (we,re,clk,rst,data_in,data_out,full,empty);


parameter FIFO_WIDTH = 8;
parameter FIFO_DEPTH = 16;
parameter ADDR_SIZE = 4;


input clk,rst,we,re;
input [FIFO_WIDTH-1:0]data_in;
output reg [FIFO_WIDTH-1:0]data_out;
output empty,full;

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
reg [ADDR_SIZE:0]fifo_count; 
reg [ADDR_SIZE-1:0] wr_pointer,rd_pointer;

assign empty = (fifo_count == 0);
assign full = (fifo_count == FIFO_DEPTH);


always @(posedge clk)
     begin : write
	 if (we && !full)
	 mem[wr_pointer] <= data_in;
	 else if (we && re)
	 mem[wr_pointer] <= data_in;
	 end
	 
 
always @(posedge clk)
     begin : read
	 if (re && !empty)
	 data_out<= mem[rd_pointer];
	 else if (we && re)
	 data_out<= mem[rd_pointer];
	 end	 


	 always @(posedge clk)
     begin : pointer
	 if (rst)
	 begin
	
	 wr_pointer <=0;
	 rd_pointer <=0;
	 	 end
     else 
     begin
	 wr_pointer <= ((we && !full) || (we && re)) ? (wr_pointer+1) : wr_pointer;
	 rd_pointer <= ((re && !empty) || (we && re)) ? (rd_pointer+1) : rd_pointer;
	 end
	 end
	 
always@(posedge clk)
begin : count
if (rst)
fifo_count <= 0;
else 
begin
case ({we,re})
2'b00 : fifo_count <= fifo_count;
2'b01 : fifo_count <= (fifo_count==0)? 0 : fifo_count-1;
2'b10 : fifo_count <= (fifo_count==FIFO_DEPTH)? FIFO_DEPTH : fifo_count+1;
2'b11 : fifo_count <= fifo_count;
default : fifo_count <= fifo_count;
endcase

end
end
endmodule

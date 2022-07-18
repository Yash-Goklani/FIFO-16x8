module FIFO_16_8_tb();


parameter FIFO_WIDTH = 8;
parameter FIFO_DEPTH = 16;
parameter ADDR_SIZE = 4;

reg clk,rst,we,re;
reg [FIFO_WIDTH-1:0]data_in;
wire [FIFO_WIDTH-1:0]data_out;
wire empty,full;


FIFO_16_8  DUT(we,re,clk,rst,data_in,data_out,full,empty);

initial
$monitor ("clk=%b,rst=%b,we=%b,re=%b,data_in=%b,data_out=%b,empty=%b,full=%b",clk,rst,we,re,data_in,data_out,full,empty);

initial
begin
clk = 1'b0;
re= 1'b0;
we = 1'b0;
forever #5 clk=~clk;
end



task reset;
begin
@(negedge clk)
rst = 1'b1;
@(negedge clk)
rst = 1'b0;
end
endtask 

task write(input i,input [FIFO_WIDTH-1:0]j);
begin
@(negedge clk)
we =i;
data_in = j;
@(negedge clk)
we=0;
end
endtask

task read (input k);
begin
@(negedge clk)
re = k;
@(negedge clk)
re = 0;
end
endtask

initial
begin
reset;
write(1'b1,8'ha);
reset;
write(1'b1,8'hb);
write(1'b1,8'hc);
write(1'b1,8'hd);
write(1'b1,8'he);
write(1'b1,8'h20);
read (1'b1);
write(1'b1,8'h21);
write(1'b1,8'h22);
write(1'b1,8'h3);
write(1'b1,8'h4);
write(1'b1,8'h5);
write(1'b1,8'h6);
write(1'b1,8'h7);
write(1'b1,8'h8);
write(1'b1,8'h9);
write(1'b1,8'ha);
write(1'b1,8'hb);
write(1'b1,8'hc);
write(1'b1,8'hd);
read (1'b1);
read (1'b1);
read (1'b1);
read (1'b1);
read (1'b1);
read (1'b1);
#100;
$finish;
end

endmodule


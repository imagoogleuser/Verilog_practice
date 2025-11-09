`timescale 1ns/1ps
module tb_FIFO;
reg clk, rst, wr_en, r_en;
reg  [WIDTH-1:0] din;
wire [WIDTH-1:0] dout;
wire full, empty;
parameter WIDTH =8;
parameter DEPTH =16;
integer i;
FIFO uut(.clk(clk),.rst(rst),.wr_en(wr_en),.r_en(r_en),.din(din),.dout(dout),.empty(empty),.full(full));
initial clk=0;
always #5 clk=~clk;
initial begin
$dumpfile("tb_FIFO.vcd");
$dumpvars(0,tb_FIFO.uut);
for (i = 0; i < 16; i = i + 1)
    $dumpvars(1, tb_FIFO.uut.mem[i]); // dump each element manually
end
initial begin
rst = 1;
wr_en = 0;
r_en = 0;
din = 0;
#10;
rst = 0;
wr_en = 1;
repeat (16) begin
din = $random % 256;
#10;
end
wr_en = 0;
#20;
r_en = 1;
#160;
r_en = 0;
#20;
$finish;
end
endmodule


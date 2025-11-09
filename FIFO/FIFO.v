module FIFO#(parameter WIDTH =8,parameter DEPTH =16)(input wire clk,input wire rst,input wire wr_en,input wire r_en,
input wire [WIDTH-1:0] din,output reg [WIDTH-1:0] dout,output wire full,output wire empty);
reg [$clog2(DEPTH)-1:0] wr_ptr;
reg [$clog2(DEPTH)-1:0] r_ptr;
reg [$clog2(DEPTH):0] count;
reg [WIDTH-1:0] mem [DEPTH-1:0];
integer i;
always@(posedge clk)
begin
if(rst) begin
for(i=0;i<DEPTH;i=i+1)
mem[i]<=0;
wr_ptr<=0;
r_ptr<=0;
count<=0;
dout<=0;
end
else if(!full && wr_en) begin
mem[wr_ptr]<=din;
wr_ptr<=wr_ptr+1;
count<=count+1;
end
else if(!empty && r_en) begin
dout<=mem[r_ptr];
r_ptr<=r_ptr+1;
count<=count-1;
end
end
assign full = (count==DEPTH);
assign empty= (count==0);
endmodule


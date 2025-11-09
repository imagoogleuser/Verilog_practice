module mod6(input wire clk,input wire rst,input wire enable,output reg [2:0] count);
always@(posedge clk)
begin 
if(rst) begin
count<=4'd0;
end
else if(enable) begin
count<=count+1'b1;
if(count == 4'd5) begin
count<=4'd0;
end
end
end
endmodule

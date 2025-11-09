module mod59(input wire clk,input wire rst,input wire enable,output wire  [2:0] tens,
output wire [3:0] ones,output wire hr_carry);
wire carry_out;

mod10 ones_counter(.clk(clk),.rst(rst),.count(ones),.carry(carry_out),.enable(enable));
mod6 tens_counter(.clk(clk),.rst(rst),.count(tens),.enable(carry_out));
assign hr_carry=(tens==3'd5) && carry_out;
endmodule 

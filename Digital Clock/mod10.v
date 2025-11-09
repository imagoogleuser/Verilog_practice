module mod10(
    input  wire clk,
    input  wire rst,
    input wire enable,
    output reg  [3:0] count, 
    output wire carry        
);

    always @(posedge clk) begin
        if (rst) begin
            count <= 4'd0;
        end
        else if (enable) begin 
        
            if (count == 4'd9) begin
                count <= 4'd0;
            end
            else begin
                count <= count + 1'b1;
            end
        end
    end
    assign carry = (count == 4'd9) && enable;
endmodule

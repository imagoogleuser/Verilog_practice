module hour(
    input wire clk,
    input wire rst,
    input wire enable_1hz, // Main 1-second tick

    // Outputs
    output wire [3:0] sec_ones,
    output wire [2:0] sec_tens,
    output wire [3:0] min_ones,
    output wire [2:0] min_tens,
    output wire [4:0] hours      // Will count 1-12
);

    // Wires for carries
    wire sec_carry_out; // Tick once per minute
    wire min_carry_out; // Tick once per hour

    // 1. Seconds Counter (mod59)
    // Enabled by the main 1Hz tick
    mod59 seconds_counter (
        .clk(clk),
        .rst(rst),
        .enable(enable_1hz),
        .tens(sec_tens),
        .ones(sec_ones),
        .hr_carry(sec_carry_out) // Renamed for clarity
    );

    // 2. Minutes Counter (mod59)
    // Enabled by the carry from the seconds counter
    mod59 minutes_counter (
        .clk(clk),
        .rst(rst),
        .enable(sec_carry_out), // <-- Enabled by seconds carry
        .tens(min_tens),
        .ones(min_ones),
        .hr_carry(min_carry_out) // Renamed for clarity
    );

    // 3. Hours Counter (1-12)
    // This is the corrected version of your 'hour' logic
    reg [4:0] hours_reg; // Internal register
    assign hours = hours_reg; // Assign output from register

    always @(posedge clk) begin
        if (rst) begin
            hours_reg <= 5'd1; // Reset to 1 for a 1-12 clock
        end
        else if (min_carry_out) begin // <-- Only enabled by minute carry
            if (hours_reg == 5'd12) begin
                hours_reg <= 5'd1; // Rolls over from 12 to 1
            end
            else begin
                hours_reg <= hours_reg + 1'b1;
            end
        end
    end
    endmodule

module tb_hour;

    // Testbench inputs
    reg clk;
    reg rst;
    reg enable_1hz; // Main 1-second tick

    // Wires for all outputs from the clock
    wire [3:0] sec_ones;
    wire [2:0] sec_tens;
    wire [3:0] min_ones;
    wire [2:0] min_tens;
    wire [4:0] hours;

    // Instantiate the correct module: hour
    // Fixes:
    // 1. Module name is 'hour' (your name for digital_clock_12hr.v)
    // 2. Added all missing commas between port connections
    hour uut (
        .clk(clk), // <-- Added comma
        .rst(rst), // <-- Added comma
        .enable_1hz(enable_1hz), // <-- Added comma
        .sec_ones(sec_ones), // <-- Added comma
        .sec_tens(sec_tens), // <-- Added comma
        .min_ones(min_ones), // <-- Added comma
        .min_tens(min_tens), // <-- Added comma
        .hours(hours) 
    );

    // Clock generation (10 time-unit period)
    initial clk = 0;
    always #5 clk = ~clk;

    // VCD dump setup
    initial begin
        $dumpfile("tb_hour.vcd");
        $dumpvars(0, tb_hour.uut); // Correct path
    end

    // Test sequence
    initial begin
        // 1. Assert reset
        rst = 1;
        enable_1hz = 0; // Keep enable low during reset
        #10;
        
        // 2. De-assert reset and start 1Hz tick
        rst = 0;
        enable_1hz = 1;
        
        // 3. New monitor for H:M:S
        //    (This line was correct in your version)
        $monitor("Time: %0t | H:M:S = %d : %d%d : %d%d", 
                 $time, hours, min_tens, min_ones, sec_tens, sec_ones);

        // 4. Run for 40,000 time units (just over 1 hour)
        #40000; 
        
        // 5. Finish simulation
        $finish;
    end

endmodule

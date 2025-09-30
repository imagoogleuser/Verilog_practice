
---

# 1001 Sequence Detector (Mealy FSM, Non-Overlapping) using D Flip-Flops

## Overview

This project implements a **non-overlapping 1001 sequence detector** as a **Mealy FSM** using **D flip-flops** in Verilog.

* **FSM Type:** Mealy
* **Sequence:** `1001` (non-overlapping)
* **Flip-Flop Type:** D flip-flop with asynchronous reset

---

## File Structure

```
Verilog_practice/
│
├── d_ff.v                 # D flip-flop module with asynchronous reset
├── Sequence_detector.v    # 1001 sequence detector FSM (non-overlapping)
├── tb_Sequence_detector.v # Testbench for simulation
├── d_ff_tb.v              # Optional testbench for D flip-flop
└── README.md              # This file
```

---
#State Diagram,State Equations and Final Logical Circuit


State Diagram:

<img width="440" height="259" alt="image" src="https://github.com/user-attachments/assets/3c35d5ba-d219-4201-976a-d03f137f69f4" />


State Table:
| Input | PS   | PS   | NS   | NS   | Input to Flip-Flop | Input to Flip-Flop | Output |
| :---: | :--: | :--: | :--: | :--: | :----------------: | :----------------: | :----: |
| **X** | **Q1** | **Q0** | **Q1+**| **Q0+**| **D1** | **D0** | **Y** |
|   0   |   0  |   0  |   0  |   0  |         0          |         0          |   0    |
|   0   |   0  |   1  |   1  |   0  |         1          |         0          |   0    |
|   0   |   1  |   0  |   1  |   1  |         1          |         1          |   0    |
|   0   |   1  |   1  |   0  |   0  |         0          |         0          |   0    |
|   1   |   0  |   0  |   0  |   1  |         0          |         1          |   0    |
|   1   |   0  |   1  |   0  |   1  |         0          |         1          |   0    |
|   1   |   1  |   0  |   0  |   1  |         0          |         1          |   0    |
|   1   |   1  |   1  |   0  |   0  |         0          |         0          |   1    |

State Equations:

<img width="191" height="122" alt="image" src="https://github.com/user-attachments/assets/811bea47-c6cb-4750-b1fa-fe2953bc9227" />

Final Circuit DIagram:

<img width="895" height="401" alt="image" src="https://github.com/user-attachments/assets/be250c24-3c04-450a-9052-39d8579fa9b6" />
Credit : ALL ABOUT ELECTRONICS https://www.youtube.com/watch?v=PbjntQf3sGc

## Modules

### `d_ff.v`

A D flip-flop with asynchronous active-low reset.

### `Sequence_detector.v`

Mealy FSM that detects `1001` **non-overlapping**.

* After detecting `1001`, the FSM resets to the initial state, ignoring any part of the previous sequence.

### `tb_Sequence_detector.v`

Testbench that:

* Generates a **clock** signal.
* Applies **input sequences**.
* Dumps a **VCD waveform** (`Seq_detector1001.vcd`) for GTKWave.
* Initializes flip-flops using **reset**.

---

## Simulation Instructions

1. **Compile all files**:

```bash
iverilog -o seq_detector d_ff.v Sequence_detector.v tb_Sequence_detector.v
```

2. **Run simulation**:

```bash
vvp seq_detector
```

3. **View waveform**:

```bash
gtkwave Seq_detector1001.vcd
```

* Signals include `clk`, `x`, `y`, `Q1`, `Q0`, `D1`, `D0`.

---

## Example Input and Output

```
Input x: 1 0 0 1 0 0 1
Output y: 0 0 0 1 0 0 1
```

* Each `y=1` corresponds to a detected 1001 sequence.
* Non-overlapping: FSM resets after each detection.

---

## Code

### D Flip-Flop (`d_ff.v`)

```verilog
module d_ff(input D,input clk,input rst,output reg Q,output Qb);
assign Qb=~Q;
always @(posedge clk or negedge rst) begin
if(!rst) begin
Q<=1'b0;
end
else begin
Q<=D;
end
end
endmodule
```

---

### Sequence Detector (`Sequence_detector.v`)

```verilog
module Sequence_detector(
    input clk,
    input rst,       // add reset port
    input wire x,
    output wire y
);
    wire Q1, Q0;
    wire Q1b, Q0b;
    wire D1, D0;

    // Next-state logic
    assign D1 = (~x & ~Q1 & Q0) | (~x & Q1 & ~Q0);
    assign D0 = (x & ~Q1) | (Q1 & ~Q0);

    // Output logic (Mealy)
    assign y = (Q1 & Q0 & x);

    // Instantiate D flip-flops
    d_ff ff1(.clk(clk), .rst(rst), .D(D1), .Q(Q1), .Qb(Q1b));
    d_ff ff0(.clk(clk), .rst(rst), .D(D0), .Q(Q0), .Qb(Q0b));
endmodule

```

---

### Testbench (`tb_Sequence_detector.v`)

```verilog
`timescale 1ns/1ps
module tb_Sequence_detector;
    reg clk, rst;
    reg x;
    wire y;

    // Instantiate DUT
    Sequence_detector uut (.clk(clk), .rst(rst), .x(x), .y(y));

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Waveform dump
    initial begin
        $dumpfile("Seq_detector1001.vcd");
        $dumpvars(0, tb_Sequence_detector);

        // Also dump internal signals to see D1/D0 in GTKWave
        $dumpvars(0, uut.D1);
        $dumpvars(0, uut.D0);
        $dumpvars(0, uut.Q1);
        $dumpvars(0, uut.Q0);
    end

    // Stimulus
    initial begin
        rst = 0;   // assert reset
        x = 0;
        #10 rst = 1; // release reset

        // Apply input sequence
        #10 x = 1;
        #10 x = 0;
        #10 x = 0;
        #10 x = 1;
        #10 x = 0;
        #10 x = 0;
        #10 x = 1;

        #50 $finish;
    end
endmodule

```
## Simulation Waveform:

<img width="1646" height="531" alt="image" src="https://github.com/user-attachments/assets/c8717247-f5e1-49da-887a-58cddb1fd373" />


---


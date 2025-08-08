//
// Testbench for the Moore FSM "0110" detector
//
// Testbench: tb_moore_detector.v
// Author:    Gemini
// Date:      August 08, 2025
//

`timescale 1ns/1ps

module tb_moore_detector;

    // Inputs to the DUT (Device Under Test)
    reg clk;
    reg reset;
    reg x_in;

    // Output from the DUT
    wire y_out;

    // Instantiate the Moore FSM
    moore_detector dut (
        .clk(clk),
        .reset(reset),
        .x_in(x_in),
        .y_out(y_out)
    );

    // Clock Generation
    // Create a clock with a 10ns period (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle every 5ns
    end

    // Test Sequence
    initial begin
        // 1. Dump waves for GTKWave
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_moore_detector);

        // 2. Initialize inputs and apply reset
        reset = 1;
        x_in  = 0;
        #15; // Wait for a few clock cycles
        reset = 0;
        #5;

        // 3. Provide input stream and check for output
        // Test Case 1: Simple match -> 0110
        x_in <= 0; #10; // S_0
        x_in <= 1; #10; // S_01
        x_in <= 1; #10; // S_011
        x_in <= 0; #10; // S_0110 (y_out should be 1 here)

        // Test Case 2: No match -> 1111
        x_in <= 1; #10; // S_IDLE
        x_in <= 1; #10; // S_IDLE
        x_in <= 1; #10; // S_IDLE
        x_in <= 1; #10; // S_IDLE

        // Test Case 3: Overlapping sequence -> 0110110
        // Expected output at the end of the first and second "0110"
        x_in <= 0; #10; // S_0
        x_in <= 1; #10; // S_01
        x_in <= 1; #10; // S_011
        x_in <= 0; #10; // S_0110 (y_out=1) -> next state is S_01 because last input was 0 and current is 1
        x_in <= 1; #10; // S_011
        x_in <= 1; #10; // S_011 (Oops, my manual trace was wrong, let's re-verify)
                        // After S_0110, input 1 -> next_state = S_01
                        // From S_01, input 1 -> next_state = S_011
        x_in <= 0; #10; // S_0110 (y_out=1 again)

        // Test Case 4: Near misses and other patterns
        x_in <= 0; #10; // S_0
        x_in <= 1; #10; // S_01
        x_in <= 0; #10; // S_0
        x_in <= 1; #10; // S_01
        x_in <= 1; #10; // S_011
        x_in <= 1; #10; // S_IDLE
        x_in <= 0; #10; // S_0
        x_in <= 0; #10; // S_0
        x_in <= 1; #10; // S_01
        x_in <= 1; #10; // S_011
        x_in <= 0; #10; // S_0110 (y_out=1)

        // 4. End simulation
        #20;
        $display("Simulation Finished.");
        $finish;
    end

    // Monitor to display changes in signals
    initial begin
        $monitor("Time=%0t | Reset=%b | Input(x_in)=%b | State=%3b | Output(y_out)=%b",
                 $time, reset, x_in, dut.current_state, y_out);
    end

endmodule
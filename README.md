# Moore FSM Sequence Detector ("0110")

This project is a Moore finite state machine (FSM) designed in Verilog to detect the overlapping bit pattern “0110” from a serial input stream. It serves as a practical example of digital sequential logic design and verification, showcasing skills in hardware description languages and simulation.

---

## Key Features

* **Moore FSM Architecture**: The output (`y_out`) is dependent only on the current state, ensuring a glitch-free, synchronous output that is stable for an entire clock cycle.
* **Overlapping Detection**: The FSM is designed to correctly identify sequences that overlap. For example, in the input stream `0110110`, the machine will assert its output twice.
* **Structured Verilog**: The code is organized into distinct, easy-to-read blocks for state registers, next-state logic, and output logic, which is a best practice for synthesizable and maintainable code.
* **Comprehensive Testbench**: A thorough testbench (`tb_moore_detector.v`) is provided to simulate various input scenarios—including simple matches, non-matches, and overlapping sequences—to fully validate the FSM's functionality.

---

## Tools Used

* **Language**: Verilog
* **Simulation**: Icarus Verilog 12.0
* **Waveform Analysis**: GTKWave

---

## How to Run the Simulation

To run the simulation and verify the design, follow these steps in your terminal:

1.  **Compile the Verilog files:**
    This command compiles both the design and the testbench into a simulation executable.
    ```bash
    iverilog -o detector_sim moore_detector.v tb_moore_detector.v
    ```

2.  **Run the compiled simulation:**
    This command executes the simulation, which will print state changes and outputs to the console.
    ```bash
    vvp detector_sim
    ```

3.  **Analyze the results:**
    For a visual analysis of the signals over time, open the generated waveform file (`waveform.vcd`) with a viewer like GTKWave.
    ```bash
    gtkwave waveform.vcd
    ```
    In the waveform viewer, you can add signals like `clk`, `reset`, `x_in`, `current_state`, and `y_out` to observe that `y_out` goes high for one full clock cycle whenever the sequence `"0110"` is detected.

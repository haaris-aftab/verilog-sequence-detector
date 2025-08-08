//
// Moore FSM to detect overlapping sequence "0110"
//
// Design: moore_detector.v
// Author: Gemini
// Date:   August 08, 2025
//

module moore_detector (
    input  wire clk,
    input  wire reset,
    input  wire x_in,
    output reg  y_out
);

    // Define the states for the FSM
    // Using parameters makes the code more readable
    parameter S_IDLE = 3'b000; // Initial state, no part of sequence seen
    parameter S_0    = 3'b001; // "0" seen
    parameter S_01   = 3'b010; // "01" seen
    parameter S_011  = 3'b011; // "011" seen
    parameter S_0110 = 3'b100; // "0110" seen, output is high in this state

    // State registers
    reg [2:0] current_state, next_state;

    // State Transition Logic (Sequential Block)
    // This block updates the current state on the clock edge.
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S_IDLE; // Reset to the initial state
        end else begin
            current_state <= next_state;
        end
    end

    // Next State Logic (Combinational Block)
    // This block determines the next state based on the current state and input.
    always @(current_state or x_in) begin
        case (current_state)
            S_IDLE:
                // If we are in IDLE, we look for the first '0'
                if (x_in)
                    next_state = S_IDLE;
                else
                    next_state = S_0;
            S_0:
                // If we have a '0', we look for a '1'
                if (x_in)
                    next_state = S_01;
                else
                    next_state = S_0; // Still have a '0', stay in this state
            S_01:
                // If we have "01", we look for another '1'
                if (x_in)
                    next_state = S_011;
                else
                    next_state = S_0; // Sequence broke, but we got a '0'
            S_011:
                // If we have "011", we look for a '0' to complete the sequence
                if (x_in)
                    next_state = S_IDLE; // Sequence broke, got "0111"
                else
                    next_state = S_0110; // Sequence complete!
            S_0110:
                // We found "0110". Now check for an overlapping sequence.
                // The last bit was '0', which could be the start of a new sequence.
                if (x_in)
                    next_state = S_01; // Got a '1', so we have "01" for a new sequence
                else
                    next_state = S_0; // Got another '0', so we have "0" for a new sequence
            default:
                next_state = S_IDLE; // Default case to avoid latches
        endcase
    end

    // Output Logic (Combinational Block for Moore FSM)
    // The output is determined ONLY by the current state.
    always @(current_state) begin
        if (current_state == S_0110) begin
            y_out = 1'b1; // Output is high only when the sequence is detected
        end else begin
            y_out = 1'b0;
        end
    end

endmodule
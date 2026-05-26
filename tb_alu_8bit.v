// ============================================================
// Testbench for 8-bit ALU with Manchester Carry Adder
// ============================================================
`timescale 1ns/1ps

module tb_alu_8bit;

    reg  [7:0] a, b;
    reg  [2:0] op;
    wire [7:0] result;
    wire       carry_out, zero_flag, negative_flag;

    // Instantiate the ALU
    alu_8bit uut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .carry_out(carry_out),
        .zero_flag(zero_flag),
        .negative_flag(negative_flag)
    );

    // Task to display results nicely
    task show_result;
        input [7:0] in_a, in_b;
        input [2:0] in_op;
        input [63:0] op_name; // just for display
        begin
            #10;
            $display("OP: %s | A=%0d B=%0d | Result=%0d | Carry=%b | Zero=%b | Neg=%b",
                     op_name, in_a, in_b, result, carry_out, zero_flag, negative_flag);
        end
    endtask

    initial begin
        $display("============================================");
        $display("   8-bit ALU Simulation - ChipMIT 2026    ");
        $display("============================================");

        // --- ADD ---
        a = 8'd45;  b = 8'd30;  op = 3'b000; #10;
        $display("ADD  | A=%0d + B=%0d = %0d | Carry=%b | Zero=%b", a, b, result, carry_out, zero_flag);

        // ADD with overflow
        a = 8'd200; b = 8'd100; op = 3'b000; #10;
        $display("ADD  | A=%0d + B=%0d = %0d | Carry=%b (overflow!)", a, b, result, carry_out);

        // --- SUB ---
        a = 8'd50;  b = 8'd20;  op = 3'b001; #10;
        $display("SUB  | A=%0d - B=%0d = %0d | Carry=%b", a, b, result, carry_out);

        // SUB result = 0 (zero flag)
        a = 8'd25;  b = 8'd25;  op = 3'b001; #10;
        $display("SUB  | A=%0d - B=%0d = %0d | Zero=%b", a, b, result, zero_flag);

        // --- AND ---
        a = 8'b11001100; b = 8'b10101010; op = 3'b010; #10;
        $display("AND  | A=%b & B=%b = %b", a, b, result);

        // --- OR ---
        a = 8'b11001100; b = 8'b10101010; op = 3'b011; #10;
        $display("OR   | A=%b | B=%b = %b", a, b, result);

        // --- XOR ---
        a = 8'b11001100; b = 8'b10101010; op = 3'b100; #10;
        $display("XOR  | A=%b ^ B=%b = %b", a, b, result);

        // --- NOT ---
        a = 8'b11001100; op = 3'b101; #10;
        $display("NOT  | ~A=%b = %b", a, result);

        // --- SHL ---
        a = 8'd5; op = 3'b110; #10;
        $display("SHL  | A=%0d << 1 = %0d | Carry(MSB)=%b", a, result, carry_out);

        // --- SHR ---
        a = 8'd20; op = 3'b111; #10;
        $display("SHR  | A=%0d >> 1 = %0d | Carry(LSB)=%b", a, result, carry_out);

        $display("============================================");
        $display("        Simulation Complete!               ");
        $display("============================================");

        $finish;
    end

    // Dump waveforms for GTKWave
    initial begin
        $dumpfile("alu_sim.vcd");
        $dumpvars(0, tb_alu_8bit);
    end

endmodule

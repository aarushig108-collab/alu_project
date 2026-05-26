// ============================================================
// Manchester Carry Chain - 1-bit Generate/Propagate Cell
// ============================================================
module mcc_cell (
    input  a,
    input  b,
    output g,   // Generate: a AND b
    output p    // Propagate: a XOR b
);
    assign g = a & b;
    assign p = a ^ b;
endmodule

// ============================================================
// 8-bit Manchester Carry Chain Adder
// Uses carry lookahead logic based on G and P signals
// ============================================================
module manchester_carry_adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    output [7:0] sum,
    output       cout
);
    wire [7:0] g, p;
    wire [8:0] c; // c[0]=cin, c[8]=cout

    // Generate G and P for each bit
    mcc_cell cell0 (.a(a[0]), .b(b[0]), .g(g[0]), .p(p[0]));
    mcc_cell cell1 (.a(a[1]), .b(b[1]), .g(g[1]), .p(p[1]));
    mcc_cell cell2 (.a(a[2]), .b(b[2]), .g(g[2]), .p(p[2]));
    mcc_cell cell3 (.a(a[3]), .b(b[3]), .g(g[3]), .p(p[3]));
    mcc_cell cell4 (.a(a[4]), .b(b[4]), .g(g[4]), .p(p[4]));
    mcc_cell cell5 (.a(a[5]), .b(b[5]), .g(g[5]), .p(p[5]));
    mcc_cell cell6 (.a(a[6]), .b(b[6]), .g(g[6]), .p(p[6]));
    mcc_cell cell7 (.a(a[7]), .b(b[7]), .g(g[7]), .p(p[7]));

    // Manchester Carry Chain: carry lookahead
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);
    assign c[5] = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]) | (p[4] & p[3] & p[2] & p[1] & g[0]) | (p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);
    assign c[6] = g[5] | (p[5] & g[4]) | (p[5] & p[4] & g[3]) | (p[5] & p[4] & p[3] & g[2]) | (p[5] & p[4] & p[3] & p[2] & g[1]) | (p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) | (p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);
    assign c[7] = g[6] | (p[6] & g[5]) | (p[6] & p[5] & g[4]) | (p[6] & p[5] & p[4] & g[3]) | (p[6] & p[5] & p[4] & p[3] & g[2]) | (p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);
    assign c[8] = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]) | (p[7] & p[6] & p[5] & p[4] & g[3]) | (p[7] & p[6] & p[5] & p[4] & p[3] & g[2]) | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);

    // Sum = P XOR Carry-in at each bit
    assign sum = p ^ c[7:0];
    assign cout = c[8];

endmodule

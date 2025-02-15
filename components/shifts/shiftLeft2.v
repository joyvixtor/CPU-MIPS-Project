module shiftLeft2(
    input wire [31:0] sign_extend,
    output wire [31:0] out
);
    assign out = sign_extend << 2;

endmodule
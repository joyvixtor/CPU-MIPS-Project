module shiftLet16(
    input wire [15:0] sign_extend,
    output wire [31:0] out
);
    assign out = sign_extend << 16;
endmodule
module shiftLeft26_28(
    input wire [25:0] sign_extend,
    output wire [27:0] out
);
    assign out = {sign_extend, 2'b00};

endmodule
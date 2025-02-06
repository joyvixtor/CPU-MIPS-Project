module sgnExtnd1_32(
    input wire sign_extend,
    output wire [31:0] out
);

    assign out = {31'b0, sign_extend};

endmodule
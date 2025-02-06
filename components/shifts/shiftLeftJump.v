module shiftLetJump(
    input wire [4:0] instruction25_21,
    input wire [4:0] instruction20_16,
    input wire [15:0] instruction15_0,
    input wire [31:0] pc,
    output wire [31:0] out
);

    wire [27:0] shifted;

    assign shifted = {instruction25_21, instruction20_16, instruction15_0};

    assign out = {pc[31:28], (shifted << 2)};

endmodule
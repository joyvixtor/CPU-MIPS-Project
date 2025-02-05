module muxRegDst (
    input wire [1:0] selector,
    input wire [4:0] data_0, data_1,
    output reg [4:0] out
);

    always @* begin
        case(selector)

            2'b00: out = data_0;
            2'b01: out = data_1;
            2'b10: out = 29;
            2'b11: out = 31;

        endcase
    end
endmodule
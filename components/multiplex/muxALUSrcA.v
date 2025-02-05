module muxALUSrcA(
    input wire [1:0] selector,
    input wire [31:0] data_0, data_1,
    output reg [31:0] out
);

    always @* begin
        case(selector)

            2'b00: out = data_0;
            2'b01: out = data_1;
            2'b10: out = 0;

        endcase
    end
endmodule
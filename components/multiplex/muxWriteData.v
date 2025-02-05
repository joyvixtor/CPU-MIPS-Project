module muxWriteData (
    input wire [2:0] selector,
    input wire [4:0] data_0, data_1, data_2, data_3, data 4, data_5,
    output reg [4:0] out
);

    always @* begin
        case(selector)

            3'b000: out = data_0;
            3'b001: out = data_1;
            3'b010: out = data_2;
            3'b011: out = data_3;
            3'b100: out = data_4;
            3'b101: out = data_5;
            3'b110: out = 227;

        endcase
    end
endmodule
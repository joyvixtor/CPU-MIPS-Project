module muxALUSrcB(
    input wire [2:0] selector,
    input wire [31:0] data_0, data_1, data_2, data_3,
    output reg [31:0] out
);

    always @* begin
        case(selector)

            3'b000: out = data_0;
            3'b001: out = 4;
            3'b010: out = data_1;
            3'b011: out = data_2;
            3'b100: out = data_3;	

        endcase
    end
endmodule
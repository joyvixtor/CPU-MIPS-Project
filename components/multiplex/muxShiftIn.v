module muxShiftIn(
    input wire selector,
    input wire [31:0] data_0, data_1,
    output reg [31:0] out
);

    always @* begin
        case(selector)
            
            1'b0: out = data_0;
            1'b1: out = data_1;

        endcase
    end
endmodule
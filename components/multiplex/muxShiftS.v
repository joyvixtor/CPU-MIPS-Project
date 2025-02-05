module muxShiftS(
    input wire [1:0] selector,
    input wire [4:0] data_0,
    output reg [4:0] out
);

    always @* begin
        case(selector)
            
            2'b00: out = data_0;
            2'b01: out = 16;

        endcase
    end
endmodule
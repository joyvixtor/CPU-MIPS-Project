module muxExCause (
    input wire [1:0] selector,
    output reg [31:0] out
);

    always @*begin
        case(selector)
            2'b00: out = 253;
            2'b01: out = 254;
            2'b10: out = 255;
            default: out = 0;
            
        endcase
    end
endmodule
module muxShiftS(
    input wire selector,
    input wire [4:0] data_0,
    output reg [4:0] out
);

    always @* begin
        case(selector)
            
            1'b0: out = data_0;
            1'b1: out = 16;

        endcase
    end
endmodule
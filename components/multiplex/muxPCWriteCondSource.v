module muxShiftIn(
    input wire selector,
    input wire data_0, data_1,
    output reg out
);

    always @* begin
        case(selector)
            
            2'b00: out = data_0;
            2'b01: out = data_1;

        endcase
    end
endmodule
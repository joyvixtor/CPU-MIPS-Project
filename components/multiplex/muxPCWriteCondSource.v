module muxShiftIn(
    input wire selector,
    input wire data_0,
    output reg out
);

    //NEGACAO DE ZERO (NOT EQUAL)
    assign data_1 = ~data_0;

    always @* begin
        case(selector)
            
            1'b0: out = data_0;
            1'b1: out = data_1;

        endcase
    end
endmodule
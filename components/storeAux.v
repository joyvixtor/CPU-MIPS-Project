module storeAux (
    input wire controleSS,
    input wire [31:0] MDR_out,
    input wire [31:0] B_out,
    output reg [31:0] ss_out
);

always @(*) begin
    case (controleSS)
    1'b0: 
        ss_out <= B_out;
    1'b1:
        ss_out <= {MDR_out[31:8], B_out[7:0]};
    endcase
end

endmodule
module loadAux (
    input wire LScontroler,
    input wire [31:0] MDR_out,
    output reg [31:0] ls_component_out
);

always @(*) begin
        case (LScontroler)
            1'b0: 
                ls_component_out <= MDR_out;
            1'b1:
                 ls_component_out <= {24'd0, MDR_out[7:0]};
        endcase
    
end
endmodule
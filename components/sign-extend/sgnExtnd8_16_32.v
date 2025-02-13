module sgnExtnd1_32(
    input wire selector,
    input wire [7:0] data_mdr,
    input wire [15:0] data_instruction,
    output wire [31:0] out
);

    wire [31:0] out_mdr, out_instruction

    assign out_instruction =  (Data_in[15]) ? {{16{1'b1}}, Data_in} : {{16{1'b0}}, Data_in};;

    assign out_mdr = {24'b0, data_instruction};

    assign out = (selector == 1'b0) ? out_instruction : out_mdr;


endmodule
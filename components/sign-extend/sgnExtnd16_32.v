module sgnExtnd1_32(
    input wire [15:0] sign_extend,
    output wire [31:0] out
);

    assign out =  (Data_in[15]) ? {{16{1'b1}}, Data_in} : {{16{1'b0}}, Data_in};;

endmodule
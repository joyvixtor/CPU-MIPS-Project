module divUnit (
    //signals
    input wire        clk,
    input wire        reset,
    input wire        divOP,

    //inputs
    input wire [31:0] A,
    input wire [31:0] B,

    //outputs
    output reg        divByZero,
    output reg [31:0] quotient,
    output reg [31:0] remainder
);

    reg working;
    integer counter;
    reg signal_quotient; 
    reg signal_A; 

    reg [31:0] aux_quotient;
    reg [63:0] aux_remainder;
    reg [63:0] aux_divisor;
    reg [63:0] diff;

    always @(posedge clk) begin
        if (reset || (divOP == 0 && working == 0)) begin
            working = 0;
            counter = 0;
            signal_quotient = 0;
            signal_A = 0;
            aux_quotient = 0;
            aux_remainder = 0;
            aux_divisor = 0;
            diff = 0;
            divByZero = 0;
            quotient = 0;
            remainder = 0;
        end

        else if (divOP) begin
            if (B == 0) begin
                divByZero <= 1;
            end

            else begin
                divByZero <= 0;
                working <= 1;
                counter <= 0;

                signal_A <= A[31];

                aux_quotient <= 0;

                if (A[31] == 1) begin
                    aux_remainder <= {32'b0, (~A + 1'b1)};
                end

                else begin
                    aux_remainder <= {32'b0, A};
                end

                if (B[31] == 1) begin
                    aux_divisor <= {(~B + 1'b1), {32{1'b0}}};
                end

                else begin
                    aux_divisor <= {B, {32{1'b0}}};
                end

                if (A[31] == B[31]) begin
                    signal_quotient <= 0;
                end

                else begin
                    signal_quotient <= 1;
                end
            end
        end

        // working == operacao acontecendo
        else if (working) begin
            // 34 ciclos da divisao
            if (counter == 34) begin
                if (signal_quotient == 0) begin
                    quotient <= aux_quotient;
                end
                
                else begin
                    quotient <= (~aux_quotient + 1'b1);
                end

                if (signal_A == 0) begin
                    remainder <= aux_remainder[31:0];
                end
                
                else begin
                    remainder <= (~(aux_remainder[31:0]) + 1'b1);
                end

                working <= 0;
            end

            else begin
                diff = aux_remainder - aux_divisor;

                if ((diff[63]) == 0) begin
                    aux_remainder <= diff;

                    aux_quotient <= {aux_quotient[30:0], 1'b1};
                end

                else begin
                    aux_quotient <= aux_quotient << 1;
                end

                aux_divisor <= aux_divisor >>> 1;

                counter <= counter + 1;
            end
        end
    end
endmodule
module multUnit (
    //signals
    input wire        clk,
    input wire        reset,
    input wire        multOP,

    //inputs
    input wire [31:0] A, // Multiplicando
    input wire [31:0] B, // Multiplicador

    //outputs
    output reg [31:0] resultHigh,
    output reg [31:0] resultLow
);

    reg working;
    integer counter;

    reg [63:0] aux_A;
    reg [31:0] aux_B;
    reg [63:0] product;

    reg signal_A;
    reg signal_B;

    always @(posedge clk) begin
        if (reset) begin
            resultHigh = 0;
            resultLow = 0;
            working = 0;
            counter = 0;
            aux_A = 0;
            aux_B = 0;
            product = 0;
        end

        // multOP == 1 -> starta multiplicacao
        if (multOP) begin
            working <= 1;
            counter <= 0;

            product <= 0;
            
            if (B[31] == 1) begin
                aux_B <= (~B + 1'b1);
            end

            else begin 
                aux_B <= B;
            end

            if (A[31] == 1) begin
                aux_A <= {32'b0, (~A + 1'b1)};
            end

            else begin 
                aux_A <= {32'b0, A};
            end

            signal_A <= A[31];
            signal_B <= B[31];
        end

        // working == operacao em andamento
        else if (working) begin
            // Passaram-se os 34 ciclos e a multiplicação acabou
            if (counter == 34) begin
                if (signal_A != signal_B) begin
                    product = (~product + 1'b1);
                end

                resultLow <= product[31:0];

                resultHigh <= product[63:32];

                working <= 0;
            end

            // Iteração da multiplicação
            else begin
                if (aux_B[0] == 1) begin
                    product <= product + aux_A;
                end

                aux_A <= aux_A << 1;

                aux_B <= aux_B >>> 1;

                counter <= counter + 1;
            end
        end
    end
endmodule
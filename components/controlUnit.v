module controlUnit(
    input wire clk,
    input wire reset,

    input wire overflow,
    input wire zero,

    //Instructions
    input wire [5:0] opcode,
    input wire [5:0] funct,

    //Operations
    output reg divOP,
    output reg multOP,
    output reg [2:0] ALUOP,
    output reg [2:0] shiftOP,
    output reg [2:0] shiftCtrl,

    //Muxes
    output reg [2:0] WriteData,
    output reg [1:0] muxShiftS,
    output reg [1:0] muxShiftIn,
    output reg [1:0] RegDst,
    output reg muxPCWriteCondSource,
    output reg [1:0] PCSrc,
    output reg MultDiv,
    output reg [1:0] IorD,
    output reg [1:0] ExCause,
    output reg [1:0] ALUSrcA,
    output reg [1:0] ALUSrcB,

    //Registradores
    //COR VERMELHA
    output reg PCWriteCond,
    output reg PCWrite,
    output reg MDRCtrl,
    output reg LoadAB,
    output reg ALUOut,
    output reg EPCWrite,
    output reg HiLow,
    output reg AuxMultDivA,
    output reg AuxMultDivB,
    output reg [1:0] SCtrl,
    output reg [1:0] LCtrl

    // COR VERDE NO DIAGRAMA
    output reg MemWrite,
    output reg MemRead,
    output reg IRWrite,
    output reg RegWrite,

    //SIGN EXTND ESPECIAL
    output reg SignExtndCtrl,
);

    reg [5:0] STATE;
    integer COUNTER;

    //STATES
    parameter ST_ADD = 6'b000000, //0
    parameter ST_ADDI = 6'b000001, //1
    parameter ST_COMMON = 6'b100010; //34

    //FUNCTS
    parameter ADD = 6'h20;
    parameter AND = 6'h24;



    always @(posedge clk) begin
        if (reset) begin
            //SINAIS OPERACOES
            divOP = 1'b0;
            multOP = 1'b0;
            shiftOP = 3'b000;
            shiftCtrl = 3'b000;
            ALUOP = 3'b000;

            //MUXES
            WriteData = 3'b110;
            muxShiftS = 2'b00;
            muxShiftIn = 2'b00;
            RegDst = 2'b10;
            muxPCWriteCondSource = 1'b0;
            PCSrc = 2'b00;
            MultDiv = 1'b0;
            IorD = 2'b00;
            ExCause = 2'b00;
            ALUSrcA = 2'b00;
            ALUSrcB = 2'b00;

            COUNTER = 0;
            STATE = ST_COMMON;

            //REGISTRADORES
            PCWriteCond = 1'b0;
            PCWrite = 1'b0;
            MDRCtrl = 1'b0;
            LoadAB = 1'b0;
            ALUOut = 1'b0;
            EPCWrite = 1'b0;
            HiLow = 1'b0;
            AuxMultDivA = 1'b0;
            AuxMultDivB = 1'b0;
            SCtrl = 2'b00;
            LCtrl = 2'b00;

            //REGISTRADORES GRANDES (VERDES)
            MemWrite = 1'b0;
            MemRead = 1'b0;
            IRWrite = 1'b0;
            RegWrite = 1'b1;
        end

        else if (overflow && STATE != ST_ADDIU && STATE != ST_AND) begin
            
        end

        else if (divByZero) begin
            
        end

        else begin
            case(STATE)
                ST_COMMON: begin
                    //FETCH
                    if(COUNTER <= 2) begin

                    end
                end
            endcase
        end
    end

endmodule

// TO  DO:
// VERIFICAR SE OS SINAIS JÁ ESTÃO CORRETOS
// 1. Implementar os estados
// 2. Implementar as operações
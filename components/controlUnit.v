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
    //FORMATO R
    parameter ST_ADD = 6'b000000; //0
    parameter ST_AND = 6'b000001; //1
    parameter ST_DIV = 6'b000010; //2
    parameter ST_MULT = 6'b000011; //3
    parameter ST_JR = 6'b000100; //4
    parameter ST_MFHI = 6'b000101; //5
    parameter ST_MFLO = 6'b000110; //6
    parameter ST_SLL = 6'b000111; //7
    parameter ST_SLT = 6'b001000; //8
    parameter ST_SRA = 6'b001001; //9
    parameter ST_SUB = 6'b001010; //10
    parameter ST_DIVM = 6'b001011; //11

    //FORMATO I
    parameter ST_ADDI = 6'b001100; //12
    parameter ST_LW = 6'b001101; //13
    parameter ST_SB = 6'b001110; //14
    parameter ST_SW = 6'b001111; //15
    parameter ST_LB = 6'b010000; //16
    parameter ST_BEQ = 6'b010001; //17
    parameter ST_ADDM = 6'b010010; //18
    parameter ST_LUI = 6'b010011; //19
    parameter ST_BNE = 6'b010100; //20

    //FORMATO J
    parameter ST_J = 6'b010101; //21
    parameter ST_JAL = 6'b010110; //22

    //INICIAIS E EXCECOES
    parameter ST_COMMON = 6'b010111; //23
    parameter ST_OVERFLOW = 6'b011000; //24
    parameter ST_DIVBYZERO = 6'b011001; //25
    parameter ST_OPCODEINVALID = 6'b011010; //26

    //FUNCTS
    //FORMATO R
    parameter ADD = 6'h20;
    parameter AND = 6'h24;
    parameter DIV = 6'h1A;
    parameter MULT = 6'h18;
    parameter JR = 6'h08
    parameter MFHI = 6'h10;
    parameter MFLO = 6'h12;
    parameter SLL = 6'h00;
    parameter SLT = 6'h2A;
    parameter SRA = 6'h03;
    parameter SUB = 6'h22;
    parameter DIVM = 6'h05;

    //FORMATO I
    parameter ADDI = 6'h08;
    parameter BEQ = 6'h04;
    parameter BNE = 6'h05;
    parameter ADDM = 6'h01;
    parameter LB = 6'h20;
    parameter LUI = 6'h0F;
    parameter LW = 6'h23;
    parameter SB = 6'h28;
    parameter SW = 6'h2B;

    //FORMATO J
    parameter J = 6'h02;
    parameter JAL = 6'h03;



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
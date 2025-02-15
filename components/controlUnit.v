module controlUnit(
    input wire clk,
    input wire reset,

    input wire overflow,
    input wire divByZero,

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
    output reg [2:0] WriteData, //
    output reg muxShiftS, //
    output reg muxShiftIn, //
    output reg [1:0] RegDst,
    output reg muxPCWriteCondSource, //
    output reg [1:0] PCSrc, //
    output reg MultDiv, //
    output reg [1:0] IorD, //
    output reg [1:0] ExCause, //
    output reg [1:0] ALUSrcA, //
    output reg [1:0] ALUSrcB, //
    output reg MemA,
    output reg MemB,

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
    output reg [1:0] LCtrl,

    // COR VERDE NO DIAGRAMA
    output reg MemReadWrite,
    output reg IRWrite,
    output reg RegWrite,

    //SIGN EXTND ESPECIAL
    output reg SignExtndCtrl
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
    parameter R = 6'b000000;
    //FORMATO R
    parameter ADD = 6'h20;
    parameter AND = 6'h24;
    parameter DIV = 6'h1A;
    parameter MULT = 6'h18;
    parameter JR = 6'h08;
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
            WriteData = 3'b110; //
            muxShiftS = 1'b0;
            muxShiftIn = 1'b0;
            RegDst = 2'b10; //
            muxPCWriteCondSource = 1'b0;
            PCSrc = 2'b00;
            MultDiv = 1'b0;
            IorD = 2'b00;
            ExCause = 2'b00;
            ALUSrcA = 2'b00;
            ALUSrcB = 2'b00;
            MemA = 1'b0;
            MemB = 1'b0;

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
            MemReadWrite = 1'b0;
            IRWrite = 1'b0;
            RegWrite = 1'b1; //

            SignExtndCtrl = 1'b0;
        end

        else if (overflow && STATE != ST_AND) begin
            divOP = 1'b0;
            multOP = 1'b0;
            shiftOP = 3'b000;
            shiftCtrl = 3'b000;
            ALUOP = 3'b000;

            WriteData = 3'b000;
            muxShiftS = 1'b0;
            muxShiftIn = 1'b0;
            RegDst = 2'b00;
            muxPCWriteCondSource = 1'b0;
            PCSrc = 2'b00;
            MultDiv = 1'b0;
            IorD = 2'b00;
            ExCause = 2'b00;
            ALUSrcA = 2'b00;
            ALUSrcB = 2'b00;
            MemA = 1'b0;
            MemB = 1'b0;

            COUNTER = 0;
            STATE = ST_OVERFLOW;

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

            MemReadWrite = 1'b0;
            IRWrite = 1'b0;
            RegWrite = 1'b0;

            SignExtndCtrl = 1'b0;
        end

        else if (divByZero) begin
            divOP = 1'b0;
            multOP = 1'b0;
            shiftOP = 3'b000;
            shiftCtrl = 3'b000;
            ALUOP = 3'b000;

            WriteData = 3'b000;
            muxShiftS = 1'b0;
            muxShiftIn = 1'b0;
            RegDst = 2'b00;
            muxPCWriteCondSource = 1'b0;
            PCSrc = 2'b00;
            MultDiv = 1'b0;
            IorD = 2'b00;
            ExCause = 2'b00;
            ALUSrcA = 2'b00;
            ALUSrcB = 2'b00;
            MemA = 1'b0;
            MemB = 1'b0;

            COUNTER = 0;
            STATE = ST_DIVBYZERO;

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

            MemReadWrite = 1'b0;
            IRWrite = 1'b0;
            RegWrite = 1'b0;

            SignExtndCtrl = 1'b0;
        end

        else begin
            case(STATE)
                ST_COMMON: begin
                    //FETCH
                    if(COUNTER <= 2) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b001; //

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00; //
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00; //
                        ALUSrcB = 2'b01; //
                        MemA = 1'b0;
                        MemB = 1'b0;

                        if(COUNTER == 0) begin
                            PCWrite = 1'b1; //
                        end
                        else begin
                            PCWrite = 1'b0; //
                        end

                        COUNTER = COUNTER + 1;
                        STATE = ST_COMMON;

                        PCWriteCond = 1'b0;
                        MDRCtrl = 1'b0;
                        LoadAB = 1'b0;
                        ALUOut = 1'b0;
                        EPCWrite = 1'b0;
                        HiLow = 1'b0;
                        AuxMultDivA = 1'b0;
                        AuxMultDivB = 1'b0;
                        SCtrl = 2'b00;
                        LCtrl = 2'b00;

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b1; //
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end

                    //DECODE
                    else if (COUNTER == 3) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b001;

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b10;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00; //
                        ALUSrcB = 2'b11; //
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = 0;
                        STATE = ST_COMMON;

                        PCWriteCond = 1'b0;
                        MDRCtrl = 1'b0;
                        LoadAB = 1'b1; //
                        ALUOut = 1'b1; //
                        EPCWrite = 1'b0;
                        HiLow = 1'b0;
                        AuxMultDivA = 1'b0;
                        AuxMultDivB = 1'b0;
                        SCtrl = 2'b00;
                        LCtrl = 2'b00;

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end

                    else if (COUNTER == 4) begin
                        case (opcode)
                            //TIPOS R
                            R : begin SignExtndCtrl = 1'b0;
                                case(funct)
                                    ADD : STATE = ST_ADD;
                                    AND : STATE = ST_AND;
                                    DIV : STATE = ST_DIV;
                                    MULT : STATE = ST_MULT;
                                    JR : STATE = ST_JR;
                                    MFHI : STATE = ST_MFHI;
                                    MFLO : STATE = ST_MFLO;
                                    SLL : STATE = ST_SLL;
                                    SLT : STATE = ST_SLT;
                                    SRA : STATE = ST_SRA;
                                    SUB : STATE = ST_SUB;
                                    DIVM : STATE = ST_DIVM;
                                    default : STATE = ST_OPCODEINVALID;
                                endcase
                            end
                            //TIPOS I
                            ADDI : STATE = ST_ADDI;
                            LW : STATE = ST_LW;
                            SB : STATE = ST_SB;
                            SW : STATE = ST_SW;
                            LB : STATE = ST_LB;
                            BEQ : STATE = ST_BEQ;
                            ADDM : STATE = ST_ADDM;
                            LUI : STATE = ST_LUI;
                            BNE : STATE = ST_BNE;
                            //TIPOS J
                            J : STATE = ST_J;
                            JAL : STATE = ST_JAL;
                            default : STATE = ST_OPCODEINVALID;
                        endcase

                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = 0;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                end

                //FORMATO R
                ST_ADD : begin
                    if (COUNTER == 0) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b001; //

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00; //
                        ExCause = 2'b00;
                        ALUSrcA = 2'b01; //
                        ALUSrcB = 2'b00; //
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_ADD;

                        PCWriteCond = 1'b0;
                        PCWrite = 1'b0;
                        MDRCtrl = 1'b0;
                        LoadAB = 1'b0;
                        ALUOut = 1'b1; //
                        EPCWrite = 1'b0;
                        HiLow = 1'b0;
                        AuxMultDivA = 1'b0;
                        AuxMultDivB = 1'b0;
                        SCtrl = 2'b00;
                        LCtrl = 2'b00;

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if(COUNTER == 1) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b010; //
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b01; //
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1; //
                        STATE = ST_ADD;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b1;

                        SignExtndCtrl = 1'b0;
                    end
                    else if(COUNTER == 2) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = 0;
                        STATE = ST_COMMON;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                end

                ST_AND : begin
                    if(COUNTER == 0) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b001; //

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00; //
                        ExCause = 2'b00;
                        ALUSrcA = 2'b01; //
                        ALUSrcB = 2'b00; //
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_AND;

                        PCWriteCond = 1'b0;
                        PCWrite = 1'b0;
                        MDRCtrl = 1'b0;
                        LoadAB = 1'b0;
                        ALUOut = 1'b1; //
                        EPCWrite = 1'b0;
                        HiLow = 1'b0;
                        AuxMultDivA = 1'b0;
                        AuxMultDivB = 1'b0;
                        SCtrl = 2'b00;
                        LCtrl = 2'b00;

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if(COUNTER == 1) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b010; //
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b01; //
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1; //
                        STATE = ST_AND;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b1; //

                        SignExtndCtrl = 1'b0;
                    end
                    else if(COUNTER == 2) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = 0;
                        STATE = ST_COMMON;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                end

                ST_DIV : begin
                    if (COUNTER == 0) begin
                        divOP = 1'b1; //
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000; 
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b1; //
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b1; //
                        MemB = 1'b1; //

                        COUNTER = COUNTER + 1;
                        STATE = ST_DIV;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER <= 34) begin
                        divOP = 1'b0; //
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000; 
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b1; //
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_DIV;

                        PCWriteCond = 1'b0;
                        PCWrite = 1'b0;
                        MDRCtrl = 1'b0;
                        LoadAB = 1'b0;
                        ALUOut = 1'b0;
                        EPCWrite = 1'b0;
                        HiLow = 1'b1; //
                        AuxMultDivA = 1'b0;
                        AuxMultDivB = 1'b0;
                        SCtrl = 2'b00;
                        LCtrl = 2'b00;

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER == 35) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000; 
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = 0;
                        STATE = ST_COMMON;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                end

                ST_MULT : begin
                    if (COUNTER == 0) begin
                        divOP = 1'b0;
                        multOP = 1'b1; //
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000; 
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0; //
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0; //
                        MemB = 1'b0; //

                        COUNTER = COUNTER + 1;
                        STATE = ST_MULT;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER <= 34) begin
                        divOP = 1'b0;
                        multOP = 1'b0; //
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000; 
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0; //
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_MULT;

                        PCWriteCond = 1'b0;
                        PCWrite = 1'b0;
                        MDRCtrl = 1'b0;
                        LoadAB = 1'b0;
                        ALUOut = 1'b0;
                        EPCWrite = 1'b0;
                        HiLow = 1'b1; //
                        AuxMultDivA = 1'b0;
                        AuxMultDivB = 1'b0;
                        SCtrl = 2'b00;
                        LCtrl = 2'b00;

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER == 35) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000; 
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = 0;
                        STATE = ST_COMMON;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                end

                ST_JR : begin
                    divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000; //

                        WriteData = 3'b000; 
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00; //
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b01; //
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = 0;
                        STATE = ST_COMMON;

                        PCWriteCond = 1'b0;
                        PCWrite = 1'b1; //
                        MDRCtrl = 1'b0;
                        LoadAB = 1'b0;
                        ALUOut = 1'b0;
                        EPCWrite = 1'b0;
                        HiLow = 1'b0;
                        AuxMultDivA = 1'b0;
                        AuxMultDivB = 1'b0;
                        SCtrl = 2'b00;
                        LCtrl = 2'b00;

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                end

                ST_MFHI : begin
                    if (COUNTER <= 1) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b010; // 
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b01; //
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_MFHI;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b1; //

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER == 2) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000; 
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = 0;
                        STATE = ST_COMMON;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                end

                ST_MFLO : begin 
                    if (COUNTER <= 1) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b011; //
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b01; //
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_MFLO;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b1; //

                        SignExtndCtrl = 1'b0;
                    end
                    if (COUNTER == 2) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000; 
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = 0;
                        STATE = ST_COMMON;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                end

                ST_SLL : begin 
                    if (COUNTER == 0) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b001; //
                        ALUOP = 3'b000; 

                        WriteData = 3'b000; 
                        muxShiftS = 2'b00; //
                        muxShiftIn = 2'b00; //
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_SLL;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER == 1) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b010; //
                        ALUOP = 3'b000;

                        WriteData = 3'b000; 
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_SLL;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER == 2) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000; //
                        ALUOP = 3'b000;

                        WriteData = 3'b100; // 
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b01; //
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = 0;
                        STATE = ST_COMMON;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b1; //

                        SignExtndCtrl = 1'b0;
                    end
                end

                ST_SRA : begin 
                    if (COUNTER == 0) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b001; //
                        ALUOP = 3'b000; 

                        WriteData = 3'b000; 
                        muxShiftS = 2'b00; //
                        muxShiftIn = 2'b00; //
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_SLL;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER == 1) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b100; //
                        ALUOP = 3'b000;

                        WriteData = 3'b000; 
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_SLL;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER == 2) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000; //
                        ALUOP = 3'b000;

                        WriteData = 3'b100; // 
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b01; //
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = 0;
                        STATE = ST_COMMON;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b1; //

                        SignExtndCtrl = 1'b0;
                    end
                end

                ST_SUB : begin
                    if (COUNTER == 0) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b010; //

                        WriteData = 3'b000;
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00; //
                        ExCause = 2'b00;
                        ALUSrcA = 2'b01; //
                        ALUSrcB = 2'b00; //
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_SUB;

                        PCWriteCond = 1'b0;
                        PCWrite = 1'b0;
                        MDRCtrl = 1'b0;
                        LoadAB = 1'b0;
                        ALUOut = 1'b1; //
                        EPCWrite = 1'b0;
                        HiLow = 1'b0;
                        AuxMultDivA = 1'b0;
                        AuxMultDivB = 1'b0;
                        SCtrl = 2'b00;
                        LCtrl = 2'b00;

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER == 1) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b010; //
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b01; //
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_SUB;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b1;

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER == 2) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000;
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = 0;
                        STATE = ST_COMMON;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                end
                
                ST_DIVM : begin
                    if (COUNTER == 0) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000; //

                        WriteData = 3'b000;
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b01; //
                        ALUSrcB = 2'b00; //
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_DIVM;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                end

                ST_SLT : begin
                    divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b111; //

                        WriteData = 3'b001; //
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b01; //
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b01; //
                        ALUSrcB = 2'b00; //
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = 0;
                        STATE = ST_COMMON;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b1; //

                        SignExtndCtrl = 1'b0;
                end
                //FORMATO I
                ST_ADDI : begin
                    if(COUNTER == 0) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b001; //

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00; 
                        ExCause = 2'b00;
                        ALUSrcA = 2'b10; //
                        ALUSrcB = 2'b10; //
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_ADDI;

                        PCWriteCond = 1'b0;
                        PCWrite = 1'b0;
                        MDRCtrl = 1'b0;
                        LoadAB = 1'b0;
                        ALUOut = 1'b1; //
                        EPCWrite = 1'b0;
                        HiLow = 1'b0;
                        AuxMultDivA = 1'b0;
                        AuxMultDivB = 1'b0;
                        SCtrl = 2'b00;
                        LCtrl = 2'b00;

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0; //
                    end
                    else if(COUNTER == 1) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000; //
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b01; //
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_ADDI;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b1; //

                        SignExtndCtrl = 1'b0;
                    end
                    else if(COUNTER == 2) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = 0;
                        STATE = ST_COMMON;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                end

                ST_LW : begin
                    if(COUNTER == 0) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b001; //

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b11; //
                        ExCause = 2'b00;
                        ALUSrcA = 2'b01; //
                        ALUSrcB = 2'b10; //
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_LW;

                        PCWriteCond = 1'b0;
                        PCWrite = 1'b0;
                        MDRCtrl = 1'b0;
                        LoadAB = 1'b0;
                        ALUOut = 1'b1; //
                        EPCWrite = 1'b0;
                        HiLow = 1'b0;
                        AuxMultDivA = 1'b0;
                        AuxMultDivB = 1'b0;
                        SCtrl = 2'b00;
                        LCtrl = 2'b00;

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if(COUNTER == 1 || COUNTER == 2) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b11; //
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_LW;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER == 3 || COUNTER == 4) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b101; //
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00; //
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b11; //
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1; //
                        STATE = ST_LW;

                        PCWriteCond = 1'b0;
                        PCWrite = 1'b0;
                        MDRCtrl = 1'b1; //
                        LoadAB = 1'b0;
                        ALUOut = 1'b0;
                        EPCWrite = 1'b0;
                        HiLow = 1'b0;
                        AuxMultDivA = 1'b0;
                        AuxMultDivB = 1'b0;
                        SCtrl = 2'b00;
                        LCtrl = 2'b00; //

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b1; //

                        SignExtndCtrl = 1'b0;
                    end 
                    else if (COUNTER == 5)begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = 0;
                        STATE = ST_COMMON;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                end

                ST_SB : begin
                    if(COUNTER == 0) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b001; //

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b01; //
                        ALUSrcB = 2'b10; //
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_SB;

                        PCWriteCond = 1'b0;
                        PCWrite = 1'b0;
                        MDRCtrl = 1'b0;
                        LoadAB = 1'b0;
                        ALUOut = 1'b1; //
                        EPCWrite = 1'b0;
                        HiLow = 1'b0;
                        AuxMultDivA = 1'b0;
                        AuxMultDivB = 1'b0;
                        SCtrl = 2'b00;
                        LCtrl = 2'b00;

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0; //
                    end
                    else if (COUNTER == 1 || COUNTER == 2) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b11; //
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_SB;

                        PCWriteCond = 1'b0;
                        PCWrite = 1'b0;
                        MDRCtrl = 1'b0;
                        LoadAB = 1'b0;
                        ALUOut = 1'b0;
                        EPCWrite = 1'b0;
                        HiLow = 1'b0;
                        AuxMultDivA = 1'b0;
                        AuxMultDivB = 1'b0;
                        SCtrl = 2'b10 ; 
                        LCtrl = 2'b00;

                        MemReadWrite = 1'b0; //
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER == 3 || COUNTER == 4) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00; //
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b11; //
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_SB;

                        PCWriteCond = 1'b0;
                        PCWrite = 1'b0;
                        MDRCtrl = 1'b1; //
                        LoadAB = 1'b0;
                        ALUOut = 1'b0;
                        EPCWrite = 1'b0;
                        HiLow = 1'b0;
                        AuxMultDivA = 1'b0;
                        AuxMultDivB = 1'b0;
                        SCtrl = 2'b10; //
                        LCtrl = 2'b00;

                        MemReadWrite = 1'b1; //
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER == 5) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = 0;
                        STATE = ST_COMMON;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                end

                ST_SW : begin
                    if (COUNTER == 0) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b001; //

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b11; //
                        ExCause = 2'b00;
                        ALUSrcA = 2'b01; //
                        ALUSrcB = 2'b10; //
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_SW;

                        PCWriteCond = 1'b0;
                        PCWrite = 1'b0;
                        MDRCtrl = 1'b0;
                        LoadAB = 1'b0;
                        ALUOut = 1'b1; //
                        EPCWrite = 1'b0;
                        HiLow = 1'b0;
                        AuxMultDivA = 1'b0;
                        AuxMultDivB = 1'b0;
                        SCtrl = 2'b00;
                        LCtrl = 2'b00;

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER == 1 || COUNTER == 2) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000; //
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b11; //
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1; //
                        STATE = ST_SW; //

                        PCWriteCond = 1'b0;
                        PCWrite = 1'b0;
                        MDRCtrl = 1'b1; //
                        LoadAB = 1'b0;
                        ALUOut = 1'b0;
                        EPCWrite = 1'b0;
                        HiLow = 1'b0;
                        AuxMultDivA = 1'b0;
                        AuxMultDivB = 1'b0;
                        SCtrl = 2'b00;
                        LCtrl = 2'b00;

                        MemReadWrite = 1'b1; //
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER == 3 || COUNTER == 4) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_SW;

                        PCWriteCond = 1'b0;
                        PCWrite = 1'b0;
                        MDRCtrl = 1'b0;
                        LoadAB = 1'b0;
                        ALUOut = 1'b0;
                        EPCWrite = 1'b0;
                        HiLow = 1'b0;
                        AuxMultDivA = 1'b0;
                        AuxMultDivB = 1'b0;
                        SCtrl = 2'b10; //
                        LCtrl = 2'b00;

                        MemReadWrite = 1'b1; // 
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER == 5) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = 0;
                        STATE = ST_COMMON;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                end

                ST_LB : begin
                    if (COUNTER == 0) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b001; //

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b01; //
                        ALUSrcB = 2'b10; //
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_LB;

                        PCWriteCond = 1'b0;
                        PCWrite = 1'b0;
                        MDRCtrl = 1'b0;
                        LoadAB = 1'b0;
                        ALUOut = 1'b1; //
                        EPCWrite = 1'b0;
                        HiLow = 1'b0;
                        AuxMultDivA = 1'b0;
                        AuxMultDivB = 1'b0;
                        SCtrl = 2'b00;
                        LCtrl = 2'b00;

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER == 1 || COUNTER == 2) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b11; //
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_LB;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER == 3 || COUNTER == 4) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b101; //
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00; //
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b11; //
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_LB;

                        PCWriteCond = 1'b0;
                        PCWrite = 1'b0;
                        MDRCtrl = 1'b1; //
                        LoadAB = 1'b0;
                        ALUOut = 1'b0;
                        EPCWrite = 1'b0;
                        HiLow = 1'b0;
                        AuxMultDivA = 1'b0;
                        AuxMultDivB = 1'b0;
                        SCtrl = 2'b00;
                        LCtrl = 2'b10; //

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b1; //

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER == 5) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = 0;
                        STATE = ST_COMMON;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                end

                ST_BEQ : begin
                    if (COUNTER <= 1) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b010; //

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0; //
                        PCSrc = 2'b10; //
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b01; //
                        ALUSrcB = 2'b00; //
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_BEQ;

                        PCWriteCond = 1'b1; //
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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER == 2) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = 0;
                        STATE = ST_COMMON;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end 
                end

                ST_BNE : begin
                    if (COUNTER <= 1) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b010; //

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b1; //
                        PCSrc = 2'b10; //
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b01; //
                        ALUSrcB = 2'b00; //
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_BNE;

                        PCWriteCond = 1'b1; //
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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    if(COUNTER == 2) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = 0;
                        STATE = ST_COMMON;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                end

                ST_ADDM : begin
                    if (COUNTER == 0) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000; //

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b01; //
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_ADDM;

                        PCWriteCond = 1'b0;
                        PCWrite = 1'b0;
                        MDRCtrl = 1'b0;
                        LoadAB = 1'b0;
                        ALUOut = 1'b1; //
                        EPCWrite = 1'b0;
                        HiLow = 1'b0;
                        AuxMultDivA = 1'b0;
                        AuxMultDivB = 1'b0;
                        SCtrl = 2'b00;
                        LCtrl = 2'b00;

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER == 1 || COUNTER == 2) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000;
                        muxShiftS = 1'b0;
                        muxShiftIn = 1'b0;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b10; //
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_ADDM;

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
                        LCtrl = 2'b10; //

                        MemReadWrite = 1'b0; //
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                end

                ST_LUI : begin
                    if (COUNTER == 0) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b001; //
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000;
                        muxShiftS = 1'b1; //
                        muxShiftIn = 1'b1; //
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b10; //
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER + 1;
                        STATE = ST_LUI;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER == 1) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b010; //
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000;
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = COUNTER;
                        STATE = ST_LUI;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if(COUNTER == 2) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b100; //
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = 0;
                        STATE = ST_COMMON;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                end

                //J FORMAT
                ST_J : begin
                    divOP = 1'b0;
                    multOP = 1'b0;
                    shiftOP = 3'b000;
                    shiftCtrl = 3'b000;
                    ALUOP = 3'b000;

                    WriteData = 3'b000; 
                    muxShiftS = 2'b00;
                    muxShiftIn = 2'b00;
                    RegDst = 2'b00;
                    muxPCWriteCondSource = 1'b0;
                    PCSrc = 2'b01; //
                    MultDiv = 1'b0;
                    IorD = 2'b00;
                    ExCause = 2'b00;
                    ALUSrcA = 2'b00;
                    ALUSrcB = 2'b00;
                    MemA = 1'b0;
                    MemB = 1'b0;

                    COUNTER = 0;
                    STATE = ST_COMMON;

                    PCWriteCond = 1'b0;
                    PCWrite = 1'b1; //
                    MDRCtrl = 1'b0;
                    LoadAB = 1'b0;
                    ALUOut = 1'b0;
                    EPCWrite = 1'b0;
                    HiLow = 1'b0;
                    AuxMultDivA = 1'b0;
                    AuxMultDivB = 1'b0;
                    SCtrl = 2'b00;
                    LCtrl = 2'b00;

                    MemReadWrite = 1'b0;
                    IRWrite = 1'b0;
                    RegWrite = 1'b0;

                    SignExtndCtrl = 1'b0;
                end

                ST_JAL : begin
                    if(COUNTER == 0) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000; //

                        WriteData = 3'b000; 
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b01; //
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00; //
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = 0;
                        STATE = ST_COMMON;

                        PCWriteCond = 1'b0;
                        PCWrite = 1'b1; //
                        MDRCtrl = 1'b0;
                        LoadAB = 1'b0;
                        ALUOut = 1'b1; //
                        EPCWrite = 1'b0;
                        HiLow = 1'b0;
                        AuxMultDivA = 1'b0;
                        AuxMultDivB = 1'b0;
                        SCtrl = 2'b00;
                        LCtrl = 2'b00;

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
                    end
                    else if (COUNTER == 1) begin
                        divOP = 1'b0;
                        multOP = 1'b0;
                        shiftOP = 3'b000;
                        shiftCtrl = 3'b000;
                        ALUOP = 3'b000;

                        WriteData = 3'b000; 
                        muxShiftS = 2'b00;
                        muxShiftIn = 2'b00;
                        RegDst = 2'b00;
                        muxPCWriteCondSource = 1'b0;
                        PCSrc = 2'b00;
                        MultDiv = 1'b0;
                        IorD = 2'b00;
                        ExCause = 2'b00;
                        ALUSrcA = 2'b00;
                        ALUSrcB = 2'b00;
                        MemA = 1'b0;
                        MemB = 1'b0;

                        COUNTER = 0;
                        STATE = ST_COMMON;

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

                        MemReadWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;

                        SignExtndCtrl = 1'b0;
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
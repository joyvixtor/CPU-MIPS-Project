module cpu(
    input wire clk, reset
);

    // mux control signals
    wire PCWriteCondSource;
    wire [1:0] IorD;
    wire [1:0] ExCause;
    wire MemA;
    wire MemB;
    wire MultDiv;
    wire [1:0] ALUSrcA;
    wire [1:0] ALUSrcB;
    wire [1:0] PCSrc;
    wire [1:0] RegDst;
    wire [2:0] WriteData;
    wire ShiftIn;
    wire ShiftS;

    // register signals
    wire PCWriteCond;
    wire PCWrite;
    wire [1:0] SCtrl;
    wire MDRCtrl;
    wire [1:0] LCtrl;
    wire LoadAB;
    wire ALUOut;
    wire EPCWrite;
    wire HiLow;
    wire AuxMultDivA;
    wire AuxMultDivB;

    wire multOP;
    wire divOP;

    // memory signals
    wire MemRead;
    wire MemWrite;

    // instruction register signals
    wire IRWrite;

    // register signals
    wire RegWrite;

    // ALUOP
    wire [2:0] ALUOp;

    //mult, div and shifting units
    wire [2:0] ShiftCtrl;
    wire MultCtrl;
    wire DivCtrl;

    // others
    wire SignExtndCtrl;


    // data wires
    wire [31:0] outMemory;
    wire [31:0] outSCtrl;
    wire [31:0] outMuxIorD;

    wire [5:0] instruction31_26;
    wire [4:0] instruction25_21;
    wire [4:0] instruction20_16;
    wire [15:0] instruction15_0;

    wire [31:0] outMuxRegDst;
    wire [31:0] outMuxWriteData;
    wire [31:0] outDataA;
    wire [31:0] outDataB;

    wire [31:0] outA;
    wire [31:0] outB;

    wire [31:0] outALUResult;

    wire [31:0] outEPC;

    wire [31:0] outALUOut;

    wire [31:0] outMultDivA;
    wire [31:0] outMultDivB;

    wire [31:0] outHI;
    wire [31:0] outLOW;

    wire [31:0] outMDR;

    wire [31:0] outLAux;

    wire [31:0] outSAux;

    wire [31:0] outAuxMultDivA;
    wire [31:0] outAuxMultDivB;

    wire [31:0] outPC;
    wire [31:0] outMuxPCWrite;
    wire [31:0] outMuxPCWriteCond;

    wire [31:0] outMuxExCause;

    wire [31:0] outShiftingUnit;

    wire outALULT;
    wire [31:0] outEx1to32;

    wire [31:0] outMuxAuxMultDivA;
    wire [31:0] outMuxAuxMultDivB;

    wire [31:0] multHighHalf;
    wire [31:0] multLowHalf;
    wire [31:0] divRemainder;
    wire [31:0] divQuotient;

    wire [31:0] outMult;
    wire [31:0] outDiv;

    wire [31:0] outMuxShiftIn;
    wire [31:0] outMuxShiftS;
    wire [31:0] outSignExtnd_8to32_16to32;

    wire [31:0] outMuxAluA;
    wire [31:0] outMuxAluB;
    wire outALUEQ;
    wire outALUOverflow;
    wire outALUzero;

    wire [31:0] outShiftLeft_2;
    wire [31:0] outShiftLeft_2_26to28;
    wire [31:0] outMuxPCWriteCondSource;
    wire [31:0] outPCSrc;

    // COMPONENTES
    //ALU
    ALU alu(
        //signals
        ALUOP,
        //inputs
        outMuxAluA,
        outMuxAluB,
        //outputs
        outALUResult,
        outALULT,
        outALUEQ,
        outALUOverflow,
        outALUZero
    );


    // Memoria Memory
    Memoria Memory(
        //signals
        clk,
        MemRead,
        MemWrite,
        //inputs
        outMuxIorD,
        outSCtrl,
        //output
        outMemory
    );

    // Instruction Register 
    Instruc_Reg InstructionRegister(
        //signals
        clk,
        reset,
        IRWrite,
        //inputs
        outMemory,
        //outputs
        instruction31_26,
        instruction25_21,
        instruction20_16,
        instruction15_0
    );

    //Banco de Registradores
    Banco_Reg Registers(
        //signals
        clk,
        reset,
        RegWrite,
        //inputs
        instruction25_21,
        instruction20_16,
        outMuxRegDst,
        outMuxWriteData,
        //outputs
        outDataA,
        outDataB
    );

    //Unidade de Mult
    multUnit mult(
        //signals
        clk,
        reset,
        multOP,
        //inputs
        outAuxMultDivA,
        outAuxMultDivB,
        //outputs
        outMult,
    );

    //Unidade de Div
    divUnit div(
        //signals
        clk,
        reset,
        divOP,
        //inputs
        outAuxMultDivA,
        outAuxMultDivB,
        //outputs
        outDiv
    );

    //Unidade de Shifting
    ShiftingUnit shiftUnit(
        //signals
        clk,
        reset,
        ShiftCtrl,
        //inputs
        outMuxShiftIn,
        outMuxShiftS,
        //outputs
        outShiftingUnit
    );

    //MULTIPLEXADORES
    mux_IorD muxIorD(
        //signals
        IorD,
        //inputs
        outPC,
        outALUOut,
        outALUResult,
        outMuxExCause,
        //outputs
        outMuxIorD
    );

    mux_RegDst muxRegDst(
        //signals
        RegDst,
        //inputs
        instruction20_16,
        instruction15_0,
        //outputs
        outMuxRegDst
    );

    mux_WriteData muxWriteData(
        //signals
        WriteData,
        //inputs
        outALUOut,
        outEx1to32,
        outLAux,
        outHI,
        outLOW,
        outShiftingUnit,
        //outputs
        outMuxWriteData
    );

    mux_AuxMultDivA auxMuxMultDivA(
        //signals
        MemA,
        //inputs
        outDataA,
        outAuxMultDivA,
        //outputs
        outMuxAuxMultDivA
    );

    mux_AuxMultDivB auxMuxMultDivB(
        //signals
        MemB,
        //inputs
        outDataB,
        outAuxMultDivB,
        //outputs
        outMuxAuxMultDivB
    );

    mux_MultDivA muxMultDivA(
        //signals
        MultDiv,
        //inputs
        multHighHalf,
        divRemainder,
        //outputs
        outMultDivA
    );

    mux_MultDivB muxMultDivB(
        //signals
        MultDiv,
        //inputs
        multLowHalf,
        divQuotient,
        //outputs
        outMultDivB
    );

    mux_ShiftIn muxShiftIn(
        //signals
        ShiftIn,
        //inputs
        outDataB,
        outSignExtnd_8to32_16to32,
        //outputs
        outMuxShiftIn
    );

    mux_ShiftS muxShiftS(
        //signals
        ShiftS,
        //inputs
        instruction15_0,
        //outputs
        outMuxShiftS
    );

    mux_ALUA muxAluA(
        //signals
        ALUSrcA,
        //inputs
        outPC,
        outA,
        //output
        outMuxAluA
    );

    mux_ALUB muxAluB(
        //signals
        ALUSrcB,
        //inputs
        outB,
        outSignExtnd_8to32_16to32,
        outShiftLeft_2,
        //output
        outMuxAluB
    );

    mux_PCSource muxPCSrc(
        //signals
        PCSrc,
        //inputs
        outALUResult,
        outShiftLeft_2_26to28,
        outALUOut,
        outEPC,
        //outputs
        outPCSrc
    );

    mux_PC_Write_Cond_Source muxPCWCSrc(
        //signals
        PCWriteCondSource,
        //inputs
        outALUZero,
        outALUEQ,
        //outputs
        outMuxPCWriteCondSource
    );

    //UNIDADES DE SHIFT E SIGN EXTEND
    Extend_1to32 ex_1to32(
        //input
        outALULT,
        //output
        outEx1to32
    );

    Extend_16to32_8to32 ex16to32_8to32(
        //signals
        SignExtndCtrl,
        //input
        instruction15_0,
        outMDR,
        //output
        outSignExtnd_8to32_16to32
    );

    Shift_Left2 SL2(
        //Input
        outSignExtnd_8to32_16to32,
        //Output
        outShiftLeft_2
    );

    Shift_Left2_26to28 SL226to28(
        //input
        instruction25_21,
        instruction20_16,
        instruction15_0,
        //output
        outShiftLeft_2_26to28
    );

    //REGISTRADORES
    assign writePC = (PCWrite || (PCWriteCond && outMuxPCWriteCond)); 

    Registrador PC(
        //signals
        clk,
        reset,
        writePC,
        //inputs
        outMuxPCWrite,
        //outputs
        outPC
    );

    Registrador A(
        //signals
        clk,
        reset,
        LoadAB,
        //inputs
        outDataA,
        //outputs
        outA
    );

    Registrador B(
        //signals
        clk,
        reset,
        LoadAB,
        //inputs
        outDataB,
        //outputs
        outB
    );

    Registrador EPC(
        //signals
        clk,
        reset,
        EPCWrite,
        //inputs
        outALUResult,
        //outputs
        outEPC
    );

    Registrador RegALUOut(
        //signals
        clk,
        reset,
        ALUOut,
        //inputs
        outALUResult,
        //outputs
        outALUOut
    );

    Registrador HI(
        //signals
        clk,
        reset,
        HiLow,
        //inputs
        outMultDivA,
        //outputs
        outHI
    );

    Registrador LOW(
        //signals
        clk,
        reset,
        HiLow,
        //inputs
        outMultDivB,
        //outputs
        outLOW
    );

    Registrador MDR(
        //signals
        clk,
        reset,
        MDRCtrl,
        //inputs
        outMemory,
        //outputs
        outMDR
    );

    Registrador LAux(
        //signals
        clk,
        reset,
        LCtrl,
        //inputs
        outMDR,
        //outputs
        outLAux
    );

    Registrador SAux(
        //signals
        clk,
        reset,
        SCtrl,
        //inputs
        outMDR,
        //outputs
        outSAux
    );

    Registrador RegAuxMultDivA(
        //signals
        clk,
        reset,
        AuxMultDivA,
        //inputs
        outMemory,
        //outputs
        outAuxMultDivA
    );

    Registrador RegAuxMultDivB(
        //signals
        clk,
        reset,
        AuxMultDivB,
        //inputs
        outMemory,
        //outputs
        outAuxMultDivB
    );

    //UNIDADE DE CONTROLE
    ControlUnit controlUnit(
        //inputs
        clk,
        reset,
        outALUOverflow,
        outALUZero,
        ALUOP,
        instruction31_26[5:0],
        //outputs
        PCWriteCondSource,
        ExCause,
        IorD,
        AuxMultDivA,
        AuxMultDivB,
        PCWriteCond,
        PCWrite,
        MemWrite,
        MemRead,
        MemA,
        MemB,
        IRWrite,
        RegWrite,
        WriteData,
        RegDst,
        SCtrl,
        LCtrl,
        MDRCtrl,
        PCSrc,
        ShiftCtrl,
        ShiftIn,
        ShiftS,
        EPCWrite,
        ALUSrcA,
        ALUSrcB,
        MultDiv,
        SignExtndCtrl
    );


endmodule
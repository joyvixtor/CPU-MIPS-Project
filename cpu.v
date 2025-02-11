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

    wire [31:0] outMultDivA;
    wire [31:0] outMultDivB;

    wire [31:0] outPC;
    wire [31:0] outMuxPCWrite;
    wire [31:0] outMuxPCWriteCond;

    wire [31:0] outMuxExCause;

    wire [31:0] outShiftingUnit;

    wire outALULT;
    wire [31:0] outEx1to32;

    // COMPONENTES
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

    //Multiplexadores
    mux_IorD muxIorD(
        //signals
        IorD,
        //inputs
        outPC,
        outALUOut,
        outALUResult,
        outMuxExCause,
        //outputs
        outMuxIorD,
    );

    mux_RegDst muxRegDst(
        //signals
        RegDst,
        //inputs
        instruction20_16,
        instruction15_0,
        //outputs
        outMuxRegDst,
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
        outShiftingUnit
        //outputs
        outMuxWriteData,
    );

    //Unidades de Shift e Sign Extend
    Extend_1to32 ex_1to32(
        //input
        outALULT,
        //output
        outEx1to32,
    );

    Shift_Left2 SL2(
        //Input

        //Output
    )

    //Registradores
    assign writePC = (PCWrite || (PCWriteCond && outMuxPCWriteCond)); 

    Registrador PC(
        //signals
        clk,
        reset,
        writePC,
        //inputs
        outMuxPCWrite,
        //outputs
        outPC,
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

    Registrador ALUOut(
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
        outHI,
    );

    Registrador LOW(
        //signals
        clk,
        reset,
        HiLow,
        //inputs
        outMultDivB,
        //outputs
        outLOW,
    ;)

    Registrador MDR(
        //signals
        clk,
        reset,
        MDRCtrl,
        //inputs
        outMemory,
        //outputs
        outMDR,
    );

    Registrador LAux(
        //signals
        clk,
        reset,
        LCtrl,
        //inputs
        outMDR,
        //outputs
        outLAux,
    );

    Registrador SAux(
        //signals
        clk,
        reset,
        SCtrl,
        //inputs
        outMDR,
        //outputs
        outSAux,
    );

    Registrador MultDivA(
        //signals
        clk,
        reset,
        AuxMultDivA,
        //inputs
        outMemory,
        //outputs
        outMultDivA,
    );

    Registrador MultDivB(
        //signals
        clk,
        reset,
        AuxMultDivB,
        //inputs
        outMemory,
        //outputs
        outMultDivB,
    );

endmodule
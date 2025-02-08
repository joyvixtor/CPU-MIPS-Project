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


    // COMPONENTES
    // Memoria Memory
    Memoria Memory(
        //inputs
        clk,
        outMuxIorD,
        outSCtrl,
        //output
        outMemory
        //signals
        MemRead,
        MemWrite
    );

    // Instruction Register 
    Instruc_Reg InstructionRegister(
        clk,
        reset,
        IRWrite,
        outMemory,
        instruction31_26,
        instruction25_21,
        instruction20_16,
        instruction15_0
    )


endmodule
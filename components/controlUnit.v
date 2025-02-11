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
    output reg [2:0] ShiftOP,
    output reg [2:0] ShiftCtrl,

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
    output reg PCWriteCond,
    output reg PCWrite,
    output reg MDRCtrl,
    output reg LoadAB,
    output reg ALUOut,
    output reg EPCWrite,
    output reg HiLow,
    output reg AuxMultDivA,
    output reg AuxMultDivB,

    output reg MemWrite,
    output reg MemRead,
    output reg IRWrite,
    output reg RegWrite,

    output reg SignExtndCtrl,
    output reg [1:0] SCtrl,
    output reg [1:0] Lc
);

    reg [5:0] STATE;
    integer COUNTER;

    //STATES
    parameter ST_ADD = 6'b000000, //0
    parameter ST_ADDI = 6'b000001, //1

endmodule
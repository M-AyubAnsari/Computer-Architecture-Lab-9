`timescale 1ns / 1ps

module tb_control();
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;
    wire RegWrite;
    wire [1:0] ALUOp;
    wire MemRead;
    wire MemWrite;
    wire ALUSrc;
    wire MemtoReg;
    wire Branch;
    wire [3:0] ALUCtrl;
    
    main_ctrl uut1(
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .Branch(Branch)
    );
    
    alu_ctrl uut2(
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUCtrl(ALUCtrl)
    );
    
    initial begin
        opcode = 7'b0000000;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        //for R-type ADD;
        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        //for R-type SUB;
        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0100000;
        #10;
        //for R-type AND;
        opcode = 7'b0110011;
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        #10;
        //for R-type OR
        opcode = 7'b0110011;
        funct3 = 3'b110;
        funct7 = 7'b0000000;
        #10;
        //for R-type XOR
        opcode = 7'b0110011;
        funct3 = 3'b100;
        funct7 = 7'b0000000;
        #10;
        //for R-type SLL
        opcode = 7'b0110011;
        funct3 = 3'b001;
        funct7 = 7'b0000000;
        #10;
        //for R-type SRL
        opcode = 7'b0110011;
        funct3 = 3'b101;
        funct7 = 7'b0000000;
        #10;
        //for S-type SW
        opcode = 7'b0100011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        //for I-type LW
        opcode = 7'b0000011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        //for I-type ADDI
        opcode = 7'b0010011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        //for B-type BEQ;
        opcode = 7'b1100011;
        funct3 = 3'b000;
        funct7 = 7'b0100000;
        #10;
        $finish;
    end  
    
endmodule

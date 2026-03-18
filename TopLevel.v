`timescale 1ns / 1ps

module top_level(
    input clk,
    input rst,
    input pbin,
    input [15:0] switches,
    output [15:0] leds
    );
    
    wire pbout;
    reg [29:0] memAddress;
    reg writeEnable;
    reg readEnable;
    reg [31:0] writeData;
    wire [31:0] readData_switches;
    wire [31:0] readData_leds;
    wire [31:0] bus_readData;
    
    assign bus_readData = readData_switches | readData_leds;
    
    wire RegWrite, MemRead, MemWrite, ALUSrc, MemtoReg, Branch;
    wire [1:0] ALUOp;
    wire [3:0] ALUCtrl;
    
    reg [15:0] captured_switches;
    reg state, next_state;
    reg pbout_prev;
    localparam READ_STATE = 1'b0;
    localparam WRITE_STATE = 1'b1;
    
    wire [6:0] opcode = captured_switches[6:0];
    wire [2:0] funct3 = captured_switches[9:7];
    
    wire [6:0] funct7 = {1'b0, captured_switches[10], 5'b00000};
    
    
    debouncer db_inst(
        .clk(clk),
        .pbin(pbin),
        .pbout(pbout)
    );
    
    switches sw_inst(
        .clk(clk),
        .rst(rst),
        .btns(16'd0),
        .writeData(writeData),
        .writeEnable(writeEnable),
        .readEnable(readEnable),
        .memAddress(memAddress),
        .switches(switches),
        .readData(readData_switches)
    );
    
    leds led_inst(
        .clk(clk),  
        .rst(rst),
        .writeData(writeData),
        .writeEnable(writeEnable),
        .readEnable(readEnable),
        .memAddress(memAddress),
        .readData(readData_leds),
        .leds(leds)
    );
    
    main_ctrl mc_inst(
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .Branch(Branch)
    );
    
    alu_ctrl ac_inst (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUCtrl(ALUCtrl)
    );
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= READ_STATE;
            captured_switches <= 16'd0;
            pbout_prev <= 1'b0;
        end else begin
            state <= next_state;
            pbout_prev <= pbout;
            if (state == READ_STATE) begin
                captured_switches <= bus_readData[15:0];
            end
        end
    end
    
    always @(*) begin
        next_state = state;
        memAddress = 30'h00000000;
        readEnable = 1'b0;
        writeEnable = 1'b0;
        writeData = 32'd0;
        
        case(state)
            READ_STATE: begin
                memAddress = 30'h00000000;
                readEnable = 1'b1;
                
                if (pbout == 1'b1 && pbout_prev == 1'b0) begin
                    next_state = WRITE_STATE;
                end
            end
            WRITE_STATE: begin
                memAddress = 30'h00000004;
                writeEnable = 1'b1;
                
                writeData = {20'd0, ALUCtrl, ALUOp, Branch, MemtoReg, ALUSrc, MemWrite, MemRead, RegWrite};
                
                if (pbout == 1'b0 && pbout_prev == 1'b0) begin
                    next_state = READ_STATE;
                end
            end
        endcase
    end          
            
endmodule

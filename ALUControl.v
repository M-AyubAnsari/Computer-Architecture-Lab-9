`timescale 1ns / 1ps

module alu_ctrl(
    input [1:0] ALUOp,
    input [6:0] funct7,
    input [2:0] funct3,
    output reg [3:0] ALUCtrl
    );
    
    always @(*) begin
        case(ALUOp)
            2'b00: begin
                ALUCtrl <= 4'b0010;
            end
            2'b01: begin
                ALUCtrl <= 4'b0110;
            end
            2'b10: begin
                case(funct3)
                    3'b000: begin
                        case(funct7)
                            7'b0000000: begin
                                ALUCtrl <= 4'b0010;
                            end
                            7'b0100000: begin
                                ALUCtrl <= 4'b0110;
                            end
                        endcase
                    end
                    3'b001: begin
                        ALUCtrl <= 4'b0011; //SLL
                    end
                    3'b100: begin
                        ALUCtrl <= 4'b0100; //XOR
                    end
                    3'b101: begin
                        ALUCtrl <= 4'b0101; //SRL
                    end
                    3'b110: begin
                        ALUCtrl <= 4'b0001; //OR
                    end
                    3'b111: begin
                        ALUCtrl <= 4'b0000; //AND
                    end
                    default: begin
                        ALUCtrl <= 4'b0000;
                    end
                endcase
            end
            default: begin
                ALUCtrl <= 4'b0000;
            end
        endcase      
    end      
endmodule

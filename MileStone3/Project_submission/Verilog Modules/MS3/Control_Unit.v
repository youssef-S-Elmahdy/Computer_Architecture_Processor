

module Control_Unit(input [4:0] opcode, output reg branch, output reg jalr, output reg jump, output reg MemRead, output reg [1:0] WRFSel, output reg MemWrite, output reg ALUSrc1, output reg ALUSrc2, output reg RegWrite, output reg [1:0] ALUOp);
    always @(*) begin 
        case(opcode)
            5'b01100: begin  //R format
                branch = 0;
                jalr = 0;
                jump = 0;
                MemRead = 0;
                WRFSel = 2'b10;
                ALUOp = 2'b10;
                MemWrite = 0;
                ALUSrc1 = 0;
                ALUSrc2 = 0;
                RegWrite = 1;
                end
                
             5'b00100: begin  //I format
                branch = 0;
                jalr = 0;
                jump = 0;
                MemRead = 0;
                WRFSel = 2'b10;
                ALUOp = 2'b11;
                MemWrite = 0;
                ALUSrc1 = 0;
                ALUSrc2 = 1;
                RegWrite = 1;
                end 
                
             5'b00000: begin //Load
                branch = 0;
                jalr = 0;
                jump = 0;
                MemRead = 1;
                WRFSel = 2'b00;
                ALUOp = 2'b00;
                MemWrite = 0;
                ALUSrc1 = 0;
                ALUSrc2 = 1;
                RegWrite = 1;
                end
                
              5'b01000: begin //Store
                branch = 0;
                jalr = 0;
                jump = 0;
                MemRead = 0;
                WRFSel = 2'b00;
                ALUOp = 2'b00;
                MemWrite = 1;
                ALUSrc1 = 0;
                ALUSrc2 = 1;
                RegWrite = 0;
                end
                
             5'b11000: begin //Branch
                branch = 1;
                jalr = 0;
                jump = 0;
                MemRead = 0;
                WRFSel = 2'b00;
                ALUOp = 2'b01;
                MemWrite = 0;
                ALUSrc1 = 0;
                ALUSrc2 = 0;
                RegWrite = 0;
                end 
                
                
            5'b11011: begin  //jump
                branch = 0;
                jalr = 0;
                jump = 1;
                MemRead = 0;
                WRFSel = 2'b01;
                ALUOp = 2'b00;
                MemWrite = 0;
                ALUSrc1 = 1;
                ALUSrc2 = 1;
                RegWrite = 1;
                end 
            
            5'b11001: begin  //jalr
                branch = 0;
                jalr = 1;
                jump = 0;
                MemRead = 0;
                WRFSel = 2'b01;
                ALUOp = 2'b00;
                MemWrite = 0;
                ALUSrc1 = 0;
                ALUSrc2 = 1;
                RegWrite = 1;
                end 
                
            5'b01101: begin  //lui
                branch = 0;
                jalr = 0;
                jump = 0;
                MemRead = 0;
                WRFSel = 2'b11;
                ALUOp = 2'b00;
                MemWrite = 0;
                ALUSrc1 = 0;
                ALUSrc2 = 1;
                RegWrite = 1;
                end 
            
            5'b00101: begin  //auipc
                branch = 0;
                jalr = 0;
                jump = 0;
                MemRead = 0;
                WRFSel = 2'b10;
                ALUOp = 2'b00;
                MemWrite = 0;
                ALUSrc1 = 1;
                ALUSrc2 = 1;
                RegWrite = 1;
                end 
            
            default: begin 
                branch = 0;
                jalr = 0;
                jump = 0;
                MemRead = 0;
                WRFSel = 2'b00;
                ALUOp = 2'b00;
                MemWrite = 0;
                ALUSrc1 = 0;
                ALUSrc2 = 0;
                RegWrite = 0;
                end 
             
            endcase
        end        
endmodule


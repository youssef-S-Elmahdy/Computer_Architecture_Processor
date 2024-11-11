

module ALU_Control_Unit(input [2:0] funct3,input funct7,input [1:0] ALUop,output reg [3:0] ALUSel);
    always @(*) begin
        case(ALUop)
            2'b00: ALUSel = 4'b0010; //Load & Store & Jalr & auipc
            2'b01: ALUSel = 4'b0110; //Branch
            
            2'b10: begin //R-Format
                case(funct3)
                    3'b000: ALUSel = funct7 ? 4'b0110 : 4'b0010; 
                    3'b001: ALUSel = 4'b1001;
                    3'b010: ALUSel = 4'b0100;
                    3'b011: ALUSel = 4'b0101;
                    3'b100: ALUSel = 4'b0011;
                    3'b101: ALUSel = funct7 ? 4'b1000 : 4'b0111;
                    3'b110: ALUSel = 4'b0001;
                    3'b111: ALUSel = 4'b0000;
                    default: ALUSel = 4'd0;
                endcase
              end 
              
              2'b11: begin  //I-Format
                case(funct3)
                    3'b000: ALUSel = 4'b0010; 
                    3'b001: ALUSel = 4'b1001;
                    3'b010: ALUSel = 4'b0100;
                    3'b011: ALUSel = 4'b0101;
                    3'b100: ALUSel = 4'b0011;
                    3'b101: ALUSel = funct7 ? 4'b1000 : 4'b0111;
                    3'b110: ALUSel = 4'b0001;
                    3'b111: ALUSel = 4'b0000;
                    default: ALUSel = 4'd0;
                endcase
            end 
            default: ALUSel = 4'b0000;
        endcase
    end
endmodule
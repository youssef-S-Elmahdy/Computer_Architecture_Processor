
module DataPath(input clk, input rst, output reg [15:0] Inst_exec);
    //Wires
    wire [31:0] PC_IN;
    wire [31:0] PC_IF;
    wire [31:0] PC_ID;
    wire [31:0] PC_EX;
    wire [31:0] PC_MEM;
    wire [31:0] PC_WB;
    wire [31:0] PCadd4;
    wire PC_En;
    wire [31:0] return_add;
    wire [31:0] target_address_MEM;
    wire [31:0] target_address_EX;
     
    reg [31:0] Instruction_IF;
    wire [31:0] Instruction_ID;
    wire [31:0] NOP;
    wire [31:0] Inst_IF;
  
    
    wire ZFlag_EX;
    wire CFlag_EX;
    wire VFlag_EX;
    wire SFlag_EX;
    wire ZFlag_MEM;
    wire CFlag_MEM;
    wire VFlag_MEM;
    wire SFlag_MEM;
    
    wire RegWrite_ID;
    wire [1:0] RegWriteSel_ID;
    wire MemtoReg_ID;
    wire RegWrite_EX;
    wire [1:0] RegWriteSel_EX;
    wire MemtoReg_EX;
    wire RegWrite_MEM;
    wire [1:0] RegWriteSel_MEM;
    wire MemtoReg_MEM;
    wire RegWrite_WB;
    wire [1:0] RegWriteSel_WB;
    wire MemtoReg_WB;
    wire Using_Mem;
    reg [2:0] MemBits;
    reg MemRead; 
    reg MemWrite;
    reg [7:0] addr;
    wire [31:0] Mem_Out;
    
    wire Branch_ID;
    wire Jump_ID;
    wire Jalr_ID;
    wire MemRead_ID;
    wire MemWrite_ID;
    wire Branch_EX;
    wire Jump_EX;
    wire Jalr_EX;
    wire MemRead_EX;
    wire MemWrite_EX;
    wire Branch_MEM;
    wire Jump_MEM;
    wire Jalr_MEM;
    wire MemRead_MEM;
    wire MemWrite_MEM;
    
    wire [11:0] CU_Flags_ID;
    wire [7:0] CU_Flags_EX;
   
    wire [3:0] ALUsel;
    wire [1:0] ALUop_ID;
    wire ALUsrc1_ID;
    wire ALUsrc2_ID;
    wire [1:0] ALUop_EX;
    wire ALUsrc1_EX;
    wire ALUsrc2_EX;
    
    wire Branch_Bit;
    wire PCSrc;
    wire [1:0] PCSel;
    wire stall;
    wire PCSrc_OR_Stall;
    
    wire [31:0] ReadData1_ID;
    wire [31:0] ReadData2_ID;
    wire [31:0] ReadData1_EX;
    wire [31:0] ReadData2_EX;
    wire [31:0] ReadData2_MEM;
    
    wire [31:0] Immediate_ID;
    wire [31:0] Immediate_EX;
    wire [31:0] Immediate_MEM;
    wire [31:0] Immediate_WB;
    
    wire [31:0] ALU_A;
    wire [31:0] ALU_B;
    wire [31:0] ALU_In1;   
    wire [31:0] ALU_In2;
    wire [31:0] ALU_B_MEM;
    
    wire [31:0] ALU_out_EX;
    wire [31:0] ALU_out_MEM;
    wire [31:0] ALU_out_WB;

    reg [31:0] Mem_out_MEM;
    wire [31:0] writeData;
    wire [31:0] Mem_out_WB;

    wire [3:0] funct73_ID;
    wire [3:0] funct73_EX;
    wire [3:0] funct73_MEM;
        
    wire [4:0] RS1_ID;
    wire [4:0] RS2_ID;
    wire [4:0] RS1_EX;
    wire [4:0] RS2_EX;
    wire [4:0] RD_ID;
    wire [4:0] RD_EX;
    wire [4:0] RD_MEM;
    wire [4:0] RD_WB;

    wire [1:0] forwardA;
    wire [1:0] forwardB;
    
    wire dummy;
    
    wire halt;
    wire e_nop;
    wire f_nop;
    
    
    
    //IF
    assign PC_En = ~(stall | Using_Mem | halt);
    assign NOP = 32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
    assign PCSrc = Branch_Bit | Jump_MEM | Jalr_MEM;
    
    Register_n_bit #(.n(32)) PC (.D(PC_IN), .rst(rst), .Load(PC_En), .clk(clk), .Q(PC_IF)); 
    mux_2x1 #(.n(32)) mux_Inst (.A(NOP), .B(Instruction_IF), .S(PCSrc | Using_Mem | e_nop | f_nop), .C(Inst_IF));
    RCA #(.n(32)) Adder_4 (.A(PC_IF), .B(32'd4), .Sum(PCadd4), .Carry(dummy), .Overflow(dummy));
    Register_n_bit #(.n(64)) IF_ID (.clk(clk), .rst(rst), .Load(~stall), .D({PC_IF, Inst_IF}), .Q({PC_ID, Instruction_ID}));
    
    //ID
    assign halt = ({Instruction_ID[20], Instruction_ID[6:2]} == 6'b011100) ? 1'b1 : 1'b0;
    assign e_nop = ({Instruction_ID[20], Instruction_ID[6:2]} == 6'b111100) ? 1'b1 : 1'b0;
    assign f_nop = (Instruction_ID[6:2] == 5'b00011) ? 1'b1 : 1'b0;
    assign RD_ID = Instruction_ID[11:7];
    assign RS1_ID = Instruction_ID[19:15];
    assign RS2_ID = Instruction_ID[24:20];
    assign PCSrc_OR_Stall = PCSrc | stall;
    
    Stalling_Unit SU (.RS1_ID(RS1_ID), .RS2_ID(RS2_ID), .RD_EX(RD_EX), .MemRead_EX(MemRead_EX), .Stall(stall));
    Control_Unit CU(.opcode(Instruction_ID[6:2]), .branch(Branch_ID), .jump(Jump_ID), .jalr(Jalr_ID), .MemRead(MemRead_ID),.WRFSel(RegWriteSel_ID),.MemWrite(MemWrite_ID),.ALUSrc1(ALUsrc1_ID), .ALUSrc2(ALUsrc2_ID),.RegWrite(RegWrite_ID), .ALUOp(ALUop_ID));
    RegFile RF(.RS1(RS1_ID), .RS2(RS2_ID), .RD(RD_WB), .regWrite(RegWrite_WB), .clk(clk), .rst(rst), .writeData(writeData), .readData1(ReadData1_ID), .readData2(ReadData2_ID));
    mux_2x1 #(.n(12)) mux_CU_ID (.A(12'd0), .B({Jump_ID, Branch_ID, MemRead_ID, RegWriteSel_ID, MemWrite_ID, ALUsrc1_ID, ALUsrc2_ID, RegWrite_ID, ALUop_ID, Jalr_ID}), .S(PCSrc_OR_Stall), .C(CU_Flags_ID));
    ImmGen IG(.Inst(Instruction_ID), .Gen_Out(Immediate_ID));
    Register_n_bit #(.n(159)) ID_EX (.clk(clk), .rst(rst), .Load(1'b1), 
        .D({CU_Flags_ID, PC_ID, ReadData1_ID, ReadData2_ID, Immediate_ID, {Instruction_ID[30], Instruction_ID[14:12]}, RD_ID, RS1_ID, RS2_ID}) , 
        .Q({Jump_EX, Branch_EX, MemRead_EX, RegWriteSel_EX, MemWrite_EX, ALUsrc1_EX, ALUsrc2_EX, RegWrite_EX, ALUop_EX, Jalr_EX, PC_EX, ReadData1_EX, ReadData2_EX, Immediate_EX, funct73_EX, RD_EX, RS1_EX, RS2_EX}));
   
   //EX
   Forwarding_Unit FU (.EX_MEM_RegWrite(RegWrite_MEM), .EX_MEM_RD(RD_MEM), .ID_EX_RS1(RS1_EX), .ID_EX_RS2(RS2_EX), .MEM_WB_RegWrite(RegWrite_WB), .MEM_WB_RD(RD_WB) , .forwardA(forwardA), .forwardB(forwardB)); //will change with memory
   ALU_Control_Unit ALU_CU (.funct3(funct73_EX[2:0]), .funct7(funct73_EX[3]), .ALUop(ALUop_EX), .ALUSel(ALUsel));
   mux_4x1 #(.n(32)) mux_ALU_A (.A(ReadData1_EX), .B(writeData), .C(ALU_out_MEM), .D(32'd0), .S(forwardA), .R(ALU_A));
   mux_4x1 #(.n(32)) mux_ALU_B (.A(ReadData2_EX), .B(writeData), .C(ALU_out_MEM), .D(32'd0), .S(forwardB), .R(ALU_B));
   mux_2x1 #(.n(32)) mux_ALU_In1 (.A(PC_EX), .B(ALU_A), .S(ALUsrc1_EX), .C(ALU_In1));
   mux_2x1 #(.n(32)) mux_ALU_In2 (.A(Immediate_EX), .B(ALU_B), .S(ALUsrc2_EX), .C(ALU_In2)); 
   ALU #(.n(32)) ALU(.A(ALU_In1), .B(ALU_In2), .Sel(ALUsel), .Zflag(ZFlag_EX), .Cflag(CFlag_EX), .Vflag(VFlag_EX), .Sflag(SFlag_EX), .ALU_out(ALU_out_EX));
   RCA #(.n(32)) Target_Addr (.A(PC_EX), .B(Immediate_EX), .Sum(target_address_EX), .Carry(dummy), .Overflow(dummy)); 
   mux_2x1 #(.n(8)) mux_CU_EX (.A(8'd0), .B({Jump_EX, Branch_EX, MemRead_EX, RegWriteSel_EX, MemWrite_EX, RegWrite_EX, Jalr_EX}), .S(PCSrc), .C(CU_Flags_EX));
   Register_n_bit #(213) EX_MEM (.clk(clk), .rst(rst), .Load(1'b1),
        .D({CU_Flags_EX, target_address_EX,ZFlag_EX, CFlag_EX, VFlag_EX, SFlag_EX, ALU_out_EX, ReadData2_EX,RD_EX, PC_EX, Immediate_EX, funct73_EX, ALU_B}),
        .Q({Jump_MEM, Branch_MEM, MemRead_MEM, RegWriteSel_MEM, MemWrite_MEM, RegWrite_MEM, Jalr_MEM, target_address_MEM,ZFlag_MEM, CFlag_MEM, VFlag_MEM, SFlag_MEM, ALU_out_MEM,ReadData2_MEM, RD_MEM, PC_MEM, Immediate_MEM, funct73_MEM, ALU_B_MEM}));
        
   //MEM 
   assign PCSel = {(Branch_Bit | Jump_MEM), Jalr_MEM};
   assign Using_Mem = MemRead_MEM | MemWrite_MEM;
   
   Branch_Unit BU (.Zflag(ZFlag_MEM), .Cflag(CFlag_MEM), .Vflag(VFlag_MEM), .Sflag(SFlag_MEM), .Branch(Branch_MEM), .funct3(funct73_MEM[2:0]), .Branch_Bit(Branch_Bit));
   mux_4x1 #(.n(32)) mux_PC (.A(PCadd4), .B(ALU_out_MEM), .C(target_address_MEM), .D(32'd0), .S(PCSel), .R(PC_IN));
   Register_n_bit #(136) MEM_WB (.clk(clk), .rst(rst), .Load(1'b1),
        .D({RegWrite_MEM, RegWriteSel_MEM, Mem_out_MEM, ALU_out_MEM, RD_MEM, PC_MEM, Immediate_MEM}),
        .Q({RegWrite_WB, RegWriteSel_WB, Mem_out_WB, ALU_out_WB, RD_WB, PC_WB, Immediate_WB}));
        
   //WB
   RCA #(.n(32)) Jump_Adder (.A(PC_WB), .B(32'd4), .Sum(return_add), .Carry(dummy), .Overflow(dummy));
   mux_4x1 #(.n(32)) mux_WB (.A(Mem_out_WB), .B(return_add), .C(ALU_out_WB), .D(Immediate_WB), .S(RegWriteSel_WB), .R(writeData));
    
    
   //Memory
       always @ (*) begin
       case(Using_Mem)
           1'b0: begin
                MemRead = 1'b1;
                MemBits = 3'b010;
                MemWrite = 1'b0;
                addr = PC_IF;
                Instruction_IF = Mem_Out;
           end
           1'b1: begin
                MemRead = MemRead_MEM;
                MemBits = funct73_MEM[2:0];
                MemWrite = MemWrite_MEM;
                addr = ALU_out_MEM[7:0] + 88;
                Mem_out_MEM = Mem_Out;
           end
           default: begin
                MemRead = 1'b0;
                MemBits = 3'b0;
                MemWrite = 1'b0;
                addr = 8'b0;
                Mem_out_MEM = 32'b0;
                Instruction_IF = 32'b0;
           end
           
       endcase
   end
   Memory Mem (.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), .funct3(MemBits), .addr(addr), .data_in(ALU_B_MEM), .data_out(Mem_Out));
 
endmodule

import random

def dec_to_bin(x, width):
    if x < 0:
        x += (1 << width)
    return format(x, '0{}b'.format(width))[-width:]

def random_register(include_zero=False):
    if include_zero:
        return f'x{random.randint(0, 31)}'
    else:
        return f'x{random.randint(1, 31)}'


def random_immediate(instruction, idx, max_instructions):
    max_offset = (max_instructions - idx - 1) * 4
    min_offset = -idx * 4

    if instruction in ['LUI', 'AUIPC']:
        return random.choice([random.randint(1, 524287), random.randint(-524288, -1)])
    elif instruction in ['JAL', 'BEQ', 'BNE', 'BLT', 'BGE', 'BLTU', 'BGEU']:
        possible_offsets = [x for x in range(min_offset, max_offset + 1, 4) if x != 0]
        return random.choice(possible_offsets)
    elif instruction in ['LB', 'LH', 'LW', 'LBU', 'LHU', 'SB', 'SH', 'SW']:
        return random.randint(-512, 511) * 4
    else:
        return random.randint(-512, 511) * 4


opcodes = {
        'LUI': '0110111', 'AUIPC': '0010111', 'JAL': '1101111', 'JALR': '1100111',
        'BEQ': '1100011', 'BNE': '1100011', 'BLT': '1100011', 'BGE': '1100011',
        'BLTU': '1100011', 'BGEU': '1100011', 'LB': '0000011', 'LH': '0000011',
        'LW': '0000011', 'LBU': '0000011', 'LHU': '0000011', 'SB': '0100011',
        'SH': '0100011', 'SW': '0100011', 'ADDI': '0010011', 'SLTI': '0010011',
        'SLTIU': '0010011', 'XORI': '0010011', 'ORI': '0010011', 'ANDI': '0010011',
        'SLLI': '0010011', 'SRLI': '0010011', 'SRAI': '0010011', 'ADD': '0110011',
        'SUB': '0110011', 'SLL': '0110011', 'SLT': '0110011', 'SLTU': '0110011',
        'XOR': '0110011', 'SRL': '0110011', 'SRA': '0110011', 'OR': '0110011',
        'AND': '0110011', 'FENCE': '0001111', 'ECALL': '1110011', 'EBREAK': '1110011'
}
funct3_dict = {
        'BEQ': '000', 'BNE': '001', 'BLT': '100', 'BGE': '101', 'BLTU': '110', 'BGEU': '111',
        'LB': '000', 'LH': '001', 'LW': '010', 'LBU': '100', 'LHU': '101', 'SB': '000',
        'SH': '001', 'SW': '010', 'ADDI': '000', 'SLTI': '010', 'SLTIU': '011', 'XORI': '100',
        'ORI': '110', 'ANDI': '111', 'SLLI': '001', 'SRLI': '101', 'SRAI': '101', 'ADD': '000',
        'SUB': '000', 'SLL': '001', 'SLT': '010', 'SLTU': '011', 'XOR': '100', 'SRL': '101',
        'SRA': '101', 'OR': '110', 'AND': '111', 'JALR': '000', 'ECALL': '000', 'EBREAK': '000',
}
funct7_dict = {
        'SUB': '0100000', 'SRA': '0100000', 'SRLI': '0000000', 'SRAI': '0100000',
        'SLLI': '0000000', 'ADD': '0000000', 'SLL': '0000000', 'SLT': '0000000',
        'SLTU': '0000000', 'XOR': '0000000', 'SRL': '0000000', 'OR': '0000000',
        'AND': '0000000'
    }
instruction_type = {
        'ADD': 'R', 'SUB': 'R', 'SLL': 'R', 'SLT': 'R', 'SLTU': 'R', 'XOR': 'R', 'SRL': 'R', 'SRA': 'R', 'OR': 'R',
        'AND': 'R',
        'ADDI': 'I', 'SLTI': 'I', 'SLTIU': 'I', 'XORI': 'I', 'ORI': 'I', 'ANDI': 'I', 'SLLI': 'I', 'SRLI': 'I',
        'SRAI': 'I',
        'LB': 'I', 'LH': 'I', 'LW': 'I', 'LBU': 'I', 'LHU': 'I',
        'SB': 'S', 'SH': 'S', 'SW': 'S',
        'BEQ': 'B', 'BNE': 'B', 'BLT': 'B', 'BGE': 'B', 'BLTU': 'B', 'BGEU': 'B',
        'LUI': 'U', 'AUIPC': 'U',
        'JAL': 'J', 'JALR': 'I',
        'ECALL': 'ECALL', 'EBREAK': 'EBREAK',
        'FENCE': 'FENCE'
}
def generate_binary_encoding(opcode, funct3, funct7, rd, rs1, rs2, imm, instruction_type):
    if instruction_type == 'ECALL':
        return '00000000000000000000000001110011'
    elif instruction_type == 'EBREAK':
        return '00000000000100000000000001110011'
    elif instruction_type == 'FENCE':
        return '00000000000000000001000000001111'
    elif instruction_type == 'R':
        return f"{funct7}{dec_to_bin(int(rs2[1:]), 5)}{dec_to_bin(int(rs1[1:]), 5)}{funct3}{dec_to_bin(int(rd[1:]), 5)}{opcode}"
    elif instruction_type == 'I':
        return f"{dec_to_bin(imm, 12)}{dec_to_bin(int(rs1[1:]), 5)}{funct3}{dec_to_bin(int(rd[1:]), 5)}{opcode}"
    elif instruction_type == 'S':
        imm_bin = dec_to_bin(imm, 12)
        return f"{imm_bin[:7]}{dec_to_bin(int(rs2[1:]), 5)}{dec_to_bin(int(rs1[1:]), 5)}{funct3}{imm_bin[7:]}{opcode}"
    elif instruction_type == 'B':
        imm_bin = dec_to_bin(imm, 13)
        return f"{imm_bin[0]}{imm_bin[2:8]}{dec_to_bin(int(rs2[1:]), 5)}{dec_to_bin(int(rs1[1:]), 5)}{funct3}{imm_bin[8:12]}{imm_bin[1]}{opcode}"
    elif instruction_type == 'U':
        return f"{dec_to_bin(imm, 20)}{dec_to_bin(int(rd[1:]), 5)}{opcode}"
    elif instruction_type == 'J':
        imm_bin = dec_to_bin(imm, 21)
        return f"{imm_bin[0]}{imm_bin[10:20]}{imm_bin[9]}{imm_bin[1:9]}{dec_to_bin(int(rd[1:]), 5)}{opcode}"
    return '0' * 32

def generate_instruction(instruction, idx, max_instructions):
    rd = random_register(include_zero=False)
    rs1 = random_register(include_zero=True)
    rs2 = random_register(include_zero=True)
    imm = random_immediate(instruction, idx, max_instructions)
    opcode = opcodes[instruction]
    funct3 = funct3_dict.get(instruction, '000')
    funct7 = funct7_dict.get(instruction, '0000000')
    inst_type = instruction_type[instruction]
    if inst_type == 'R':
        asm = f"{instruction.lower()} {rd}, {rs1}, {rs2}"
    elif inst_type == 'I':
        if instruction in ['JALR', 'LB', 'LH', 'LW', 'LBU', 'LHU']:
            asm = f"{instruction.lower()} {rd}, {imm}({rs1})"
        else:
            asm = f"{instruction.lower()} {rd}, {rs1}, {imm}"
    elif inst_type == 'S':
        asm = f"{instruction.lower()} {rs2}, {imm}({rs1})"
    elif inst_type == 'B':
        asm = f"{instruction.lower()} {rs1}, {rs2}, {imm}"
    elif inst_type == 'U':
        asm = f"{instruction.lower()} {rd}, {imm}"
    elif inst_type == 'J':
        asm = f"{instruction.lower()} {rd}, {imm}"
    else:
        asm = f"{instruction.lower()}"

    binary_encoding = generate_binary_encoding(opcode, funct3, funct7, rd, rs1, rs2, imm, inst_type)
    return asm, binary_encoding


def main():
    max_instructions = 35
    instructions = ['ADD', 'SUB', 'LUI', 'AUIPC', 'JAL', 'JALR', 'BEQ', 'BNE', 'BLT', 'BGE', 'BLTU', 'BGEU', 'LB', 'LH',
                    'LW', 'LBU', 'LHU', 'SB', 'SH', 'SW', 'ADDI', 'SLTI', 'SLTIU', 'XORI', 'ORI', 'ANDI', 'SLLI', 'SRLI',
                    'SRAI', 'SLL', 'SLT', 'SLTU', 'XOR', 'SRL', 'SRA', 'OR', 'AND', 'ECALL', 'EBREAK', 'FENCE']
    random.shuffle(instructions)

    num_instructions = random.randint(1, max_instructions - 1)

    with open('riscv_assembly.txt', 'w') as asm_file, open('binary_encoding.txt', 'w') as bin_file:
        for i in range(num_instructions):
            inst = instructions[i]
            asm, binary = generate_instruction(inst, i, num_instructions)
            asm_file.write(f"{asm}\n")
            bin_file.write(f"{binary}\n")
            print(f"ASM: {asm}, BIN: {binary}")

        ecall_asm, ecall_binary = generate_instruction('ECALL', num_instructions, num_instructions)
        asm_file.write(f"{ecall_asm}\n")
        bin_file.write(f"{ecall_binary}\n")
        print(f"ASM: {ecall_asm}, BIN: {ecall_binary}")


main()

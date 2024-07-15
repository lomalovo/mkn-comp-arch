from dataclasses import dataclass


@dataclass
class RType:
    funct7: str = ""  # 7 bytes
    rs2: str = ""     # 5 bytes
    rs1: str = ""     # 5 bytes
    funct3: str = ""  # 3 bytes
    rd: str = ""      # 5 bytes
    opcode: str = ""  # 7 bytes
    name: str = ""


@dataclass
class IType:
    imm_11_0: str = ""  # 12 bytes
    rs1: str = ""       # 5 bytes
    funct3: str = ""    # 3 bytes
    rd: str = ""        # 5 bytes
    opcode: str = ""    # 7 bytes
    name: str = ""


@dataclass
class SType:
    imm_11_5: str = ""  # 7 bytes
    rs2: str = ""       # 5 bytes
    rs1: str = ""       # 5 bytes
    funct3: str = ""    # 3 bytes
    imm_4_0: str = ""   # 5 bytes
    opcode: str = ""    # 7 bytes
    name: str = ""


@dataclass
class BType:
    imm12_10_5: str = ""  # 7 bytes
    rs2: str = ""         # 5 bytes
    rs1: str = ""         # 5 bytes
    funct3: str = ""      # 3 bytes
    imm_4_1_11: str = ""  # 5 bytes
    opcode: str = ""      # 7 bytes
    name: str = ""


@dataclass
class UType:
    imm_31_12: str = ""  # 20 bytes
    rd: str = ""         # 5 bytes
    opcode: str = ""     # 7 bytes
    name: str = ""


@dataclass
class JType:
    imm_20_10_1_11_19_12: str = ""  # 20 bytes
    rd: str = ""                    # 5 bytes
    opcode: str = ""                # 7 bytes
    name: str = ""


@dataclass
class FENCEType:
    fm: str = ""      # 4 bytes
    pred: str = ""    # 4 bytes
    succ: str = ""    # 4 bytes
    rs1: str = ""     # 5 bytes
    funct3: str = ""  # 3 bytes
    rd: str = ""      # 5 bytes
    opcode: str = ""  # 7 bytes
    name: str = ""


RV32I = [
    UType(opcode="0110111", name="LUI"),
    UType(opcode="0010111", name="AUIPC"),
    JType(opcode="1101111", name="JAL"),
    IType(funct3="000", opcode="1100111", name="JALR"),
    BType(funct3="000", opcode="1100011", name="BEQ"),
    BType(funct3="001", opcode="1100011", name="BNE"),
    BType(funct3="100", opcode="1100011", name="BLT"),
    BType(funct3="101", opcode="1100011", name="BGE"),
    BType(funct3="110", opcode="1100011", name="BLTU"),
    BType(funct3="111", opcode="1100011", name="BGEU"),
    IType(funct3="000", opcode="0000011", name="LB"),
    IType(funct3="001", opcode="0000011", name="LH"),
    IType(funct3="010", opcode="0000011", name="LW"),
    IType(funct3="100", opcode="0000011", name="LBU"),
    IType(funct3="101", opcode="0000011", name="LHU"),
    SType(funct3="000", opcode="0100011", name="SB"),
    SType(funct3="001", opcode="0100011", name="SH"),
    SType(funct3="010", opcode="0100011", name="SW"),
    IType(funct3="000", opcode="0010011", name="ADDI"),
    IType(funct3="010", opcode="0010011", name="SLTI"),
    IType(funct3="011", opcode="0010011", name="SLTIU"),
    IType(funct3="100", opcode="0010011", name="XORI"),
    IType(funct3="110", opcode="0010011", name="ORI"),
    IType(funct3="111", opcode="0010011", name="ANDI"),
    IType(imm_11_0="0000000", funct3="001", opcode="0010011", name="SLLI"),
    IType(imm_11_0="0000000", funct3="101", opcode="0010011", name="SRLI"),
    IType(imm_11_0="0100000", funct3="101", opcode="0010011", name="SRAI"),
    RType(funct7="0000000", funct3="000", opcode="0110011", name="ADD"),
    RType(funct7="0100000", funct3="000", opcode="0110011", name="SUB"),
    RType(funct7="0000000", funct3="001", opcode="0110011", name="SLL"),
    RType(funct7="0000000", funct3="010", opcode="0110011", name="SLT"),
    RType(funct7="0000000", funct3="011", opcode="0110011", name="SLTU"),
    RType(funct7="0000000", funct3="100", opcode="0110011", name="XOR"),
    RType(funct7="0000000", funct3="101", opcode="0110011", name="SRL"),
    RType(funct7="0100000", funct3="101", opcode="0110011", name="SRA"),
    RType(funct7="0000000", funct3="110", opcode="0110011", name="OR"),
    RType(funct7="0000000", funct3="111", opcode="0110011", name="AND"),
    FENCEType(funct3="000", opcode="0001111", name="FENCE"),
    FENCEType("1000", "0011", "0011", "00000", "000", "00000", "0001111", "FENCE.TSO"),
    FENCEType("0000", "0001", "0000", "00000", "000", "00000", "0001111", "FENCE.TSO"),
    IType("000000000000", "00000", "000", "00000", "1110011", "ECALL"),
    IType("000000000001", "00000", "000", "00000", "1110011", "EBREAK")
]

RV32M = [
    RType(funct7="0000001", funct3="000", opcode="0110011", name="MUL"),
    RType(funct7="0000001", funct3="001", opcode="0110011", name="MULH"),
    RType(funct7="0000001", funct3="010", opcode="0110011", name="MULHSU"),
    RType(funct7="0000001", funct3="011", opcode="0110011", name="MULHU"),
    RType(funct7="0000001", funct3="100", opcode="0110011", name="DIV"),
    RType(funct7="0000001", funct3="101", opcode="0110011", name="DIVU"),
    RType(funct7="0000001", funct3="110", opcode="0110011", name="REM"),
    RType(funct7="0000001", funct3="111", opcode="0110011", name="REMU"),
]

import sys
import commands


def get_type(info: int):
    types = {
        0: "NOTYPE",
        1: "OBJECT",
        2: "FUNC",
        3: "SECTION",
        4: "FILE",
        5: "COMMON",
        6: "TLS",
        10: "LOOS",
        12: "HIOS",
        13: "LOPROC",
        15: "HIPROC",
    }
    return types.get(info, 'UNKNOWN')


def get_binding(info: int):
    bindings = {
        0: "LOCAL",
        1: "GLOBAL",
        2: "WEAK",
        10: "LOOS",
        12: "HIOS",
        13: "LOPROC",
        15: "HIPROC",
    }
    return bindings.get(info, 'UNKNOWN')


def get_visibility(other: int):
    visibility = {
        0: "DEFAULT",
        1: "INTERNAL",
        2: "HIDDEN",
        3: "PROTECTED",
    }
    return visibility.get(other, 'UNKNOWN')


def get_index(other: int):
    index = {
        0: "UNDEF",
        0xff00: "LOPROC",
        0xff1f: "HIPROC",
        0xff20: "LOOS",
        0xff3f: "HIOS",
        0xfff1: "ABS",
        0xfff2: "COMMON",
        0xffff: "XINDEX",
    }
    return index.get(other, str(other))


def register_name(register):
    names = {
        0: "zero",
        1: "ra",
        2: "sp",
        3: "gp",
        4: "tp",
        5: "t0",
        6: "t1",
        7: "t2",
        8: "s0",
        9: "s1",
        10: "a0",
        11: "a1",
        12: "a2",
        13: "a3",
        14: "a4",
        15: "a5",
        16: "a6",
        17: "a7",
        18: "s2",
        19: "s3",
        20: "s4",
        21: "s5",
        22: "s6",
        23: "s7",
        24: "s8",
        25: "s9",
        26: "s10",
        27: "s11",
        28: "t3",
        29: "t4",
        30: "t5",
        31: "t6",
    }
    return names.get(register, "UNKNOWN")


class ElfParser:

    def __init__(self, elf_path):
        self.out = ""
        with open(elf_path, 'rb') as elf_file:
            self.data = elf_file.read()
        self.sections = dict()
        e_shoff = self.get_from_data(32, 4)  # Смещение таблицы заголовков секций от начала файла в байтах.
        e_shentsize = self.get_from_data(46, 2)  # Размер одного заголовка секции.
        e_shnum = self.get_from_data(48, 2)  # Число заголовков секций.
        e_shstrndx = self.get_from_data(50, 2)
        # Индекс записи в таблице заголовков секций, описывающей таблицу названий секций

        # Сейчас парсим секции
        for i in range(e_shnum):
            sh_name = self.get_from_data(e_shoff + e_shentsize * i, 4)
            sh_addr = self.get_from_data(e_shoff + e_shentsize * i + 12, 4)
            sh_offset = self.get_from_data(e_shoff + e_shentsize * i + 16, 4)
            sh_size = self.get_from_data(e_shoff + e_shentsize * i + 20, 4)
            section_name = ""
            pos_for_name = self.get_from_data(e_shoff + e_shstrndx * e_shentsize + 16,
                                              4) + sh_name
            while self.get_from_data(pos_for_name, 1) != 0:
                section_name += chr(self.get_from_data(pos_for_name, 1))
                pos_for_name += 1
            self.sections[section_name] = {
                "sh_name": sh_name,
                "sh_addr": sh_addr,
                "sh_offset": sh_offset,
                "sh_size": sh_size}

        # Парсим symtab
        symtab = self.sections.get(".symtab")
        symtabList = []
        symtabSymbols = {}
        for i in range(symtab.get("sh_size") // 16):
            addr = symtab.get("sh_offset") + i * 16
            name = ""
            pos_for_name = self.get_from_data(addr, 4) + self.sections.get(".strtab").get("sh_offset")
            while self.get_from_data(pos_for_name, 1) != 0:
                name += chr(self.get_from_data(pos_for_name, 1))
                pos_for_name += 1
            value = self.get_from_data(addr + 4, 4)
            size = self.get_from_data(addr + 8, 4)
            info = self.get_from_data(addr + 12, 1)
            other = self.get_from_data(addr + 13, 3)
            item = {
                "symbol": i,
                "name": name,
                "value": value,
                "size": size,
                "info": info,
                "other": other}
            symtabList.append(item)
            symtabSymbols[value] = item

        # Вывод symtab
        symtab_format = "[{:4d}] 0x{:<15X} {:5d} {:<8s} {:<8s} {:<8s} {:>6s} {:s}\n"
        symtab_out = ""
        symtab_out += ".symtab\n\n"
        symtab_out += "Symbol Value              Size Type     Bind     Vis       Index Name\n"
        for item in symtabList:
            symtab_out += symtab_format.format(
                item.get("symbol"),
                item.get("value"),
                item.get("size"),
                get_type(item.get("info") & 0b1111),
                get_binding(item.get("info") >> 4),
                get_visibility(item.get("other") & 0b11),
                get_index(item.get("other") >> 8),
                item.get("name")
            )

        # Теперь парсим команды
        text = self.sections.get(".text")
        addr = text.get("sh_addr")
        cmds = []
        labels = {}
        lLabels = {}
        for i in range(0, text.get("sh_size"), 4):  # каждая команда 4 байта
            args = []
            name = "unknown command"
            bin_command = bin(self.get_from_data(text.get("sh_offset") + i, 4))[2:].rjust(32, "0")
            opcode = bin_command[25:]  # под opcode выделено 7 бит
            possible_commands = list(filter(lambda s: s.opcode == opcode, commands.RV32I + commands.RV32M))
            # Тут учитываем, что у команд, с совпавшим opcode одинаковый тип
            type_of_command = None
            if not possible_commands:
                name = "unknown command"
            else:
                type_of_command = type(possible_commands[0])
                if type(possible_commands[0]) is commands.UType:
                    rd = bin_command[20:25]
                    imm = int(bin_command[:20], 2)
                    imm = imm if imm < 2 ** 19 else imm - 2 ** 20

                    name = possible_commands[0].name
                    args = [register_name(int(rd, 2)), hex(imm)]
                elif type(possible_commands[0]) is commands.JType:
                    rd = bin_command[20:25]
                    imm = bin_command[0] * 12 + bin_command[12:20] + bin_command[11] + \
                          bin_command[1:7] + bin_command[7:11] + "0"
                    imm = int(imm, 2)
                    imm = imm if imm < 2 ** 31 else imm - 2 ** 32
                    name = possible_commands[0].name
                    args = [register_name(int(rd, 2)), imm]
                elif type(possible_commands[0]) is commands.BType:
                    funct3 = bin_command[17:20]
                    possible_commands = list(filter(lambda s: s.funct3 == funct3, possible_commands))
                    if not possible_commands:
                        name = "unknown command"
                    else:
                        rs2 = bin_command[7:12]
                        rs1 = bin_command[12:17]

                        imm = bin_command[0] * 20 + bin_command[24] + bin_command[1:7] + bin_command[20:24] + "0"
                        imm = int(imm, 2)
                        imm = imm if imm < 2 ** 31 else imm - 2 ** 32

                        name = possible_commands[0].name
                        args = [register_name(int(rs1, 2)), register_name(int(rs2, 2)), imm]
                elif type(possible_commands[0]) is commands.IType:
                    funct3 = bin_command[17:20]
                    possible_commands = list(filter(lambda s: s.funct3 == funct3, possible_commands))
                    rd = bin_command[20:25]
                    rs1 = bin_command[12:17]
                    shamt = bin_command[7:12]
                    if not possible_commands:
                        name = "unknown command"
                    elif len(possible_commands) > 1:
                        filtered_commands1 = list(filter(lambda s: s.imm_11_0 == bin_command[:7], possible_commands))
                        filtered_commands2 = list(filter(lambda s: s.opcode == "1110011", possible_commands))
                        if filtered_commands1:
                            imm = int(bin_command[0] * 20 + bin_command[:12], 2)
                            imm = imm if imm < 2 ** 31 else imm - 2 ** 32

                            name = filtered_commands1[0].name
                            args = [register_name(int(rd, 2)), register_name(int(rs1, 2)), imm]
                        elif filtered_commands2:
                            if bin_command == "00000000000000000000000001110011":
                                args = []
                                name = "ECALL"
                            elif bin_command == "00000000000100000000000001110011":
                                args = []
                                name = "EBREAK"
                            else:
                                name = "unknown command"
                        else:
                            name = "unknown command"

                    else:
                        imm = bin_command[0] * 21 + bin_command[1:12]
                        imm = int(imm, 2)
                        imm = imm if imm < 2 ** 31 else imm - 2 ** 32
                        name = possible_commands[0].name
                        args = [register_name(int(rd, 2)), register_name(int(rs1, 2)), imm]
                elif type(possible_commands[0]) is commands.SType:
                    funct3 = bin_command[17:20]
                    possible_commands = list(filter(lambda s: s.funct3 == funct3, possible_commands))
                    if possible_commands:
                        rd = bin_command[20:25]
                        rs2 = bin_command[7:12]
                        rs1 = bin_command[12:17]
                        funct7 = bin_command[0:7]

                        imm = int(funct7 + rd, 2)
                        imm = imm if imm < 2 ** 11 else imm - 2 ** 12

                        name = possible_commands[0].name
                        args = [register_name(int(rs2, 2)), register_name(int(rs1, 2)), str(imm)]
                    else:
                        name = "unknown command"
                elif type(possible_commands[0]) is commands.FENCEType:
                    funct3 = bin_command[17:20]
                    possible_commands = list(filter(lambda s: s.funct3 == funct3, possible_commands))
                    if bin_command == "10000011001100000000000000001111":
                        name = "FENCE.TSO"
                    elif bin_command == "00000001000000000000000000001111":
                        name = "PAUSE"
                    elif possible_commands:
                        name = possible_commands[0].name
                        first_code = bin_command[4:8]
                        second_code = bin_command[8:12]
                        first_word = ""
                        second_word = ""
                        for k, item in enumerate(["i", "o", "r", "w"]):
                            if first_code[k] == "1":
                                first_word += item
                            if second_code[k] == "1":
                                second_word += item
                        args = [first_word, second_word]

                    else:
                        name = "unknown command"
                elif type(possible_commands[0]) is commands.RType:
                    funct3 = bin_command[17:20]
                    funct7 = bin_command[0:7]
                    possible_commands = list(filter(lambda s: s.funct3 == funct3, possible_commands))
                    possible_commands = list(filter(lambda s: s.funct7 == funct7, possible_commands))
                    if possible_commands:
                        rd = bin_command[20:25]
                        rs2 = bin_command[7:12]
                        rs1 = bin_command[12:17]

                        name = possible_commands[0].name
                        args = [register_name(int(rd, 2)), register_name(int(rs1, 2)), register_name(int(rs2, 2))]
                    else:
                        name = "unknown command"
            cmds.append({
                "bin_command": bin_command,
                "name": name,
                "args": args,
                "type": type_of_command
            })

            def getLabel(addr):
                if addr in symtabSymbols.keys():
                    return symtabSymbols.get(addr).get("name")
                if addr not in lLabels.keys():
                    lLabels[addr] = len(lLabels)
                return "L" + str(lLabels.get(addr))

            if (addr + i) in symtabSymbols.keys():
                labels[addr + i] = getLabel(addr + i)
            if (type_of_command == commands.JType or type_of_command == commands.BType) and name != "unknown command":
                l_addr = addr + i + args[-1]
                labels[l_addr] = getLabel(l_addr)
        # теперь готовим вывод .text
        text_out = ""
        text_out += ".text\n"
        format_0_args = "   {:05x}:\t{:08x}\t{:>7s}\n"
        format_2_args_label = "   {:05x}:\t{:08x}\t{:>7s}\t{:s}, 0x{:x} <{:s}>\n"
        format_3_args_label = "   {:05x}:\t{:08x}\t{:>7s}\t{:s}, {:s}, 0x{:x}, <{:s}>\n"
        format_load_store_jalr = "   {:05x}:\t{:08x}\t{:>7s}\t{:s}, {:d}({:s})\n"

        format_2_args = "   {:05x}:\t{:08x}\t{:>7s}\t{:s}, {:s}\n"
        format_3_args = "   {:05x}:\t{:08x}\t{:>7s}\t{:s}, {:s}, {:s}\n"
        for i, command in enumerate(cmds):
            command_addr = addr + i * 4

            if command_addr in labels:
                label = labels.get(command_addr)
                label_format = "\n{:08x} \t<{:s}>:\n"
                label_text = label_format.format(command_addr, label)
                text_out += label_text

            int_command = int(command.get("bin_command"), 2)
            command_name = command.get("name").lower()
            command_args = command.get("args")
            args_size = len(command_args)
            type_of_command = command.get("type")

            command_text = ""

            if command_name == "unknown command" or args_size == 0:
                command_text = format_0_args.format(
                    command_addr,
                    int_command,
                    command_name
                )
            elif (type_of_command == commands.JType) or (type_of_command == commands.BType):
                addrs = command_addr + command_args[-1]
                if args_size == 2:
                    command_text = format_2_args_label.format(
                        command_addr,
                        int_command,
                        command_name,
                        command_args[0],
                        addrs,
                        labels.get(addrs)
                    )
                if args_size == 3:
                    command_text = format_3_args_label.format(
                        command_addr,
                        int_command,
                        command_name,
                        command_args[0],
                        command_args[1],
                        addrs,
                        labels.get(addrs)
                    )
            elif type_of_command == commands.SType or command.get("bin_command")[25:] in ["0000011", "1100111"]:
                command_text = format_load_store_jalr.format(
                    command_addr,
                    int_command,
                    command_name,
                    command_args[0],
                    int(command_args[2]),
                    command_args[1]
                )
            elif args_size == 3:
                command_text = format_3_args.format(
                    command_addr,
                    int_command,
                    command_name,
                    command_args[0],
                    command_args[1],
                    str(command_args[2])
                )
            elif args_size == 2:
                command_text = format_2_args.format(
                    command_addr,
                    int_command,
                    command_name,
                    command_args[0],
                    str(command_args[1])
                )
            text_out += command_text
        text_out += "\n"
        self.out = text_out + "\n" + symtab_out

    def get_from_data(self, start, size):
        return int.from_bytes(self.data[start: start + size], byteorder="little")


if __name__ == "__main__":
    elf_path = sys.argv[1]
    out_path = sys.argv[2]
    parser = ElfParser(elf_path)
    with open(out_path, "w") as out_file:
        out_file.write(parser.out)

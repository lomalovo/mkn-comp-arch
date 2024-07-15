import re
import sys


def rounding_for_fix_point(round_type: str, whole_part: int, fractional_part: str, numb_after_point: int) -> str:
    answer = None  # Функция для округления фиксированной точки

    fractional_part_dec = int("1" + fractional_part)  # fractional_part_dec хранится с лишней 1 в самом начале
    if len(fractional_part) < numb_after_point or fractional_part == "0":
        # если надо округлять в месте, где справа все 0
        if whole_part >= 0 or fractional_part == "0":
            answer = str(whole_part) + "." + fractional_part.ljust(numb_after_point, "0")
        else:
            answer = str(whole_part + 1) + "." + str(3 * (10 ** (len(fractional_part))) - fractional_part_dec)[1:].ljust(numb_after_point, "0")

    elif whole_part >= 0:  # рассматриваю два случая, первый целая часть больше 0
        round_down = str(whole_part) + "." + fractional_part[:numb_after_point]  # есть два варианта которые
        if fractional_part[:numb_after_point] == "9" * numb_after_point:  # мы должны выдать после округления
            round_up = str(whole_part + 1) + "." + "0" * numb_after_point  # тут проверка на 0.99999999
        else:
            round_up = str(whole_part) + "." + str(int(str(fractional_part_dec)[:numb_after_point+1]) + 1)[1:]

        if round_type == "0":  # toward_zero
            answer = round_down

        elif round_type == "1":  # nearest_even
            if len(fractional_part) == numb_after_point:
                last_number = 0
            else:
                last_number = int(fractional_part[numb_after_point])
            if last_number < 5:
                answer = round_down
            elif last_number > 5:
                answer = round_up
            elif re.fullmatch(r'0*', fractional_part[numb_after_point:]):
                if int(fractional_part[numb_after_point - 1]) % 2 == 0:
                    answer = round_down
                else:
                    answer = round_up
            else:
                answer = round_up

        elif round_type == "2":  # toward_infinity
            answer = round_up

        elif round_type == "3":  # toward_neg_infinity
            answer = round_down
    else:  # второй случай целая часть < 0, тут все аналогично предыдущему
        if whole_part == -1:
            whole = "-0"
        else:
            whole = str(whole_part + 1)
        round_down = whole + "." + str(3 * (10 ** (len(fractional_part))) - fractional_part_dec)[1:][:numb_after_point]
        if str(3 * (10 ** (len(fractional_part))) - fractional_part_dec)[1:][:numb_after_point] == "9" * numb_after_point:
            round_up = whole + "." + "0" * numb_after_point
        else:
            round_up = whole + "." + \
                       str(int(str(3 * (10 ** (len(fractional_part))) - fractional_part_dec)[1:][:numb_after_point]) + 1)

        if round_type == "0":  # toward_zero
            answer = round_down

        elif round_type == "1":  # nearest_even
            if len(str(3 * (10 ** (len(fractional_part))) - fractional_part_dec)[1:]) == numb_after_point:
                last_number = 0
            else:
                last_number = int(str(3 * (10 ** (len(fractional_part))) - fractional_part_dec)[1:][numb_after_point])
            if last_number < 5:
                answer = round_down
            elif last_number > 5:
                answer = round_up
            elif re.fullmatch(r'0*', str(3 * (10 ** (len(fractional_part))) - fractional_part_dec)[1:][numb_after_point:]):
                if int(str(3 * (10 ** (len(fractional_part))) - fractional_part_dec)[1:][numb_after_point - 1]) % 2 == 0:
                    answer = round_down
                else:
                    answer = round_up
            else:
                answer = round_up

        elif round_type == "2":  # toward_infinity
            answer = round_down

        elif round_type == "3":  # toward_neg_infinity
            answer = round_up

    return answer


def apply_operation(number_format: str, round_type: str, num_1: str, operation_symbol: str = None,
                    num_2: str = None) -> str:
    answer = None
    num2_dec = None
    num2_bin = None

    try:
        num1_dec = int(num_1, 16)
    except ValueError or TypeError:
        sys.stderr.write("First number in the wrong format")
        sys.exit()

    if num_2 is not None:
        try:
            num2_dec = int(num_2, 16)
        except ValueError or TypeError:
            sys.stderr.write("Second number in the wrong format")
            sys.exit()

    if number_format == "h" or number_format == "f":  # решение для плавающей точки
        exp1_str = None
        mantissa2 = None
        exp2_dec = None
        result = None
        sign2 = None
        num1_bin = bin(num1_dec)[2:]
        if num2_dec is not None:
            num2_bin = bin(num2_dec)[2:]
        if number_format == "h":
            max_exp = 16
            if len(num1_bin) < 16:  # дописываю нули слева
                num1_bin = "0" * (16 - len(num1_bin)) + num1_bin
            if num_2 is not None:
                if len(num2_bin) < 16:
                    num2_bin = "0" * (16 - len(num2_bin)) + num2_bin

            exp1 = num1_bin[1:6]
            exp1_dec = int(exp1, 2) - 15  # считаю экспоненту
            if num2_bin is not None:
                exp2 = num2_bin[1:6]
                exp2_dec = int(exp2, 2) - 15

            mantissa1 = num1_bin[6:]
            mantissa1_str = mantissa1 + "00"  # дополняю до 12 бит, чтобы потом вышло 3символа в 16ричной
            if num2_bin is not None:
                mantissa2 = num2_bin[6:]
                mantissa2_str = mantissa2 + "00"
        else:
            max_exp = 128
            if len(num1_bin) < 32:
                num1_bin = "0" * (32 - len(num1_bin)) + num1_bin  # дописываю нули слева
            if num_2 is not None:
                if len(num2_bin) < 32:
                    num2_bin = "0" * (32 - len(num2_bin)) + num2_bin

            exp1 = num1_bin[1:9]
            exp1_dec = int(exp1, 2) - 127  # считаю экспоненту
            if exp1_dec >= 0:
                exp1_str = "+" + str(exp1_dec)
            else:
                exp1_str = str(exp1_dec)

            if num2_bin is not None:
                exp2 = num2_bin[1:9]
                exp2_dec = int(exp2, 2) - 127
                if exp2_dec >= 0:
                    exp2_str = "+" + str(exp2_dec)
                else:
                    exp2_str = str(exp2_dec)

            mantissa1 = num1_bin[9:]
            mantissa1_str = mantissa1 + "0"  # дополняю до 24 бит, чтобы потом вышло 6 символов в 16ричной
            if num2_bin is not None:
                mantissa2 = num2_bin[9:]
                mantissa2_str = mantissa2 + "0"

        sign1 = num1_bin[0]
        if sign1 == "0":
            sign1_str = ""
        else:
            sign1_str = "-"
        if num2_bin is not None:
            sign2 = num2_bin[0]

        if operation_symbol is None:  # если без операции

            if re.fullmatch(r'0*', exp1):  # denorm
                if re.fullmatch(r'0*', mantissa1):  # тут проверка на 0
                    if number_format == "h":
                        return sign1_str + "0x0.000p+0"
                    else:
                        return "0x0.000000p+0"
                amount_of_0 = len(mantissa1) - len(
                    str(int(mantissa1)))  # считаем, на сколько 0 мы хотим перенести точку
                exp1_dec = exp1_dec - amount_of_0  # не забываем про экспоненту
                mantissa1_str = mantissa1_str[amount_of_0 + 1:] + "0" * (amount_of_0 + 1)  # перемещаем точку
                if exp1_dec >= 0:
                    exp1_str = "+" + str(exp1_dec)
                else:
                    exp1_str = str(exp1_dec)
            if exp1_dec == max_exp:  # проверка крайнего случая, когда экспонента максимальна
                if re.fullmatch(r'0*', mantissa1_str):
                    return sign1_str + "inf"
                else:
                    return "nan"
            else:
                result = sign1_str + "0x1." + hex(int(mantissa1_str, 2))[2:] + "p" + exp1_str  # если не крайний случай

        elif operation_symbol == "*":  # теперь умножение
            res_exp = exp1_dec + exp2_dec
            res_sign = int(sign1) * int(sign2)
            if res_sign == 0:
                res_sign_str = ""
            else:
                res_sign_str = "-"
            mult_res = bin(int("1" + mantissa1, 2) * int("1" + mantissa2, 2))[2:]  # умножаем как инты
            if num_format == "h":  # обрабатываю ситуацию, когда после умножения количество символов до запятой
                # возросло, например 1.1 * 1.1 = 10.01 тогда нам надо определять это как 1.001
                res_exp += len(mult_res) - 21  # 21 это 10 + 10 т.е. количество знаков после запятой и еще +1 это
                # наш символ перед запятой, получаем (длину целой части - 1)
                res_mantissa = mult_res[1:11] + "00"
            else:
                res_exp += len(mult_res) - 47  # тут аналогично 23*2 + 1
                res_mantissa = mult_res[1:24] + "0"

            if res_exp >= 0:
                res_exp_str = "+" + str(res_exp)
            else:
                res_exp_str = str(res_exp)

            result = res_sign_str + "0x1." + hex(int(res_mantissa, 2))[2:] + "p" + res_exp_str
            # тут сделал только округление 0

        elif operation_symbol == "/":  # тут сделал только обработку крайних случаев про деление на 0 и бесконечность
            what_is_num2 = apply_operation(number_format, round_type, num_2)
            if what_is_num2 == "0x0.000000p+0" or what_is_num2 == "0x0.000p+0" or what_is_num2 == "-0x0.000000p+0" or \
                    what_is_num2 == "-0x0.000p+0":
                return "inf"
            elif what_is_num2 == "inf" or what_is_num2 == "-inf":
                return "nan"
        return result

    else:  # решение для фиксированной точки
        try:
            whole_part_size, fractional_part_size = map(int, number_format.split("."))
        except ValueError or TypeError:
            sys.stderr.write("Wrong number format")
            sys.exit()

        if operation_symbol is None:  # проверка на операцию
            result = num1_dec
        elif operation_symbol == "+":
            result = num1_dec + num2_dec
        elif operation_symbol == "-":
            result = num1_dec - num2_dec
        elif operation_symbol == "*" or operation_symbol == "/":
            if operation_symbol == "*":
                op_result = num1_dec * num2_dec  # умножаем
            else:
                if num2_dec == 0:  # делим с проверкой на 0
                    return "error"
                else:
                    op_result = num1_dec // num2_dec

            whole_part_mult = str(op_result)[:-2 * fractional_part_size]
            if whole_part_mult == "":
                whole_part_mult = 0
            else:
                whole_part_mult = int(whole_part_mult)

            rounded_multy = rounding_for_fix_point(round_type, whole_part_mult,
                                                   str(op_result)[-2 * fractional_part_size:],
                                                   fractional_part_size)
            # тут округляю первый раз
            whole_part_dec, fractional_part_dec = rounded_multy.split(".")
            return rounding_for_fix_point(round_type, int(whole_part_dec), fractional_part_dec, 3)  # тут второй раз

        else:
            sys.stderr.write("Wrong operation")
            sys.exit()

        result_bin = bin(result)[2:]  # а это для случаев + - и просто округления
        if fractional_part_size == 0:
            whole_part = result_bin[-whole_part_size:]
            fractional_part = "0"
            fractional_part_size = 1
        else:
            whole_part = result_bin[:-fractional_part_size][-whole_part_size:]
            fractional_part = result_bin[-fractional_part_size:].rjust(fractional_part_size, "0")
        if whole_part == '':
            whole_part = '0'

        if len(whole_part) < whole_part_size:  # восстанавливаю дополнение до 2
            whole_part_dec = int(whole_part, 2)

        else:
            whole_part_dec = int(whole_part, 2) - 2 ** whole_part_size * int(whole_part[0])  # восстанавливаю
            # дополнение до 2
        if fractional_part[0] == "0":
            fractional_part = "1" + fractional_part[1:]
            fr_before_format = str(int(fractional_part, 2) * 5 ** fractional_part_size)
            fractional_part_str = str(int(fr_before_format[0]) - 5) + fr_before_format[1:]
        else:
            fractional_part_str = str(int(fractional_part, 2) * 5 ** fractional_part_size)  # получаю значение правее
            # точки

        return rounding_for_fix_point(round_type, whole_part_dec, fractional_part_str, 3)


if __name__ == "__main__":  # собственно считывание аргументов и вывод ответа
    args = sys.argv
    if len(args) == 4:
        num_format, rounding_type, num1 = args[1], args[2], args[3]
        print(apply_operation(num_format, rounding_type, num1))
    elif len(args) == 6:
        num_format, rounding_type, num1, operation, num2 = args[1], args[2], args[3], args[4], args[5]
        print(apply_operation(num_format, rounding_type, num1, operation, num2))
    else:
        sys.stderr.write("Wrong number of arguments")
        sys.exit()

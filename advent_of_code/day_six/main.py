import operator
from pathlib import Path
from functools import reduce
from itertools import zip_longest


OPERATORS = {'+': operator.add, '*': operator.mul}


def parse_input_p1(filepath: str | Path):
    """
    1. reads the entire file as one string, splits each line afterwards (\n)
    2. parses the operators as one list.
    3. takes the rest of the lines and turns it into a nested lsit of ints, representing ther lines.
    """

    lines = Path(filepath).read_text(encoding='utf-8').splitlines()

    ops = lines[-1].split()

    # grid of nums
    grid = [[int(x) for x in line.split()] for line in lines[:-1]]
    columns = zip(*grid)

    return ops, columns


def grand_total_p1(filepath: str | Path):
    ops, columns = parse_input_p1(filepath)

    total = 0
    for op, numbers in zip(ops, columns):
        op = OPERATORS[op]
        total += reduce(op, numbers)

    return total


def grand_total_p2(filepath: str | Path):
    """
    Similar to p1, but instead of taking the number as the field, a number is composed of reading it from top to bottom in a column
    Most significant digit is at the first row, and the least significant digit is at the second row.

    If we have an array of operators
    """
    ops, columns = parse_input_p1(filepath)

    total = 0

    for column, op in zip(list(columns)[::-1], ops[::-1]):  # (64, 16, 1512, 8719)
        temp = [
            tuple(digit for digit in str(num)[::-1]) for num in column
        ]  # [46, 61, 2151, 9178) -> reverses the integer.
        temp = zip_longest(
            *temp, fillvalue=''
        )  # ( (4, 6, 2, 9), (6, 1, 1, 1), (5, 7), (1, 8)) -> pairs each i index in the numbers
        numbers = [int(''.join(digit for digit in num)) for num in temp]

        total += reduce(OPERATORS[op], numbers)

    return total


print(grand_total_p2('advent_of_code/day_six/input.txt'))

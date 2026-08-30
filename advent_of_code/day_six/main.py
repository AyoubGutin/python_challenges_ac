import operator
from pathlib import Path
from functools import reduce
from itertools import zip_longest, groupby


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


def parse_input_p2(filepath: str | Path):
    """
    1. Reads the entire file as one string, splits each line afterwards
    2. Parses the operators as one list
    3. Takes rest of the lines, pads shortest rows with spaces at the end, so alignmenti s perseved.
    """
    lines = Path(filepath).read_text(encoding='utf-8').splitlines()

    ops = lines[-1].split()
    grid_lines = lines[:-1]
    columns = zip_longest(*grid_lines, fillvalue=' ')

    return ops, columns


def grand_total_p2(filepath: str | Path):
    """
    Similar to p1, but instead of taking the number as the field, a number is composed of reading it from top to bottom in a column
    Most significant digit is at the first row, and the least significant digit is at the second row.

    If we have an array of operators
    """
    ops, columns = parse_input_p2(filepath)

    total = 0
    col_numbers = []

    for col in columns:
        digits = ''.join(c for c in col if c != ' ')
        col_numbers.append(int(digits) if digits else None)

    all_groups = [
        list(group)
        for is_num, group in groupby(col_numbers, key=lambda x: x is not None)
        if is_num
    ]

    total = sum(reduce(OPERATORS[op], numbers) for op, numbers in zip(ops, all_groups))

    return total


print(grand_total_p2('advent_of_code/day_six/input.txt'))

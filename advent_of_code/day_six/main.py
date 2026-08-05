from pathlib import Path
import operator
from functools import reduce

OPERATORS = {'+': operator.add, '*': operator.mul}


def parse_input(filepath: str | Path):
    """
    1. reads the entire file as one string. Then, removes trailing spaces at the beginning or end of the file, and then splits each line (\n)
    2.
    """

    lines = Path(filepath).read_text(encoding='utf-8').splitlines()

    ops = lines[-1].split()

    # grid of nums
    grid = [[int(x) for x in line.split()] for line in lines[:-1]]
    columns = zip(*grid)

    return ops, columns


def grand_total(filepath: str | Path):
    ops, columns = parse_input(filepath)

    total = 0
    for op, numbers in zip(ops, columns):
        op = OPERATORS[op]
        total += reduce(op, numbers)

    return total


print(grand_total('advent_of_code/day_six/input.txt'))

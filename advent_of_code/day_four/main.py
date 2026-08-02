"""
Check 8 adjancent positions in a nested array.
If '@' appears more than 4 times, then it is False
else, if < 4, then it is True, and we can add one to the counter.
"""

import operator
from pathlib import Path

DIRECTIONS: tuple[tuple[int, int]] = (
    (0, 1),
    (0, -1),
    (1, 0),
    (-1, 0),
    (1, 1),
    (1, -1),
    (-1, 1),
    (-1, -1),
)


def parse_input(filepath: str | Path):
    arr = []
    if isinstance(filepath, str):
        filepath = Path(filepath)
    with filepath.open('r', encoding='utf-8') as f:
        for line in f:
            arr.append(list(line.strip()))

    return arr


def valid_roll(
    arr: list[list[str]], curr_pos: tuple[int], dir: tuple[int], col_len: int
):
    check_idx = tuple(map(operator.add, curr_pos, dir))
    if -1 in check_idx or col_len in check_idx:
        return False
    else:
        return True if '@' in arr[check_idx[0]][check_idx[1]] else 0


def part_one(filepath: str | Path):
    arr = parse_input(filepath)
    counter = 0
    for row_idx, row in enumerate(arr):
        col_len = len(row)

        for col_idx, col in enumerate(row):
            sub_counter = 0
            if col != '@':
                continue

            curr_pos = (row_idx, col_idx)

            for dir in DIRECTIONS:
                sub_counter += (
                    1 if valid_roll(arr, curr_pos, dir, col_len) == True else 0
                )

            if sub_counter < 4:
                counter += 1

    return counter


def part_two(filepath: str | int):
    """
    Once a roll of paper can be accessed (< 4), it can be removed.
    The forklift will repeat the process
    """
    arr = parse_input(filepath)
    total_removed = 0

    def pass_once():
        changes = []
        for row_idx, row in enumerate(arr):
            col_len = len(row)

            for col_idx, col in enumerate(row):
                sub_counter = 0
                if col != '@':
                    continue

                curr_pos = (row_idx, col_idx)

                sub_counter = sum(
                    1 for dir in DIRECTIONS if valid_roll(arr, curr_pos, dir, col_len)
                )

                if sub_counter < 4:
                    changes.append(curr_pos)

        for row, column in changes:
            arr[row][column] = '.'

        return len(changes)

    while True:
        removed_count = pass_once()
        if removed_count == 0:
            break
        total_removed += removed_count

    return total_removed


part_two_res = part_two('advent_of_code/day_four/input')
print(part_two_res)

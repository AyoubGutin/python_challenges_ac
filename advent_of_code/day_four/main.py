"""
Check 8 adjancent positions in a nested array.
If '@' appears more than 4 times, then it is False
else, if < 4, then it is True, and we can add one to the counter.
"""

import operator
from pathlib import Path

# test with a sample arr
arr = []
path = Path('advent_of_code/day_four/input')
with path.open('r', encoding='utf-8') as f:
    for line in f:
        line = line.strip()
        line = list(line)
        arr.append(line)


rows = len(arr)
counter = 0
directions = ((0, 1), (0, -1), (1, 0), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1))

for row_idx, row in enumerate(arr):
    bottom_idx = row_idx + 1 if row_idx != rows - 1 else -1
    top_idx = row_idx - 1 if row_idx != 0 else -1
    col_len = len(row)

    for col_idx, col in enumerate(row):
        sub_counter = 0
        if col != '@':
            continue

        curr_pos = (row_idx, col_idx)

        for dir in directions:
            check_idx = tuple(map(operator.add, curr_pos, dir))
            if -1 in check_idx or col_len in check_idx:
                continue
            else:
                sub_counter += 1 if '@' in arr[check_idx[0]][check_idx[1]] else 0

        if sub_counter < 4:
            counter += 1

print(counter)

"""
Check 8 adjancent positions in a nested array.
If '@' appears more than 4 times, then it is False
else, if < 4, then it is True, and we can add one to the counter.
"""

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

for row_idx, row in enumerate(arr):
    bottom_idx = row_idx + 1 if row_idx != rows - 1 else -1
    top_idx = row_idx - 1 if row_idx != 0 else -1
    col_len = len(row)

    for col_idx, col in enumerate(row):
        sub_counter = 0
        if col != '@':
            continue

        left_idx = col_idx - 1 if col_idx != 0 else -1
        right_idx = col_idx + 1 if col_idx != col_len - 1 else -1

        if left_idx != -1:
            sub_counter += 1 if row[left_idx] == '@' else 0  # left
        if right_idx != -1:
            sub_counter += 1 if row[right_idx] == '@' else 0  # right

        if top_idx != -1:
            sub_counter += 1 if arr[top_idx][col_idx] == '@' else 0  # top
        if bottom_idx != -1:
            sub_counter += 1 if arr[bottom_idx][col_idx] == '@' else 0  # bottom

        if left_idx != -1 and top_idx != -1:
            sub_counter += 1 if arr[top_idx][left_idx] == '@' else 0  # top left
        if right_idx != -1 and top_idx != -1:
            sub_counter += 1 if arr[top_idx][right_idx] == '@' else 0  # top right
        if left_idx != -1 and bottom_idx != -1:
            sub_counter += 1 if arr[bottom_idx][left_idx] == '@' else 0  # bottom left
        if right_idx != -1 and bottom_idx != -1:
            sub_counter += 1 if arr[bottom_idx][right_idx] == '@' else 0  # bottom right

        if sub_counter < 4:
            counter += 1

print(counter)

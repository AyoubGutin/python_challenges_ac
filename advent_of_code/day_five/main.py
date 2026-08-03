from pathlib import Path


def parse_input(filepath: str | Path):
    ranges = []
    ids = []
    if isinstance(filepath, str):
        filepath = Path(filepath)
    with filepath.open('r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if '-' in line:
                ranges.append(tuple(map(int, line.split('-'))))
            elif line.isnumeric() == True:
                ids.append(int(line))

    return ranges, ids


def check_valid_id(id: int, range: tuple[int, int]):
    min, max = range
    return id >= min and id <= max


def merge_ranges(ranges: list[tuple[int, int]]) -> list[tuple[int, int]]:
    ranges = sorted(ranges)
    merged = [ranges[0]]
    for current_min, current_max in ranges[1:]:
        last_min, last_max = merged[-1]

        if current_min <= last_max:
            merged[-1] = (last_min, max(current_max, last_max))
        else:
            merged.append((current_min, current_max))

    return merged


def part_1(filepath: str | Path) -> int:
    """
    Find all the ids in a given list that fall under a 'fresh' range
    """

    # can be optimised, we can do a more optimised search to find what range the id should fall under, as our list is sorted.
    # to-do ^
    fresh_count = 0
    ranges, ids = parse_input(filepath)
    ids.sort()
    merged = merge_ranges(ranges)
    for id in ids:
        for range in merged:
            if check_valid_id(id, range):
                fresh_count += 1
                break  # we dont need to check the other ranges

    return fresh_count


def part_2(filepath: str | Path) -> int:
    """
    Find all the potential IDS that are fresh
    """
    fresh_count = 0
    ranges, _ = parse_input(filepath)
    for range in merge_ranges(ranges):
        min, max = range
        fresh_count += (
            max - min
        ) + 1  # e.g., (10, 20) = 11 ranges (10, 11, 12... , 20)

    return fresh_count


def choose_solution(filepath: str | Path, part: int):
    if part == 1:
        return part_1(filepath)
    elif part == 2:
        return part_2(filepath)
    else:
        return 'Error'


filepath = 'advent_of_code/day_five/input.txt'
print(choose_solution(filepath, 2))

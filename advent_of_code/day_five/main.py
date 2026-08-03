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


def merge_ranges(ranges: list):
    ranges = sorted(ranges)
    merged = [ranges[0]]
    for current_min, current_max in ranges[1:]:
        last_min, last_max = merged[-1]

        if current_min <= last_max:
            merged[-1] = (last_min, max(current_max, last_max))
        else:
            merged.append((current_min, current_max))

    return merged


def part_1(filepath: str | Path):
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


fresh_count = part_1('advent_of_code/day_five/input.txt')
print(fresh_count)

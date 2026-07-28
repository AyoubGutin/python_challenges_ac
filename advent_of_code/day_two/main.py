import csv


class IdChecker:
    def __init__(self, invalid_sum: int = 0) -> None:
        self.invalid_sum = invalid_sum

    def check_id_part1(self, first_id: int, last_id: int) -> None:
        for num in range(first_id, last_id + 1):
            s = str(num)
            num_length = len(s)

            if num_length % 2 != 0:
                continue  # no point doing extra processing if we know its uneven.

            half = num_length // 2
            if s[:half] == s[half:]:
                self.invalid_sum += num

    def parse_input(self, filepath: str) -> None:
        with open(filepath, 'r') as f:
            reader = csv.reader(f, delimiter=',')
            print(reader)
            for row in reader:
                for range in row:
                    first_id, last_id = range.split('-')
                    self.check_id(int(first_id), int(last_id))


if __name__ == '__main__':
    id_checker = IdChecker()
    id_checker.parse_input('advent_of_code/day_two/input.csv')
    print(id_checker.invalid_sum)

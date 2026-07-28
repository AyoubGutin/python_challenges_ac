import csv


class IdChecker:
    def __init__(self, invalid_sum: int = 0) -> None:
        self.invalid_sum = invalid_sum

    def check_id_part1(self, first_id: int, last_id: int) -> None:
        """Check whether an ID from a range repeat twice"""

        for num in range(first_id, last_id + 1):
            s = str(num)
            num_length = len(s)

            if num_length % 2 != 0:
                continue  # no point doing extra processing if we know its uneven.

            half = num_length // 2
            if s[:half] == s[half:]:
                self.invalid_sum += num

    def check_id_part2(self, first_id: int, last_id: int) -> None:
        """Check whether an ID from a range repeat at least twice
        new rules implication:
            - check if all elements the same: len(list). sum(list) == list[1] * len(list)
            - for other cases, do length // 2, and check each portion if they are equal
        """

        for num in range(first_id, last_id + 1):
            s = str(num)
            num_length = len(s)
            max_pattern = num_length // 2

            for i in range(1, max_pattern + 1):
                if num_length % i == 0:
                    chunks = [s[j : j + i] for j in range(0, len(s), i)]
                    if len(set(chunks)) == 1:
                        self.invalid_sum += num
                        break

    def parse_input(self, filepath: str) -> None:
        with open(filepath, 'r') as f:
            reader = csv.reader(f, delimiter=',')
            print(reader)
            for row in reader:
                for range in row:
                    first_id, last_id = range.split('-')
                    self.check_id_part2(
                        int(first_id), int(last_id)
                    )  # this is to change the part


if __name__ == '__main__':
    id_checker = IdChecker()
    id_checker.parse_input('advent_of_code/day_two/input.csv')
    print(id_checker.invalid_sum)

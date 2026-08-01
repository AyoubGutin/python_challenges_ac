from pathlib import Path


class BatterySolver:
    """
    Solves batteyr bank maximum voltage calculations for Advent of Code Day 3
    """

    @staticmethod
    def find_max_voltage_part_1(bank: str) -> None:
        """
        For a battery bank, it finds the maximum voltage (exactly two digits)
        """
        bank_list = list(map(int, list(bank)))

        tens_digit = max(bank_list[:-1])
        tens_index = bank_list.index(tens_digit)
        ones_digit = max(bank_list[tens_index + 1 :])

        return tens_digit * 10 + ones_digit

    @staticmethod
    def find_max_voltage_part_2(bank: str) -> None:
        """
        Turning on exactly twelve batteries within each bank, instead of two
        """
        bank_list = list(map(int, list(bank)))
        start_index = 0
        chosen_digits: list[str] = []

        # 12 digits needed
        for i in range(1, 13):
            # calc how many cards we can leave on the right without compromising on the 12 digits.
            remaining_needed = (
                12 - i
            )  # i.e., on pick 1, we can leave 11 cards to the right as 11 + 1 = 12

            end_index = (
                len(bank_list) - remaining_needed
            )  # total cards minus cards left behind in one pass of the loop
            window = bank_list[start_index:end_index]

            max_val = max(window)
            chosen_digits.append(str(max_val))

            max_val_index = window.index(max_val)
            start_index += max_val_index + 1

        return int(''.join(chosen_digits))

    def solve(self, file_path: str | Path, part: int = 2) -> int:
        path = Path(file_path)
        solver_func = (
            self.find_max_voltage_part_1 if part == 1 else self.find_max_voltage_part_2
        )
        total_voltage = 0
        with path.open('r', encoding='utf-8') as f:
            for bank in f:
                bank = bank.strip()
                if bank:
                    total_voltage += solver_func(bank)

        return total_voltage


if __name__ == '__main__':
    input_file = Path('advent_of_code/day_three/input.txt')
    battery_solver = BatterySolver()
    total = battery_solver.solve(input_file)
    print(f'Total output: {total}')

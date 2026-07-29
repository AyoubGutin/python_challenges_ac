class BatterySolver:
    def __init__(self, total_voltage: int = 0):
        self.total_voltage = total_voltage

    def find_max_voltage(self, bank: str) -> None:
        """
        For a battery bank, it finds the maximum voltage
        """
        bank_list = list(map(int, list(bank)))

        tens_digit = max(bank_list[:-1])
        tens_index = bank_list.index(tens_digit)
        ones_digit = max(bank_list[tens_index + 1 :])

        voltage_val = tens_digit * 10 + ones_digit
        self.total_voltage += voltage_val

    def parse_input(self, file_path: str) -> None:
        with open(file_path) as f:
            for bank in f:
                self.find_max_voltage(bank.strip())


if __name__ == '__main__':
    battery_solver = BatterySolver()
    battery_solver.parse_input('advent_of_code/day_three/input.txt')
    print(f'Total output: {battery_solver.total_voltage}')

# By: Ayoub Gutin
# Challenge: https://adventofcode.com/2025/day/1

import operator
import typing


class SafeDial:
    """
    Combination lock dial with positions from 0 to threshold -1
    """

    _OPERATIONS: typing.ClassVar[dict] = {'R': operator.add, 'L': operator.sub}

    def __init__(self, start_position: int = 50, threshold: int = 100) -> None:
        self.position = start_position
        self.threshold = threshold
        self.zero_hits = 0

    def rotate(self, direction: str, distance: int) -> int:
        """
        Rotates the dial
        """
        op = self._OPERATIONS.get(direction)

        for i in range(distance):
            self.position = op(self.position, 1) % self.threshold
            if self.position == 0:
                self.zero_hits += 1

    def process_file(self, filepath: str) -> str:
        with open(filepath, 'r') as f:
            rotations = (line.strip() for line in f if line.strip())

            for combo in rotations:
                direction = combo[0]
                distance = int(combo[1:])
                self.rotate(direction, distance)

            return self.zero_hits


if __name__ == '__main__':
    dial = SafeDial(start_position=50, threshold=100)
    password = dial.process_file('day_one/day_one_rotation_doc.txt')

    print(f'Final Dial Position: {dial.position}')
    print(f'Password (Zero Hits): {password}')

# By: Ayoub Gutin

## Challenge: https://adventofcode.com/2025/day/1

## Task

- Given a text file of rotations of a dial, start at pos = 50
- Go through each rotation of the format R/L{num} and rotate accordingly
- Boundary of dial is 0-99, so 100 states
- Calculate the final position, as well as how many times the dial hits zero.

## Thought Process

The first section of the challenge was to calculate how many times a _dial was left at 0_ after a given rotation.
To map the challenge to logic, I sketched out the calculations to see what would happen without the boundaries e.g., `rotate(50, R150) = 200`, `rotate(5, L3) = 2`.
Then, I thought about how to fit these into boundaries, expressed as a simple formula to make the most efficient solution.
The modulo operator was perfect for this as it forced a number to conform to a floor and return the remainder, looping the 0-99, representing the `position`.
Once this was thought about, I needed a way for the position to keep its state, so I turned to OOP, and added in the relevant attributes. - _I could have implemented it with global variables, but thought this was a nicer implementation. typical of a prod environment and coupled the related logic together_

The final object consisted of class level attributes, which would be the same no matter what instance is created. This is the configuration for the direction.
Instance-level attributes were then made, such as starting positions, threshold, and the amount of zero hits.
Once this was done, I needed to add in the logic, which was first rotating. Using the math logic expressed above, I looped through the distance, adding 1 or -1, depending on the direction, and calculated the amount of times it hit zero.
Finally, once tested with a few inputs, I added in simple code to parse the text file line by line.

## What can be improved

To be comprehensive, I could have added tests with sample text files to ensure the answers were what I was expecting, so I can be confident in the final answer before submitting.

Also, there is not that much error handling in the parsing itself, assuming that every line would conform to an expection of direction prefix followed by digits.

I could have added error handling, as well as signals to end the loop if a line was corrupted for example, possibly by raising the `StopIteration` exception when found.

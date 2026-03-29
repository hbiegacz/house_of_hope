"Test damage ranges after alignment"
FileStream fileIn: 'src/DiceRoller.st'.

| min max val |
min := 999. max := 0.
Transcript show: 'Testing Player Damage (4-11): '; cr.
1000 timesRepeat: [
    val := DiceRoller current roll: 4 to: 11.
    min := min min: val.
    max := max max: val.
].
Transcript show: 'Min: ', min printString, ' Max: ', max printString; cr.

min := 999. max := 0.
Transcript show: 'Testing Player Critical (8-22): '; cr.
1000 timesRepeat: [
    val := (DiceRoller current roll: 4 to: 11) * 2.
    min := min min: val.
    max := max max: val.
].
Transcript show: 'Min: ', min printString, ' Max: ', max printString; cr.

min := 999. max := 0.
Transcript show: 'Testing Enemy Damage (3-7): '; cr.
1000 timesRepeat: [
    val := DiceRoller current roll: 3 to: 7.
    min := min min: val.
    max := max max: val.
].
Transcript show: 'Min: ', min printString, ' Max: ', max printString; cr.

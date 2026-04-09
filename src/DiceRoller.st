"DiceRoller class - Handles random number generation for dice rolls."
Object subclass: DiceRoller [
    
    DiceRoller class [
        | currentInstance |
    ]

    " Returns the instance of the DiceRoller "
    DiceRoller class >> current [
        currentInstance ifNil: [ currentInstance := self new ].
        ^currentInstance
    ]

    " Performs a standard 20-sided dice roll "
    d20 [
        ^ (1 to: 20) atRandom
    ]

    " Returns a random number between 1 and the specified maximum value "
    roll: max [
        ^ (1 to: max) atRandom
    ]

    " Returns a random number within the specified inclusive range [min, max] "
    roll: min to: max [
        ^ (min to: max) atRandom
    ]
]

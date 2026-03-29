"DiceRoller class - Singleton for standard game rolls."

Object subclass: DiceRoller [
    
    DiceRoller class [
        | currentInstance |
    ]

    DiceRoller class >> current [
        currentInstance ifNil: [ currentInstance := self new ].
        ^currentInstance
    ]

    "Standard d20 roll"
    d20 [
        ^ (1 to: 20) atRandom
    ]

    "General roll"
    roll: max [
        ^ (1 to: max) atRandom
    ]

    "Roll in range"
    roll: min to: max [
        ^ (min to: max) atRandom
    ]
]

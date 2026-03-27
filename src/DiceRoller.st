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
    roll: anInteger [
        ^ (1 to: anInteger) atRandom
    ]
]

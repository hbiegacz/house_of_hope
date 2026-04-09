"GameState class - A singleton that tracks global progress and world state flags."
Object subclass: GameState [
    | barrierOpen prisonOpen hopeFree riddleSolved contractTaken secretTunnelOpen |

    GameState class [
        | currentInstance |
    ]

    GameState class >> current [
        currentInstance ifNil: [ currentInstance := self new. currentInstance initFlags ].
        ^currentInstance
    ]

    " Sets all progress flags to their initial state "
    initFlags [
        barrierOpen := false.
        prisonOpen := false.
        hopeFree := false.
        riddleSolved := false.
        contractTaken := false.
        secretTunnelOpen := false.
    ]

    " true if the Banquet Hall barrier has been deactivated "
    barrierOpen [ ^barrierOpen ]
    barrierOpen: aBoolean [ barrierOpen := aBoolean ]

    " true if the Prison area is accessible "
    prisonOpen [ ^prisonOpen ]
    prisonOpen: aBoolean [ prisonOpen := aBoolean ]

    " true if the NPC Hope has been liberated "
    hopeFree [ ^hopeFree ]
    hopeFree: aBoolean [ hopeFree := aBoolean ]

    " true if the Sphinx's riddle has been correctly answered "
    riddleSolved [ ^riddleSolved ]
    riddleSolved: aBoolean [ riddleSolved := aBoolean ]

    " true if the player has acquired the Soul Contract "
    contractTaken [ ^contractTaken ]
    contractTaken: aBoolean [ contractTaken := aBoolean ]

    " true if the secret passage to the engine room is available "
    secretTunnelOpen [ ^secretTunnelOpen ]
    secretTunnelOpen: aBoolean [ secretTunnelOpen := aBoolean ]
]

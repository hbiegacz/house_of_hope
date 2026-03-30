"GameState class - This remembers game progress, like if a door is unlocked, a puzzle is solved or is Hope freed."

Object subclass: GameState [
    | barrierOpen prisonOpen hopeFree riddleSolved contractTaken secretTunnelOpen |

    GameState class [
        | currentInstance |
    ]

    GameState class >> current [
        currentInstance ifNil: [ currentInstance := self new. currentInstance initFlags ].
        ^currentInstance
    ]

    initFlags [
        barrierOpen := false.
        prisonOpen := false.
        hopeFree := false.
        riddleSolved := false.
        contractTaken := false.
        secretTunnelOpen := false.
    ]

    barrierOpen [ ^barrierOpen ]
    barrierOpen: aBoolean [ barrierOpen := aBoolean ]

    prisonOpen [ ^prisonOpen ]
    prisonOpen: aBoolean [ prisonOpen := aBoolean ]

    hopeFree [ ^hopeFree ]
    hopeFree: aBoolean [ hopeFree := aBoolean ]

    riddleSolved [ ^riddleSolved ]
    riddleSolved: aBoolean [ riddleSolved := aBoolean ]

    contractTaken [ ^contractTaken ]
    contractTaken: aBoolean [ contractTaken := aBoolean ]

    secretTunnelOpen [ ^secretTunnelOpen ]
    secretTunnelOpen: aBoolean [ secretTunnelOpen := aBoolean ]
]

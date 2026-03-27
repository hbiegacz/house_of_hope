"Entity class - Base class for all living things in the game."

Object subclass: Entity [
    | name hp maxHp |

    Entity class >> name: aName hp: currentHp maxHp: maximumHp [
        | e |
        e := self new.
        e name: aName; hp: currentHp; maxHp: maximumHp.
        ^e
    ]

    name [ ^name ]
    name: aString [ name := aString ]

    hp [ ^hp ]
    hp: anInteger [ hp := anInteger ]

    maxHp [ ^maxHp ]
    maxHp: anInteger [ maxHp := anInteger ]

    isAlive [
        ^hp > 0
    ]

    takeDamage: anAmount [
        hp := hp - anAmount.
        hp < 0 ifTrue: [ hp := 0 ].
    ]

    heal: anAmount [
        hp := hp + anAmount.
        hp > maxHp ifTrue: [ hp := maxHp ].
    ]
]

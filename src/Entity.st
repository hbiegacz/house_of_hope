"Entity class - This is the basic template for all living things (players, monsters). It stores HP and name."

Object subclass: Entity [
    | name hp maxHp |

    Entity class >> name: aName hp: currentHp maxHp: maximumHp [
        | e |
        e := self new.
        e name: aName; hp: currentHp; maxHp: maximumHp.
        ^e
    ]

    "Getters/Setters"
    name [ ^name ]
    name: aString [ name := aString ]

    hp [ ^hp ]
    hp: anInteger [ hp := anInteger ]

    maxHp [ ^maxHp ]
    maxHp: anInteger [ maxHp := anInteger ]

    "Check if entity still exists"
    isAlive [ ^hp > 0 ]

    "Core mechanics"
    hpDisplay [
        | suffix |
        suffix := (hp = maxHp) ifTrue: [ ' (max)' ] ifFalse: [ '' ].
        ^ '(HP: ', hp printString, suffix, ')'
    ]

    takeDamage: anAmount [
        hp := (hp - anAmount) max: 0.
    ]

    heal: anAmount [
        hp := (hp + anAmount) min: maxHp.
    ]

    increaseMaxHp: anAmount [
        maxHp := maxHp + anAmount.
        hp := hp + anAmount.
    ]
]

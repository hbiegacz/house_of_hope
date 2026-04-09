"Entity class - Base class for all living creatures in the game, managing health and identity."
Object subclass: Entity [
    | name hp maxHp |

    " Creates a new entity with a name and health values "
    Entity class >> name: aName hp: currentHp maxHp: maximumHp [
        | e |
        e := self new.
        e name: aName; hp: currentHp; maxHp: maximumHp.
        ^e
    ]

    " the name of the entity "
    name [ ^name ]
    name: aString [ name := aString ]

    " current health points "
    hp [ ^hp ]
    hp: anInteger [ hp := anInteger ]

    " maximum health capacity "
    maxHp [ ^maxHp ]
    maxHp: anInteger [ maxHp := anInteger ]

    " Returns true if the entity has more than 0 health points "
    isAlive [ ^hp > 0 ]

    " Returns a formatted string showing current HP status "
    hpDisplay [
        | suffix |
        suffix := (hp = maxHp) ifTrue: [ ' (max)' ] ifFalse: [ '' ].
        ^ '(HP: ', hp printString, suffix, ')'
    ]

    " Reduces current health by an amount, stopped at 0 "
    takeDamage: anAmount [
        hp := (hp - anAmount) max: 0.
    ]

    " Increases current health by an amount, stopped at maxHp "
    heal: anAmount [
        hp := (hp + anAmount) min: maxHp.
    ]

    " Permanently increases maximum health and raises current HP by the same amount "
    increaseMaxHp: anAmount [
        maxHp := maxHp + anAmount.
        hp := hp + anAmount.
    ]
]

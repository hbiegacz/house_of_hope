"Enemy class - Represents hostile entities in the world."

Entity subclass: Enemy [
    | attackDc armorClass description |

    Enemy class >> name: aName hp: currentHp maxHp: maximumHp ac: ac dc: dc description: aDescription [
        | e |
        e := self new.
        e name: aName; hp: currentHp; maxHp: maximumHp.
        e armorClass: ac; attackDc: dc; description: aDescription.
        ^e
    ]

    armorClass [ ^armorClass ]
    armorClass: anInteger [ armorClass := anInteger ]

    attackDc [ ^attackDc ]
    attackDc: anInteger [ attackDc := anInteger ]

    description [ ^description ]
    description: aString [ description := aString ]
    
    "For debugging"
    printOn: aStream [
        aStream nextPutAll: name.
        aStream nextPutAll: ' (HP: '.
        aStream nextPutAll: hp printString.
        aStream nextPutAll: ')'.
    ]
]

"Enemy class - Represents hostile entities that the player encounters in combat."
Entity subclass: Enemy [
    | attackDc armorClass description |

    " Creates a new enemy with specified attributes including HP, Armor Class (AC), and Attack Difficulty Class (DC) "
    Enemy class >> name: aName hp: currentHp maxHp: maximumHp ac: ac dc: dc description: aDescription [
        | e |
        e := self new.
        e name: aName; hp: currentHp; maxHp: maximumHp.
        e armorClass: ac; attackDc: dc; description: aDescription.
        ^e
    ]

    " the Armor Class of the enemy "
    armorClass [ ^armorClass ]
    armorClass: anInteger [ armorClass := anInteger ]

    " the Attack Difficulty Class used for this enemy's offensive checks "
    attackDc [ ^attackDc ]
    attackDc: anInteger [ attackDc := anInteger ]

    " the text description of the enemy "
    description [ ^description ]
    description: aString [ description := aString ]
    
    " Prints a short summary of the enemy (Name and current HP) "
    printOn: aStream [
        aStream nextPutAll: name.
        aStream nextPutAll: ' (HP: '.
        aStream nextPutAll: hp printString.
        aStream nextPutAll: ')'.
    ]
]

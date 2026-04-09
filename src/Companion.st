"Companion class - Represents party members that provide stat bonuses to the player."
Object subclass: Companion [
    | name boostedStat bonusValue |

    " Creates a new companion with a name, a stat they boost, and the bonus value they provide "
    Companion class >> name: aName stat: aStat value: aValue [
        | c |
        c := self new.
        c name: aName; boostedStat: aStat; bonusValue: aValue.
        ^c
    ]

    " the name of the companion "
    name [ ^name ]
    name: aString [ name := aString ]

    " the stat name that this companion boosts (e.g., 'strength') "
    boostedStat [ ^boostedStat ]
    boostedStat: aString [ boostedStat := aString ]

    " the integer value of the bonus provided "
    bonusValue [ ^bonusValue ]
    bonusValue: anInteger [ bonusValue := anInteger ]
    
    " Prints a human-readable description of the companion and their bonus "
    printOn: aStream [
        | capitalizedStat |
        capitalizedStat := (boostedStat at: 1) asUppercase asString, (boostedStat copyFrom: 2).
        aStream nextPutAll: name.
        aStream nextPutAll: ' (+'.
        aStream nextPutAll: bonusValue printString.
        aStream nextPutAll: ' '.
        aStream nextPutAll: capitalizedStat.
        aStream nextPutAll: ')'.
    ]
]

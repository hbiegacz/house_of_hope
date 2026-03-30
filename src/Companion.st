"Companion class - This represents your friends in the game who give you bonus stats."

Object subclass: Companion [
    | name boostedStat bonusValue |

    Companion class >> name: aName stat: aStat value: aValue [
        | c |
        c := self new.
        c name: aName; boostedStat: aStat; bonusValue: aValue.
        ^c
    ]

    name [ ^name ]
    name: aString [ name := aString ]

    boostedStat [ ^boostedStat ]
    boostedStat: aString [ boostedStat := aString ]

    bonusValue [ ^bonusValue ]
    bonusValue: anInteger [ bonusValue := anInteger ]
    
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

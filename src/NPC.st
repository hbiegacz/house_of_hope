"NPC class - This represents characters players can talk to. They give hints or ask riddles."

Object subclass: NPC [
    | name description dialogue riddle answer |

    NPC class >> name: aName description: aDescription [
        | n |
        n := self new.
        n name: aName; description: aDescription; initNpc.
        ^n
    ]

    initNpc [
        dialogue := OrderedCollection new.
    ]

    "Accessors"
    name [ ^name ]
    name: aString [ name := aString ]

    description [ ^description ]
    description: aString [ description := aString ]

    riddle [ ^riddle ]
    riddle: aString [ riddle := aString ]

    answer [ ^answer ]
    answer: aString [ answer := aString ]
    
    printOn: aStream [
        aStream nextPutAll: name.
    ]
]

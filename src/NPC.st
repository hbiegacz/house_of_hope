"NPC class - Represents non-player characters that the player can interact with."
Object subclass: NPC [
    | name description dialogue riddle answer |

    " Creates a new NPC with a name and description "
    NPC class >> name: aName description: aDescription [
        | n |
        n := self new.
        n name: aName; description: aDescription; initNpc.
        ^n
    ]

    " Initializes the NPC state, including their internal dialogue collection "
    initNpc [
        dialogue := OrderedCollection new.
    ]

    " the name of the NPC "
    name [ ^name ]
    name: aString [ name := aString ]

    " the description of the NPC "
    description [ ^description ]
    description: aString [ description := aString ]

    " a riddle that the NPC might pose "
    riddle [ ^riddle ]
    riddle: aString [ riddle := aString ]

    " the expected answer to the NPC's riddle "
    answer [ ^answer ]
    answer: aString [ answer := aString ]

    " Prints the name of the NPC to the specified stream "
    printOn: aStream [
        aStream nextPutAll: name.
    ]
]

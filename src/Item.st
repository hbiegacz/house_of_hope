"Item class - Base class for objects in the game world."

Object subclass: Item [
    | name description hint |

    Item class >> name: aName description: aDescription [
        | i |
        i := self new.
        i name: aName; description: aDescription.
        ^i
    ]

    name [ ^name ]
    name: aString [ name := aString ]

    description [ ^description ]
    description: aString [ description := aString ]

    hint [ ^hint ]
    hint: aString [ hint := aString ]
    
    "For debugging/list display"
    printOn: aStream [
        aStream nextPutAll: name.
    ]
]

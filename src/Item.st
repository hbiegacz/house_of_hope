"Item class - Objects that can be carried or used."

Object subclass: Item [
    | name description hint |

    Item class >> name: aName description: aDescription [
        | i |
        i := self new.
        i name: aName; description: aDescription.
        ^i
    ]

    "Accessors"
    name [ ^name ]
    name: aString [ name := aString ]

    description [ ^description ]
    description: aString [ description := aString ]

    hint [ ^hint ]
    hint: aString [ hint := aString ]
    
    printOn: aStream [
        aStream nextPutAll: name.
    ]
]

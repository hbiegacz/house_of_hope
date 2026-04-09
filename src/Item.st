"Item class - Defines objects that can be collected, examined, or used by the player."
Object subclass: Item [
    | name description hint |

    " Creates a new item with a name and a basic description "
    Item class >> name: aName description: aDescription [
        | i |
        i := self new.
        i name: aName; description: aDescription.
        ^i
    ]

    " the name of the item "
    name [ ^name ]
    name: aString [ name := aString ]

    " the basic description of the item "
    description [ ^description ]
    description: aString [ description := aString ]

    " an optional hidden hint revealed upon successful examination "
    hint [ ^hint ]
    hint: aString [ hint := aString ]
    
    " Prints the name of the item "
    printOn: aStream [
        aStream nextPutAll: name.
    ]
]

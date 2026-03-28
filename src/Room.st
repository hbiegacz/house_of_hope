"Room class - Represents a location in the game world."

Object subclass: Room [
    | name description neighbors items npcs enemies |

    Room class >> name: aName description: aDescription [
        | r |
        r := self new.
        r name: aName; description: aDescription; initRoom.
        ^r
    ]

    initRoom [
        neighbors := Dictionary new.
        items := Set new.
        npcs := OrderedCollection new.
        enemies := Set new.
    ]

    findItemNamed: aString [
        ^items detect: [ :item | item name sameAs: aString ] ifNone: [ nil ]
    ]

    name [ ^name ]
    name: aString [ name := aString ]

    description [ ^description ]
    description: aString [ description := aString ]

    neighbors [ ^neighbors ]
    items [ ^items ]
    npcs [ ^npcs ]
    enemies [ ^enemies ]

    addNpc: anNpc [ npcs add: anNpc ]
    
    findNpcNamed: aString [
        ^npcs detect: [ :n | n name sameAs: aString ] ifNone: [ nil ]
    ]

    addNeighbor: aRoom direction: aDirection [
        neighbors at: aDirection put: aRoom.
    ]

    getExit: aDirection [
        ^neighbors at: aDirection ifAbsent: [ nil ]
    ]

    addItem: anItem [
        items add: anItem.
    ]

    removeItem: anItem [
        items remove: anItem ifAbsent: [ Transcript show: 'No such item in ', name; cr ].
    ]

    describe [
        Transcript cr; show: 'Current position: ', name asLowercase; cr.
        Transcript show: '--- LOCATION DESCRIPTION ---'; cr.
        Transcript show: description; cr; cr.
        
        npcs do: [ :npc | 
            Transcript show: '>> You see someone here: ', npc name asLowercase, '. You can "talk ', npc name asLowercase, '"'; cr.
        ].
        
        items isEmpty ifFalse: [
            Transcript show: '>> You found the following items:'; cr.
            items do: [ :i | Transcript show: '- ', i name asLowercase, ': ', i description; cr ].
            Transcript show: 'You can use "take ', (items asArray first name asLowercase), '" to pick them up.'; cr.
        ].

        Transcript cr.
        Transcript show: 'Available Exits:'; cr.
        neighbors keys do: [ :dir | Transcript show: '- ', dir; cr ].
        Transcript cr.
    ]
]

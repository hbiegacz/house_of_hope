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
        Transcript show: '---- ', name, ' ----'; cr.
        Transcript show: description; cr.
        Transcript show: 'Exits: ', neighbors keys asArray printString; cr.
        items isEmpty ifFalse: [ Transcript show: 'Items: ', items asArray printString; cr ].
        npcs isEmpty ifFalse: [ Transcript show: 'NPCs: ', npcs asArray printString; cr ].
        enemies isEmpty ifFalse: [ Transcript show: 'Enemies! ', enemies asArray printString; cr ].
        Transcript cr.
    ]
]

"Room class - This represents a single location on the map. It holds enemies, items, and NPCs."

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
        items := OrderedCollection new.
        npcs := OrderedCollection new.
        enemies := OrderedCollection new.
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

    addItem: anItem [ items add: anItem. ]
    removeItem: anItem [
        items remove: anItem ifAbsent: [ Transcript show: 'No such item here.'; cr ].
    ]
    
    findItemNamed: aString [
        ^items detect: [ :item | item name sameAs: aString ] ifNone: [ nil ]
    ]

    describe [
        Transcript cr; show: 'Current position: ', name; cr.
        Transcript show: '--- LOCATION DESCRIPTION ---'; cr.
        (name sameAs: 'Prison') ifTrue: [
            (GameState current hopeFree) ifTrue: [
                Transcript show: 'The Prison. The heavy chains lie shattered on the floor.'; cr.
                Transcript show: 'Hope is standing here, looking at the ceiling with a smile.'; cr.
            ] ifFalse: [ Transcript show: description; cr ].
        ] ifFalse: [ Transcript show: description; cr ].
        Transcript cr.
        
        npcs do: [ :npc | 
            Transcript show: '>> You see someone here: ', npc name, '. (Type: talk ', npc name, ')'; cr.
        ].
        
        items isEmpty ifFalse: [
            Transcript show: '>> You found the following items. Use "take [item]" to pick them up.'; cr.
            items do: [ :i | Transcript show: '- ', i name, ': ', i description; cr ].
        ].

        Transcript cr; show: 'Available Exits:'; cr.
        neighbors keys do: [ :dir | Transcript show: '- ', dir; cr ].
        Transcript cr.
    ]
]

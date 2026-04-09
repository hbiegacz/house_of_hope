"Room class - Represents a location in the game world, containing items, NPCs, and enemies."
Object subclass: Room [
    | name description neighbors items npcs enemies |

    " Creates a new room with a name and description "
    Room class >> name: aName description: aDescription [
        | r |
        r := self new.
        r name: aName; description: aDescription; initRoom.
        ^r
    ]

    " Initializes the room's collections for neighbors, items, NPCs, and enemies "
    initRoom [
        neighbors := Dictionary new.
        items := OrderedCollection new.
        npcs := OrderedCollection new.
        enemies := OrderedCollection new.
    ]

    " the name of the room "
    name [ ^name ]
    name: aString [ name := aString ]

    " the text description of the room "
    description [ ^description ]
    description: aString [ description := aString ]

    " the dictionary of neighboring rooms "
    neighbors [ ^neighbors ]

    " the collection of items currently in the room "
    items [ ^items ]

    " the collection of NPCs currently in the room "
    npcs [ ^npcs ]

    " the collection of enemies currently in the room "
    enemies [ ^enemies ]

    " Links this room to another room in a specific direction "
    addNeighbor: aRoom direction: aDirection [
        neighbors at: aDirection put: aRoom.
    ]

    " Returns the room located in the specified direction, or nil if none "
    getExit: aDirection [
        ^neighbors at: aDirection ifAbsent: [ nil ]
    ]

    " Adds an NPC to the room "
    addNpc: anNpc [ npcs add: anNpc ]
    
    " Finds and returns an NPC by name, or nil if not found "
    findNpcNamed: aString [
        ^npcs detect: [ :n | n name sameAs: aString ] ifNone: [ nil ]
    ]

    " Adds an item to the room "
    addItem: anItem [ items add: anItem. ]

    " Removes a specific item from the room "
    removeItem: anItem [
        items remove: anItem ifAbsent: [ Transcript show: 'No such item here.'; cr ].
    ]
    
    " Finds and returns an item by name, or nil if not found "
    findItemNamed: aString [
        ^items detect: [ :item | item name sameAs: aString ] ifNone: [ nil ]
    ]

    " Prints the room's description, occupants, and available exits to the Transcript "
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

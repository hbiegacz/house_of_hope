"World class - Singleton managing the game map and progression."

Object subclass: World [
    | rooms currentRoom player |

    World class [
        | currentInstance |
    ]

    World class >> current [
        currentInstance ifNil: [ currentInstance := self new. currentInstance initWorld ].
        ^currentInstance
    ]

    initWorld [
        rooms := Dictionary new.
        self setupMap.
    ]

    player [ ^player ]
    player: aPlayer [ player := aPlayer ]
    
    currentRoom [ ^currentRoom ]
    currentRoom: aRoom [ currentRoom := aRoom ]

    setupMap [
        | foyer banquet vault prison garden kitchen boudoir |

        "Create rooms based on OPIS_GRY.md Section 3"
        foyer := Room name: 'Foyer' description: 'Centralny punkt House of Hope. Jest tu cicho i elegancko.'.
        banquet := Room name: 'Banquet Hall' description: 'Wielka sala biesiadna. Pachnie pieczonym miesem i winem.'.
        vault := Room name: 'Vault' description: 'Skarbiec chroniony magiczna barierą. Widzisz drogocenne przedmioty.'.
        prison := Room name: 'Prison' description: 'Ciemne i zimne lochy. Słychać jęki potępionych.'.
        garden := Room name: 'Garden' description: 'Ogród pełen egzotycznych roślin. Na środku stoi Sphinx.'.

        "Items from OPIS_GRY.md Section 6"
        banquet addItem: ((Item name: 'Incantation' description: 'Starozytny zwoj pism potrzebny do otwarcia Skarbca.') 
            hint: 'Ten wysokiej jakosci zwoj reaguje na magie. Moze otworzyc przejscie do Skarbca.').
        
        "Set neighbors / Map graph"
        foyer addNeighbor: banquet direction: 'north'.
        foyer addNeighbor: prison direction: 'south'.
        
        banquet addNeighbor: foyer direction: 'south'.
        banquet addNeighbor: vault direction: 'north'.
        banquet addNeighbor: garden direction: 'east'.
        
        vault addNeighbor: banquet direction: 'south'.
        
        prison addNeighbor: foyer direction: 'north'.
        
        garden addNeighbor: banquet direction: 'west'.

        "Store rooms"
        rooms at: 'Foyer' put: foyer.
        rooms at: 'Banquet Hall' put: banquet.
        rooms at: 'Vault' put: vault.
        rooms at: 'Prison' put: prison.
        rooms at: 'Garden' put: garden.

        "Set starting position"
        currentRoom := foyer.
    ]

    "Movement logic"
    moveTo: aDirection [
        | nextRoom |
        nextRoom := currentRoom getExit: aDirection.
        
        nextRoom ifNil: [
            Transcript show: 'Nie mozesz isc w tym kierunku.'; cr.
            ^false
        ].

        "Check for barriers (Logika z OPIS_GRY.md sections 3/4)"
        (currentRoom name = 'Banquet Hall' and: [ aDirection = 'north' ]) ifTrue: [
            (GameState current barrierOpen) ifFalse: [
                Transcript show: 'Bariera magiczna (półprzezroczysta ściana ognia) blokuje wejście do Skarbca! (Wymaga incantation)'; cr.
                ^false
            ].
        ].

        currentRoom := nextRoom.
        Transcript show: 'Idziesz na ', aDirection; cr.
        currentRoom describe.
        ^true
    ]

    look [
        currentRoom describe.
    ]
]

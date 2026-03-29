"World class - Singleton managing the game map and progression."

Object subclass: World [
    | rooms currentRoom previousRoom player |
    
    World class [
        | currentInstance |
    ]
    
    World class >> current [
        currentInstance ifNil: [ 
            currentInstance := self new. 
            currentInstance initWorld 
        ].
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
        self setupRooms.
        self setupItems.
        self setupNpcsAndEnemies.
        self setupConnections.
        currentRoom := rooms at: 'Foyer'.
    ]

    setupRooms [
        rooms at: 'Foyer' put: (Room name: 'Foyer' description: 'The central hub of the House of Hope. Gilded mirrors line the walls, reflecting a haunted version of yourself.').
        rooms at: 'Banquet Hall' put: (Room name: 'Banquet Hall' description: 'A vast dining hall. A table overflows with rotting, magical delicacies.').
        rooms at: 'Vault' put: (Room name: 'Vault' description: 'A treasure chamber protected by a magical barrier. You see priceless artifacts.').
        rooms at: 'Prison' put: (Room name: 'Prison' description: 'In the center, a woman named Hope is bound by glowing, magical chains.').
        rooms at: 'Garden' put: (Room name: 'Garden' description: 'Twisted black roses and obsidian statues fill this eerie courtyard.').
        rooms at: 'Servant Quarters' put: (Room name: 'Servant Quarters' description: 'Small, sparse beds that smell of old fear and cheap incense.').
        rooms at: 'Kitchen' put: (Room name: 'Kitchen' description: 'Heavy iron pots bubble with something best left untasted.').
        rooms at: 'Boudoir' put: (Room name: 'Boudoir' description: 'Raphael''s private sanctuary. Velvet curtains and ancient scrolls.').
        rooms at: 'Secret Tunnel' put: (Room name: 'Secret Tunnel' description: 'A narrow, damp passage smelling of mildew and secrets.').
    ]

    setupItems [
        | banquet boudoir vault foyer kitchen |
        banquet := rooms at: 'Banquet Hall'.
        banquet addItem: ((Item name: 'Incantation' description: 'An ancient scroll of shifting runes.') 
            hint: 'It can open the passage to the Vault.').
        banquet addItem: ((Item name: 'Potion' description: 'A red liquid vial (+10 HP).')
            hint: 'Heals 10 hit points.').
        
        boudoir addItem: ((Item name: 'Orphic Hammer' description: 'A powerful hammer for shattering infernal bonds.')
            hint: 'Can break the chains in the prison.').
        boudoir addItem: ((Item name: 'Strange Brew' description: 'A murky, bubbling concoction. It smells unpredictable.')
            hint: 'A rare potion with random magical effects.').
        
        vault := rooms at: 'Vault'.
        vault addItem: ((Item name: 'Soul Contract' description: 'Your contract with Raphael.')
            hint: 'Once taken, Raphael will return.').
        
        foyer := rooms at: 'Foyer'.
        foyer addItem: ((Item name: 'Old Coin' description: 'An old rare coin.')
            hint: 'Might interest a collector.').
        
        kitchen := rooms at: 'Kitchen'.
        kitchen addItem: ((Item name: 'Rusty Key' description: 'A heavy iron key.')
            hint: 'Unlocks the Secret Tunnel between Vault and Garden.').
    ]

    setupNpcsAndEnemies [
        | garden servant sphinx collector |
        garden := rooms at: 'Garden'.
        sphinx := NPC name: 'Sphinx' description: 'A majestic creature with a human face.'.
        sphinx riddle: 'I can be broken without being touched. What am I?'; answer: 'promise'.
        garden addNpc: sphinx.
        garden enemies add: (Enemy name: 'Cambion' hp: 40 maxHp: 40 ac: 14 dc: 14 description: 'A powerful demonic warrior.').
        
        servant := rooms at: 'Servant Quarters'.
        collector := NPC name: 'Collector' description: 'A small devil obsessive about collections.'.
        servant addNpc: collector.
        servant enemies add: (Enemy name: 'Imp' hp: 15 maxHp: 15 ac: 12 dc: 10 description: 'A small, annoying flying devil.').
    ]

    setupConnections [
        | foyer banquet vault prison garden servant kitchen boudoir secretTunnel |
        foyer := rooms at: 'Foyer'. banquet := rooms at: 'Banquet Hall'. vault := rooms at: 'Vault'.
        prison := rooms at: 'Prison'. garden := rooms at: 'Garden'. servant := rooms at: 'Servant Quarters'.
        kitchen := rooms at: 'Kitchen'. boudoir := rooms at: 'Boudoir'. secretTunnel := rooms at: 'Secret Tunnel'.

        foyer addNeighbor: banquet direction: 'north'; addNeighbor: prison direction: 'south'; addNeighbor: servant direction: 'west'; addNeighbor: boudoir direction: 'east'.
        banquet addNeighbor: foyer direction: 'south'; addNeighbor: vault direction: 'north'; addNeighbor: garden direction: 'east'; addNeighbor: kitchen direction: 'west'.
        vault addNeighbor: banquet direction: 'south'; addNeighbor: secretTunnel direction: 'east'.
        prison addNeighbor: foyer direction: 'north'.
        garden addNeighbor: banquet direction: 'west'; addNeighbor: boudoir direction: 'south'; addNeighbor: secretTunnel direction: 'north'.
        servant addNeighbor: foyer direction: 'east'; addNeighbor: kitchen direction: 'north'.
        kitchen addNeighbor: servant direction: 'south'; addNeighbor: banquet direction: 'east'.
        boudoir addNeighbor: foyer direction: 'west'; addNeighbor: garden direction: 'north'.
        secretTunnel addNeighbor: vault direction: 'west'; addNeighbor: garden direction: 'south'.
    ]

    "Map display"
    printMap [
        Transcript cr; show: '        --- HOUSE OF HOPE MAP ---'; cr.
        Transcript show: '                   [ Vault ] <---> [ Secret Tunnel ]'; cr.
        Transcript show: '                       ^                   |'; cr.
        Transcript show: ' [ Kitchen ] <-> [ Banquet Hall ] <---> [ Garden ]'; cr.
        Transcript show: '     ^           (      ^       )         ^'; cr.
        Transcript show: ' [ Servant ] <-> [    Foyer     ] <---> [ Boudoir ]'; cr.
        Transcript show: '                 (      ^       ) '; cr.
        Transcript show: '                 [    Prison    ]'; cr; cr.
    ]

    moveTo: aDirection [
        | nextRoom |
        nextRoom := currentRoom getExit: aDirection.
        
        nextRoom ifNil: [ Transcript show: 'Error: Cannot go that way.'; cr. ^false ].
        
        (nextRoom name = 'Vault' and: [ GameState current barrierOpen not ]) ifTrue: [
            Transcript show: 'Vault is protected by a magical barrier. Need Incantation.'; cr. ^false
        ].
        
        (nextRoom name = 'Secret Tunnel' and: [ (player findItemNamed: 'Rusty Key') isNil ]) ifTrue: [
            Transcript show: 'Secret Tunnel is locked. Need Rusty Key.'; cr. ^false
        ].
        
        previousRoom := nextRoom ifNotNil: [ currentRoom ].
        currentRoom := nextRoom.
        self printMap.
        currentRoom describe.
        ^true
    ]
    
    fleeBack [
        previousRoom ifNotNil: [
            currentRoom := previousRoom.
            Transcript show: 'You scrambled back to ', currentRoom name; cr.
            self printMap.
            currentRoom describe.
            ^true
        ].
        Transcript show: 'Nowhere to run!'; cr.
        ^false
    ]
    
    look [
        self printMap.
        currentRoom describe.
    ]
]
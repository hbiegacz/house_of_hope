"World class - Singleton managing the game map and progression."

Object subclass: World [
    | rooms currentRoom player |
    
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
        | foyer banquet vault prison garden sphinx collector servant kitchen boudoir hammer contract coin secretTunnel |
        
        foyer := Room name: 'Foyer' description: 'The central hub of the House of Hope. Gilded mirrors line the walls, reflecting a haunted version of yourself.'.
        banquet := Room name: 'Banquet Hall' description: 'A vast dining hall. A table overflows with rotting, magical delicacies.'.
        vault := Room name: 'Vault' description: 'A treasure chamber protected by a magical barrier. You see priceless artifacts.'.
        prison := Room name: 'Prison' description: 'In the center, a woman named Hope is bound by glowing, magical chains.'.
        garden := Room name: 'Garden' description: 'Twisted black roses and obsidian statues fill this eerie courtyard.'.
        servant := Room name: 'Servant Quarters' description: 'Small, sparse beds that smell of old fear and cheap incense.'.
        kitchen := Room name: 'Kitchen' description: 'Heavy iron pots bubble with something best left untasted.'.
        boudoir := Room name: 'Boudoir' description: 'Raphael''s private sanctuary. Velvet curtains and ancient scrolls.'.
        secretTunnel := Room name: 'Secret Tunnel' description: 'A narrow, damp passage smelling of mildew and secrets.'.
        
        "Items"
        banquet addItem: ((Item name: 'Incantation' description: 'An ancient scroll of writings covered in glowing, shifting runes.') 
            hint: 'This high-quality scroll reacts to magic. It can open the passage to the Vault.').
        
        hammer := Item name: 'Orphic Hammer' description: 'A powerful hammer capable of shattering infernal bonds.'.
        hammer hint: 'It seems to be the only thing capable of breaking the chains in the prison.'.
        boudoir addItem: hammer.
        
        contract := Item name: 'Soul Contract' description: 'Your contract with Raphael. You must reclaim it.'.
        contract hint: 'Once you take it, Raphael will surely feel it and return home.'.
        vault addItem: contract.
        
        coin := Item name: 'Old Coin' description: 'An old, rare coin with a portrait of a smiling devil.'.
        coin hint: 'It might interest someone who collects rare oddities.'.
        foyer addItem: coin. 
        
        kitchen addItem: ((Item name: 'Rusty Key' description: 'A heavy iron key, thick with rust. It belongs to a hidden door.')
            hint: 'This heavy key is said to unlock the Secret Tunnel that connects the Vault and the Garden.').
        
        "NPCs"
        sphinx := NPC name: 'Sphinx' description: 'A majestic creature with the body of a lion and a human face.'.
        sphinx riddle: 'I can be broken without being touched. What am I?'.
        sphinx answer: 'promise'.
        garden addNpc: sphinx.
        
        collector := NPC name: 'Collector' description: 'A small devil obsessive about gold and collections.'.
        servant addNpc: collector.
        
        "Enemies"
        servant enemies add: (Enemy name: 'Imp' hp: 15 maxHp: 15 ac: 12 dc: 10 description: 'A small, annoying flying devil.').
        garden enemies add: (Enemy name: 'Cambion' hp: 40 maxHp: 40 ac: 14 dc: 14 description: 'A powerful demonic warrior with a heavy spear.').
        
        banquet addItem: ((Item name: 'Potion' description: 'A red liquid in a glass vial. It smells of cherries (+10 HP).')
            hint: 'A magical restorative that heals 10 hit points upon consumption.').
        
        "Connectivity - Aligned with Prolog log map"
        foyer addNeighbor: banquet direction: 'north'.
        foyer addNeighbor: prison direction: 'south'.
        foyer addNeighbor: servant direction: 'west'.
        foyer addNeighbor: boudoir direction: 'east'.
        
        banquet addNeighbor: foyer direction: 'south'.
        banquet addNeighbor: vault direction: 'north'.
        banquet addNeighbor: garden direction: 'east'.
        banquet addNeighbor: kitchen direction: 'west'.
        
        vault addNeighbor: banquet direction: 'south'.
        vault addNeighbor: secretTunnel direction: 'east'.
        
        prison addNeighbor: foyer direction: 'north'.
        
        garden addNeighbor: banquet direction: 'west'.
        garden addNeighbor: boudoir direction: 'south'.
        garden addNeighbor: secretTunnel direction: 'north'.
        
        servant addNeighbor: foyer direction: 'east'.
        servant addNeighbor: kitchen direction: 'north'.
        
        kitchen addNeighbor: servant direction: 'south'.
        kitchen addNeighbor: banquet direction: 'east'.
        
        boudoir addNeighbor: foyer direction: 'west'.
        boudoir addNeighbor: garden direction: 'north'.

        secretTunnel addNeighbor: vault direction: 'west'.
        secretTunnel addNeighbor: garden direction: 'south'.
        
        rooms at: 'Foyer' put: foyer.
        rooms at: 'Banquet Hall' put: banquet.
        rooms at: 'Vault' put: vault.
        rooms at: 'Prison' put: prison.
        rooms at: 'Garden' put: garden.
        rooms at: 'Servant Quarters' put: servant.
        rooms at: 'Kitchen' put: kitchen.
        rooms at: 'Boudoir' put: boudoir.
        rooms at: 'Secret Tunnel' put: secretTunnel.
        
        currentRoom := foyer.
    ]

    "Map display matching Prolog log"
    printMap [
        Transcript cr; show: '        --- EXPANDED HOUSE OF HOPE MAP ---'; cr.
        Transcript show: '                   [ Vault ] <----> [ Secret Tunnel ]'; cr.
        Transcript show: '                       ^                    |'; cr.
        Transcript show: '                       |                    v'; cr.
        Transcript show: ' [ Kitchen ] <-> [ Banquet Hall ] <---> [ Garden ]'; cr.
        Transcript show: '     ^           (      ^       )         ^'; cr.
        Transcript show: '     v           (      v       )         v'; cr.
        Transcript show: ' [ Servant ] <-> [    Foyer     ] <---> [ Boudoir ]'; cr.
        Transcript show: '                 (      ^       ) '; cr.
        Transcript show: '                 (      v       ) '; cr.
        Transcript show: '                 [    Prison    ]'; cr; cr.
    ]

    moveTo: aDirection [
        | nextRoom |
        nextRoom := currentRoom getExit: aDirection.
        
        nextRoom ifNil: [
            Transcript show: 'Error: You cannot go in that direction.'; cr.
            ^false
        ].
        
        (nextRoom name = 'Vault') ifTrue: [
            (GameState current barrierOpen) ifFalse: [
                Transcript show: 'The Vault is protected by a magical barrier. You need a specific Incantation to pass this wall.'; cr.
                ^false
            ].
        ].
        
        (nextRoom name = 'Secret Tunnel') ifTrue: [
            (player findItemNamed: 'Rusty Key') ifNil: [
                Transcript show: 'The door to the Secret Tunnel is locked. You need a specific Rusty Key to open it.'; cr.
                ^false
            ].
        ].
        
        currentRoom := nextRoom.
        self printMap.
        currentRoom describe.
        ^true
    ]
    
    look [
        self printMap.
        currentRoom describe.
    ]
]
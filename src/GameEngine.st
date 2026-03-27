"The germ of a text adventure game
Marcin Szlenk 2024"

"Game class

Responsibilities:
* print/read outputs/inputs
* handle game loop
* main coordinator for World and Player

Collaborators:
* World, Player"

Object subclass: Game [
    | isGameOver player world |

    introductionText := #(
        'House of Hope - Prolog'
        ''
        'Mapa jest grafem polaczonych pokoi:'
        '- Foyer: Centralny punkt.'
        '- Banquet Hall: Na polnoc od Foyer. Zawiera jedzenie/mikstury.'
        '- Vault: Na polnoc od Banquet Hall. Chroniony bariera (wymaga przedmiotu incantation).'
        '- Prison: Na poludnie od Foyer. Chroniony krata (wymaga testu strength lub dexterity).'
        '- Garden: Na wschod od Banquet Hall. Zawiera Sphinx i Cambiona.'
        '- Secret Tunnel: Laczy Vault z Garden (wymaga rusty_key).'
        '- Kitchen / Servant Quarters / Boudoir: Lokacje poboczne z przedmiotami i NPC.'
        ''
    ).

    instructionsText := #(
        'Available commands are:'
        ''
        'go north/south/east/west -- Ruch pomiedzy lokacjami.'
        'look                     -- Opis aktualnego pokoju.'
        'inventory                -- Twoje przedmioty.'
        'instructions             -- Wyswietl instrukcje.'
        'quit                     -- Koniec gry.'
        'halt                     -- Debugger (halt).'
        ''
    ).
 
    Game class >> new [
        | g |
        g := super new.
        g init.
        ^g
    ]

    init [
        isGameOver := false.
        
        "Initialize Core components"
        player := Player new.
        world := World current. "Używamy instancji Singletona"
        world player: player.
    ]

    "Print strings from array in separate lines."
    printLines: anArray [
        anArray do: [ :string | Transcript show: string; cr ]
    ]

    printIntroduction [
       self printLines: introductionText.
    ]

    printInstructions [
        self printLines: instructionsText.
    ]

    readCommand [
        Transcript show: '> '.
        ^ FileStream stdin nextLine
    ]

    "Process movements"
    handleMove: command [
        | parts direction |
        parts := command subStrings: ' '.
        
        "Support both 'go north' and just 'north'"
        (parts size = 1) ifTrue: [ direction := parts at: 1 ].
        (parts size >= 2) ifTrue: [ direction := parts at: 2 ].
        
        world moveTo: direction.
        ^true
    ]
    
    isDirection: cmd [
        ^ #('north' 'south' 'east' 'west') includes: cmd
    ]

    "Process taking items"
    handleTake: command [
        | parts itemName item |
        parts := command subStrings: ' '.
        parts size < 2 ifTrue: [ Transcript show: 'Co chcesz podniesc? (np. take item)'; cr. ^false ].
        itemName := parts at: 2.
        
        item := world currentRoom findItemNamed: itemName.
        item ifNil: [ Transcript show: 'Nie widzisz tu przedmiotu: ', itemName; cr. ^false ].
        
        world currentRoom removeItem: item.
        player takeItem: item.
        Transcript show: 'Podniosles: ', itemName; cr.
        ^true
    ]

    "Process dropping items"
    handleDrop: command [
        | parts itemName item |
        parts := command subStrings: ' '.
        parts size < 2 ifTrue: [ Transcript show: 'Co chcesz upuscic? (np. drop item)'; cr. ^false ].
        itemName := parts at: 2.
        
        item := player dropItem: itemName.
        item ifNil: [ Transcript show: 'Nie masz w ekwipunku przedmiotu: ', itemName; cr. ^false ].
        
        world currentRoom addItem: item.
        Transcript show: 'Upusciles: ', itemName; cr.
        ^true
    ]

    "Run the game."
    run [
        | cmd isUnknown |

        self printIntroduction.
        self printInstructions.
        
        "Initial room description"
        world look.

        "Game loop."
        [isGameOver] whileFalse: [

            isUnknown := true.
            cmd := self readCommand.

            (cmd isNil) ifTrue: [ isGameOver := true. isUnknown := false ].

            (isUnknown and: [cmd = 'instructions']) ifTrue: [
                self printInstructions.
                isUnknown := false
            ].

            (isUnknown and: [cmd = 'quit']) ifTrue: [
                isGameOver := true.
                isUnknown := false
            ].

            (isUnknown and: [cmd = 'halt']) ifTrue: [
                self halt.
                isUnknown := false
            ].

            (isUnknown and: [cmd = 'look']) ifTrue: [
                world look.
                isUnknown := false
            ].

            (isUnknown and: [cmd = 'inventory']) ifTrue: [
                Transcript show: 'Ekwipunek: '.
                player inventory isEmpty 
                    ifTrue: [ Transcript show: '(pusty)' ]
                    ifFalse: [ player inventory do: [ :i | Transcript show: i name, ' ' ] ].
                Transcript cr.
                isUnknown := false
            ].

            (isUnknown and: [cmd isNil not and: [cmd startsWith: 'go ']]) ifTrue: [
                self handleMove: cmd.
                isUnknown := false
            ].
            
            (isUnknown and: [self isDirection: cmd]) ifTrue: [
                self handleMove: cmd.
                isUnknown := false
            ].

            (isUnknown and: [cmd isNil not and: [cmd startsWith: 'take ']]) ifTrue: [
                self handleTake: cmd.
                isUnknown := false
            ].

            (isUnknown and: [cmd isNil not and: [cmd startsWith: 'drop ']]) ifTrue: [
                self handleDrop: cmd.
                isUnknown := false
            ].
                
            isUnknown ifTrue: [
                self printLines: #('Nieznana komenda.' 'Dostepne kierunki: go north/south/east/west (lub tylko: north, etc.)' 'Akcje: take <item>, drop <item>, inventory, look, instructions, quit')
            ]
        ]
    ]
]

Game new run.

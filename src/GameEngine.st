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
    | isGameOver player world activeEnemy introductionText instructionsText |
 
    Game class >> new [
        | g |
        g := super new.
        g init.
        ^g
    ]

    init [
        isGameOver := false.
        
        introductionText := #(
            'House of Hope - Prolog'
            ''
            '--- ARCHITEKTURA SWIATA ---'
            'Foyer -> Banquet Hall -> Vault'
            '       |             |-> Garden'
            '       |-> Prison'
            ''
        ).

        instructionsText := #(
            'Available commands are:'
            ''
            'Nawigacja: go north, look'
            'Przedmioty: take, drop, examine, use, inventory'
            'Postac: stats'
            'Walka (tylko w starciu): attack, flee'
            'Systemowe: quit, halt'
            ''
        ).

        "Initialize Core components"
        player := Player new.
        world := World current.
        world player: player.
        world setupPlayerCompanions.
        activeEnemy := nil.
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
        Transcript show: (activeEnemy ifNil: [ '> ' ] ifNotNil: [ '[WALKA] > ' ]).
        ^ FileStream stdin nextLine
    ]

    "Combat Logic"
    enterCombat: aRoom [
        aRoom enemies isEmpty ifFalse: [
            activeEnemy := aRoom enemies asArray first.
            Transcript show: '!!! UWAGA !!! Z zostajesz zaatakowany przez: ', activeEnemy name; cr.
            Transcript show: activeEnemy description; cr.
            Transcript show: 'Uzyj: attack lub flee'; cr.
        ]
    ]

    handleEnemyTurn [
        | roll ac total dmg |
        activeEnemy ifNil: [ ^self ].
        
        roll := DiceRoller current d20.
        ac := 12 + (player calculateModifier: 'dexterity'). "Sekcja 2.A: AC=12+dex_mod"
        
        Transcript show: activeEnemy name, ' atakuje! (Rzut: ', roll printString, ' vs AC ', ac printString, ')'; cr.
        
        (roll >= ac) ifTrue: [
            dmg := DiceRoller current roll: 6. "Przeciwnik zadaje 1-6 dmg"
            player takeDamage: dmg.
            Transcript show: 'Zostajesz ranny! Otrzymujesz ', dmg printString, ' obrażeń (HP: ', player hp printString, ')'; cr.
            (player isAlive) ifFalse: [
                Transcript show: 'ZGINALES... House of Hope pochłonęło Twoją duszę.'; cr.
                isGameOver := true.
            ]
        ] ifFalse: [
            Transcript show: 'Uniknąłeś ataku!'; cr.
        ].
    ]

    handleAttack [
        | result roll damage |
        activeEnemy ifNil: [ Transcript show: 'Nie masz kogo zaatakować.'; cr. ^false ].
        
        "Sekcja 2.A: d20 + mod >= AC"
        result := player rollCheck: 'strength' against: activeEnemy armorClass.
        
        (result = #success or: [ result = #criticalSuccess ]) ifTrue: [
            damage := DiceRoller current roll: 8. "Dmg 1-8"
            (result = #criticalSuccess) ifTrue: [ damage := damage * 2 ].
            
            activeEnemy takeDamage: damage.
            Transcript show: 'Trafiasz! Zadajesz ', damage printString, ' obrażeń (Wróg HP: ', activeEnemy hp printString, ')'; cr.
            
            (activeEnemy isAlive) ifFalse: [
                Transcript show: 'PRZECIWNIK POKONANY!'; cr.
                world currentRoom enemies remove: activeEnemy.
                activeEnemy := nil.
                ^true
            ].
        ] ifFalse: [
            Transcript show: 'Chybiłeś!'; cr.
        ].
        
        self handleEnemyTurn.
        ^true
    ]

    handleFlee [
        Transcript show: 'Uciekasz w popłochu!'; cr.
        activeEnemy := nil.
        world moveTo: 'south'. "Safe direction"
        ^true
    ]

    "Process movements"
    handleMove: command [
        | parts direction |
        parts := command subStrings: ' '.
        (parts size = 1) ifTrue: [ direction := parts at: 1 ].
        (parts size >= 2) ifTrue: [ direction := parts at: 2 ].
        
        (world moveTo: direction) ifTrue: [
            self enterCombat: world currentRoom.
        ].
        ^true
    ]
    
    isDirection: cmd [
        ^ #('north' 'south' 'east' 'west') includes: cmd
    ]

    "Process taking items"
    handleTake: command [
        | parts itemName item |
        parts := command subStrings: ' '.
        parts size < 2 ifTrue: [ Transcript show: 'Co chcesz podniesc?'; cr. ^false ].
        itemName := parts at: 2.
        item := world currentRoom findItemNamed: itemName.
        item ifNil: [ Transcript show: 'Nie widzisz tu: ', itemName; cr. ^false ].
        world currentRoom removeItem: item.
        player takeItem: item.
        Transcript show: 'Podniosles: ', itemName; cr.
        ^true
    ]

    "Process dropping items"
    handleDrop: command [
        | parts itemName item |
        parts := command subStrings: ' '.
        parts size < 2 ifTrue: [ Transcript show: 'Co chcesz upuscic?'; cr. ^false ].
        itemName := parts at: 2.
        item := player dropItem: itemName.
        item ifNil: [ Transcript show: 'Nie masz tego.'; cr. ^false ].
        world currentRoom addItem: item. Transcript show: 'Upusciles: ', itemName; cr.
        ^true
    ]

    "Process examining items"
    handleExamine: command [
        | parts itemName item result |
        parts := command subStrings: ' '.
        parts size < 2 ifTrue: [ Transcript show: 'Co zbadac?'; cr. ^false ].
        itemName := parts at: 2.
        
        item := player findItemNamed: itemName.
        item ifNil: [ item := world currentRoom findItemNamed: itemName ].
        item ifNil: [ Transcript show: 'Nie widzisz produktu: ', itemName; cr. ^false ].
        
        Transcript show: item description; cr.
        result := player rollCheck: 'intelligence' against: 12.
        (result = #success or: [ result = #criticalSuccess ]) ifTrue: [
            Transcript show: '>> ', item hint; cr.
        ].
        ^true
    ]

    "Process using items"
    handleUse: command [
        | parts itemName item |
        parts := command subStrings: ' '.
        parts size < 2 ifTrue: [ Transcript show: 'Co uzyc?'; cr. ^false ].
        itemName := parts at: 2.
        item := player findItemNamed: itemName.
        item ifNil: [ Transcript show: 'Nie masz tego.'; cr. ^false ].
        
        "Incantation: opens Vault barrier"
        (item name sameAs: 'Incantation') ifTrue: [
            (world currentRoom name = 'Banquet Hall') ifTrue: [
                Transcript show: 'Bariera magiczna znika w blaskach ognia!'; cr.
                GameState current barrierOpen: true.
                player inventory remove: item. ^true
            ] ifFalse: [
                Transcript show: 'Tutaj inkantacja nie ma efektu.'; cr. ^false
            ]
        ].

        "Potion: restores 10 HP (Sekcja 1.C)"
        (item name sameAs: 'Potion') ifTrue: [
            player heal: 10.
            player inventory remove: item.
            Transcript show: 'Wypiłeś miksture! +10 HP. Obecne HP: ', player hp printString; cr.
            ^true
        ].
        
        Transcript show: 'Nie wiesz jak uzyc: ', itemName; cr.
        ^true
    ]

    "Process talking to NPCs - includes Sphinx riddle (Sekcja 7)"
    handleTalk: command [
        | parts npcName npc answer |
        parts := command subStrings: ' '.
        parts size < 2 ifTrue: [ Transcript show: 'Z kim porozmawiasz? (np. talk sphinx)'; cr. ^false ].
        npcName := parts at: 2.
        
        npc := world currentRoom findNpcNamed: npcName.
        npc ifNil: [ Transcript show: 'Nie ma tu nikogo o imieniu: ', npcName; cr. ^false ].
        
        Transcript show: npc name, ' mówi do ciebie: '; cr.
        Transcript show: npc description; cr.
        
        "Check if NPC has a riddle"
        npc riddle ifNotNil: [
            Transcript show: '--- ZAGADKA ---'; cr.
            Transcript show: npc riddle; cr.
            Transcript show: 'Twoja odpowiedz: '.
            answer := FileStream stdin nextLine.
            
            (answer sameAs: npc answer) ifTrue: [
                Transcript show: 'POPRAWNA ODPOWIEDZ!'; cr.
                Transcript show: 'Sphinx mowi: "Brawo! Oto moja wskazówka: uderz Orphic Hammer w kratach wiezienia, by uwolnic Hope."'; cr.
                GameState current riddleSolved: true.
            ] ifFalse: [
                Transcript show: 'ZLA ODPOWIEDZ! Sphinx atakuje! -5 HP.'; cr.
                player takeDamage: 5.
                Transcript show: 'HP gracza: ', player hp printString; cr.
                (player isAlive) ifFalse: [
                    Transcript show: 'Zginales z rak Sphinksa.'; cr.
                    isGameOver := true.
                ]
            ].
        ].
        ^true
    ]

    "Run the game."
    run [
        | cmd isUnknown |

        self printIntroduction.
        self printInstructions.
        world look.

        "Game loop."
        [isGameOver] whileFalse: [
            cmd := self readCommand.
            (cmd isNil) ifTrue: [ ^self ].
            isUnknown := true.

            "Normal / Combat Dispatch"
            activeEnemy ifNil: [
                (cmd = 'instructions') ifTrue: [ self printInstructions. isUnknown := false ].
                (isUnknown and: [cmd = 'quit']) ifTrue: [ isGameOver := true. isUnknown := false ].
                (isUnknown and: [cmd = 'halt']) ifTrue: [ self halt. isUnknown := false ].
                (isUnknown and: [cmd = 'look']) ifTrue: [ world look. isUnknown := false ].
                (isUnknown and: [cmd = 'stats']) ifTrue: [ player displayStats. isUnknown := false ].

                (isUnknown and: [cmd = 'companions']) ifTrue: [
                    Transcript show: 'Twoja druzyna: '.
                    player companions isEmpty
                        ifTrue: [ Transcript show: '(brak)' ]
                        ifFalse: [ player companions do: [ :c | Transcript show: c name, '(+', c bonusValue printString, ' ', c boostedStat, ') ' ] ].
                    Transcript cr.
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

                (isUnknown and: [cmd startsWith: 'go ']) ifTrue: [ self handleMove: cmd. isUnknown := false ].
                (isUnknown and: [self isDirection: cmd]) ifTrue: [ self handleMove: cmd. isUnknown := false ].
                (isUnknown and: [cmd startsWith: 'take ']) ifTrue: [ self handleTake: cmd. isUnknown := false ].
                (isUnknown and: [cmd startsWith: 'drop ']) ifTrue: [ self handleDrop: cmd. isUnknown := false ].
                (isUnknown and: [cmd startsWith: 'examine ']) ifTrue: [ self handleExamine: cmd. isUnknown := false ].
                (isUnknown and: [cmd startsWith: 'use ']) ifTrue: [ self handleUse: cmd. isUnknown := false ].
                (isUnknown and: [cmd startsWith: 'talk ']) ifTrue: [ self handleTalk: cmd. isUnknown := false ].
            ] ifNotNil: [
                (cmd = 'attack') ifTrue: [ self handleAttack. isUnknown := false ].
                (isUnknown and: [cmd = 'flee']) ifTrue: [ self handleFlee. isUnknown := false ].
                (isUnknown and: [cmd = 'stats']) ifTrue: [ player displayStats. isUnknown := false ].
            ].
                
            isUnknown ifTrue: [ Transcript show: 'Nieznana komenda.'; cr ].
        ]
    ]
]

Game new run.

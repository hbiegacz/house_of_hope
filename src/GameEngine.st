"GameEngine class
Responsibilities:
* handle game loop
* character creation and recruitment
* command parser
* main coordinator for World and Player"

Object subclass: GameEngine [
    | isGameOver player world activeEnemy introductionText instructionsText combatTurn |
 
    GameEngine class >> new [
        | g |
        g := super new.
        g initGame.
        ^g
    ]

    initGame [
        isGameOver := false.
        
        introductionText := #(
            '--- HOUSE OF HOPE ---'
            'Welcome to hell, mortal. Your task is to reclaim'
            'your soul contract from the hands of Raphael.'
            ''
        ).

        instructionsText := #(
            ''
            'Available commands:'
            '  go [direction]  - north, south, east, west (Example: go north)'
            '  look            - describe room and exits'
            '  search          - search for items in the room'
            '  take [item]     - pick up an item (Example: take rusty key)'
            '  inventory       - your equipment'
            '  examine [item]  - investigate an item (Example: examine hammer)'
            '  use [item]      - use an item (Example: use potion)'
            '  talk [npc]      - talk to an NPC (Example: talk sphinx)'
            '  stats           - your current statistics'
            '  attack / flee   - combat commands'
            '  help            - display this help'
            '  quit            - exit the game'
            ''
        ).

        player := Player new.
        world := World current.
        world player: player.
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
        Transcript cr.
        self printLines: instructionsText.
    ]

    readCommand [
        activeEnemy ifNotNil: [ Transcript cr; show: '--- TURN ', combatTurn printString, ' ---'; cr ].
        activeEnemy ifNil: [ 
            Transcript show: '> (Examples: look, go north/south, search, examine item, take item, use item, stats, help, quit) ' 
        ] ifNotNil: [ 
            Transcript show: 'Choose: attack. | flee. | drink_potion. | help. (Example: attack)'; cr.
            Transcript show: '[COMBAT] > '
        ].
        ^ FileStream stdin nextLine
    ]

    "Character Creation"
    characterCreation [
        | points choice statsLine |
        points := 5.
        Transcript show: '*** STEP 1: DEFINE YOUR HERO ***'; cr; cr.
        
        [ points > 0 ] whileTrue: [
            Transcript show: '--- CHARACTER DEVELOPMENT ---'; cr.
            "Format: [STR: 10 | DEX: 10 | INT: 10 | CHA: 10 | END: 10]"
            statsLine := '[STR: ', (player stats at: 'strength') printString, 
                         ' | DEX: ', (player stats at: 'dexterity') printString,
                         ' | INT: ', (player stats at: 'intelligence') printString,
                         ' | CHA: ', (player stats at: 'charisma') printString,
                         ' | END: ', (player stats at: 'endurance') printString, ']'.
            Transcript show: statsLine; cr.
            Transcript show: 'Points remaining: ', points printString; cr.
            Transcript show: 'Choose a stat to increase (strength. dexterity. intelligence. charisma. endurance.): '; cr.
            choice := FileStream stdin nextLine asLowercase.
            "Clean trailing dot"
            (choice endsWith: '.') ifTrue: [ choice := choice copyFrom: 1 to: (choice size - 1) ].
            
            ((choice = 'strength') or: [ choice = 'str' ]) ifTrue: [ 
                player increaseStat: 'strength'. points := points - 1. 
                Transcript show: '>> Your strength increased to ', (player stats at: 'strength') printString, '!'; cr; cr.
            ].
            ((choice = 'dexterity') or: [ choice = 'dex' ]) ifTrue: [ 
                player increaseStat: 'dexterity'. points := points - 1. 
                Transcript show: '>> Your dexterity increased to ', (player stats at: 'dexterity') printString, '!'; cr; cr.
            ].
            ((choice = 'intelligence') or: [ choice = 'int' ]) ifTrue: [ 
                player increaseStat: 'intelligence'. points := points - 1. 
                Transcript show: '>> Your intelligence increased to ', (player stats at: 'intelligence') printString, '!'; cr; cr.
            ].
            ((choice = 'charisma') or: [ choice = 'cha' ]) ifTrue: [ 
                player increaseStat: 'charisma'. points := points - 1. 
                Transcript show: '>> Your charisma increased to ', (player stats at: 'charisma') printString, '!'; cr; cr.
            ].
            ((choice = 'endurance') or: [ choice = 'end' ]) ifTrue: [ 
                player increaseStat: 'endurance'. points := points - 1. 
                Transcript show: '>> Your endurance increased to ', (player stats at: 'endurance') printString, '!'; cr; cr.
            ].
        ].
        Transcript show: '*** Your attributes are forged! ***'; cr.
        statsLine := '[STR: ', (player stats at: 'strength') printString, 
                     ' | DEX: ', (player stats at: 'dexterity') printString,
                     ' | INT: ', (player stats at: 'intelligence') printString,
                     ' | CHA: ', (player stats at: 'charisma') printString,
                     ' | END: ', (player stats at: 'endurance') printString, ']'.
        Transcript show: statsLine; cr; cr.
    ]

    "Recruitment"
    recruitment [
        | count choice comps key |
        count := 3.
        comps := Dictionary new.
        comps at: 'astarion' put: (Companion name: 'astarion' stat: 'dexterity' value: 5).
        comps at: 'gale' put: (Companion name: 'gale' stat: 'intelligence' value: 4).
        comps at: 'laezel' put: (Companion name: 'laezel' stat: 'strength' value: 3).
        comps at: 'shadowheart' put: (Companion name: 'shadowheart' stat: 'endurance' value: 4).
        comps at: 'wyll' put: (Companion name: 'wyll' stat: 'charisma' value: 3).

        Transcript show: '*** STEP 2: ASSEMBLE YOUR PARTY ***'; cr; cr.

        [ count > 0 ] whileTrue: [
            Transcript show: 'Recruiting for slot #', count printString, ':'; cr.
            Transcript show: '--- AVAILABLE COMPANIONS ---'; cr.
            comps keysAndValuesDo: [ :name :val | 
                Transcript show: '- ', name, ': Provides +', val bonusValue printString, ' bonus to ', val boostedStat, ' checks.'; cr.
            ].
            Transcript cr.
            Transcript show: 'Type the name of the companion (e.g., astarion.): '; cr.
            choice := FileStream stdin nextLine asLowercase.
            "Clean trailing dot"
            (choice endsWith: '.') ifTrue: [ choice := choice copyFrom: 1 to: (choice size - 1) ].
            
            (comps includesKey: choice) ifTrue: [
                player companions add: (comps at: choice).
                comps removeKey: choice.
                Transcript show: '>> SUCCESS: ', choice, ' has joined! (+', (player companions last bonusValue printString), ' to ', player companions last boostedStat, ')'; cr; cr.
                count := count - 1.
            ] ifFalse: [
                Transcript show: 'Error: That hero is not available or does not exist.'; cr; cr.
            ].
        ].
        Transcript show: '*** Your party is complete and ready for the House of Hope! ***'; cr; cr.
        Transcript show: 'Your journey begins now...'; cr; cr.
    ]

    "Combat Logic"
    enterCombat: aRoom [
        aRoom enemies isEmpty ifFalse: [
            activeEnemy := aRoom enemies asArray first.
            combatTurn := 1.
            Transcript cr; show: '!!! WARNING !!!'; cr.
            Transcript show: 'A wild ', activeEnemy name, ' appears in the ', aRoom name asLowercase, '!'; cr; cr.
            Transcript show: '!!! INITIATIVE !!!'; cr.
            Transcript show: 'You are fighting: ', activeEnemy name; cr.
            Transcript show: activeEnemy description; cr.
        ]
    ]

    handleEnemyTurn [
        | roll ac total dmg reduction |
        activeEnemy ifNil: [ ^self ].
        
        roll := DiceRoller current d20.
        ac := 12 + (player calculateModifier: 'dexterity').
        
        Transcript show: activeEnemy name, ' attacks! (Roll: ', roll printString, ' vs AC ', ac printString, ')'; cr.
        
        (roll >= ac) ifTrue: [
            dmg := DiceRoller current roll: 6.
            reduction := player calculateModifier: 'endurance'.
            dmg := (dmg - reduction) max: 1.
            player takeDamage: dmg.
            Transcript show: 'You take ', dmg printString, ' damage (HP: ', player hp printString, ')'; cr.
            (player isAlive) ifFalse: [
                Transcript show: 'YOU DIED... The House of Hope has claimed your soul.'; cr.
                isGameOver := true.
                ^self
            ]
        ] ifFalse: [
            Transcript show: 'You avoided the attack!'; cr.
        ].

        "Hope Heals (Moved to after enemy attack to avoid 'always 29 HP' confusion)"
        (GameState current hopeFree) ifTrue: [
            dmg := DiceRoller current roll: 6. dmg := dmg + 2. "3-8 HP"
            player heal: dmg.
            Transcript show: 'Hope healed you for ', dmg printString, ' HP! (HP: ', player hp printString, ')'; cr.
        ].
    ]

    handleAttack [
        | result damage |
        activeEnemy ifNil: [ ^false ].
        result := player rollCheck: 'strength' against: activeEnemy armorClass.
        
        (result = #success or: [ result = #criticalSuccess ]) ifTrue: [
            damage := DiceRoller current roll: 8.
            (result = #criticalSuccess) ifTrue: [ damage := damage * 2 ].
            activeEnemy takeDamage: damage.
            Transcript cr; show: 'Hit! You deal ', damage printString, ' damage (Enemy HP: ', activeEnemy hp printString, ')'; cr.
            (activeEnemy isAlive) ifFalse: [
                Transcript show: 'ENEMY DEFEATED!'; cr.
                world currentRoom enemies remove: activeEnemy.
                activeEnemy := nil.
                ^true
            ].
        ] ifFalse: [ Transcript show: 'You missed!'; cr ].
        
        self handleEnemyTurn.
        combatTurn := combatTurn + 1.
        ^true
    ]

    handleCombatUsePotion [
        | potion |
        potion := player findItemNamed: 'Potion'.
        potion ifNil: [ 
            Transcript show: 'You don''t have any potions left!'; cr.
            ^false
        ].
        
        player heal: 10.
        player inventory remove: potion.
        Transcript show: 'You drink a potion... +10 HP (HP: ', player hp printString, ')'; cr.
        
        self handleEnemyTurn.
        combatTurn := combatTurn + 1.
        ^true
    ]

    handleFlee [
        Transcript show: 'You flee back!'; cr.
        activeEnemy := nil.
        world moveTo: 'south'.
        ^true
    ]

    handleSearch [
        | items |
        items := world currentRoom items.
        Transcript cr.
        items isEmpty ifTrue: [ Transcript show: 'You found nothing of interest.'; cr ]
        ifFalse: [
            Transcript show: 'You found: '; cr.
            items do: [ :i | Transcript show: '- ', i name; cr ].
        ].
        ^true
    ]

    handleUse: itemName [
        | item |
        item := player findItemNamed: itemName.
        item ifNil: [ Transcript show: 'You do not have that in your inventory.'; cr. ^false ].
        
        (item name sameAs: 'Potion') ifTrue: [
            player heal: 10.
            player inventory remove: item.
            Transcript show: 'You drank the potion. +10 HP.'; cr. ^true
        ].

        (item name sameAs: 'Incantation') ifTrue: [
            (world currentRoom name = 'Banquet Hall') ifTrue: [
                Transcript show: 'The Vault barrier disappears!'; cr.
                GameState current barrierOpen: true.
                player inventory remove: item. ^true
            ] ifFalse: [ Transcript show: 'Nothing happens.'; cr. ^false ].
        ].

        (item name sameAs: 'Orphic Hammer') ifTrue: [
            (world currentRoom name = 'Prison') ifTrue: [
                Transcript show: 'A MIGHTY BLOW! The chains shatter. Hope is free!'; cr.
                GameState current hopeFree: true. ^true
            ] ifFalse: [ Transcript show: 'There is no one here to free.'; cr. ^false ].
        ].

        Transcript show: 'You do not know how to use this.'; cr.
        ^true
    ]

    handleTalk: npcName [
        | npc answer |
        npc := world currentRoom findNpcNamed: npcName.
        npc ifNil: [ Transcript show: 'No one here by that name.'; cr. ^false ].
        
        Transcript show: npc name, ': ', npc description; cr.

        (npc name sameAs: 'Collector') ifTrue: [
            (player findItemNamed: 'Old Coin') ifNotNil: [
                Transcript show: 'Collector: "Ah! That coin! In exchange, I tell you: The Rusty Key lies in the Kitchen!"'; cr.
                ^true
            ].
        ].

        npc riddle ifNotNil: [
            Transcript show: 'RIDDLE: ', npc riddle; cr.
            Transcript show: 'Your answer (Example: promise): '.
            answer := FileStream stdin nextLine asLowercase.
            (answer sameAs: npc answer) ifTrue: [
                Transcript show: 'Correct!'; cr.
                (npc name sameAs: 'Sphinx') ifTrue: [ Transcript show: 'Sphinx: "Use the hammer to free Hope."'; cr ].
            ] ifFalse: [
                Transcript show: 'Wrong! The Sphinx strikes you!'; cr.
                player takeDamage: 5.
            ].
        ].
        ^true
    ]

    run [
        | cmd parts action target cleanCmd |
        self characterCreation.
        self recruitment.
        self printInstructions.
        world look.

        [ isGameOver ] whileFalse: [
            cmd := self readCommand.
            cmd ifNil: [ isGameOver := true ] ifNotNil: [
                cleanCmd := cmd.
                parts := cleanCmd subStrings.
                parts isEmpty ifTrue: [ action := ''. target := nil ] ifFalse: [
                    "Check for parentheses"
                    (cleanCmd includes: $() ifTrue: [
                        | openIdx closeIdx |
                        openIdx := cleanCmd indexOf: $(.
                        closeIdx := cleanCmd indexOf: $).
                        closeIdx = 0 ifTrue: [ closeIdx := cleanCmd size + 1 ].
                        action := (cleanCmd copyFrom: 1 to: (openIdx - 1)) asLowercase.
                        target := (cleanCmd copyFrom: (openIdx + 1) to: (closeIdx - 1)) asLowercase.
                        "Remove trailing dot from target"
                        (target endsWith: '.') ifTrue: [ target := target copyFrom: 1 to: (target size - 1) ].
                    ] ifFalse: [
                        action := parts first asLowercase.
                        (action endsWith: '.') ifTrue: [ action := action copyFrom: 1 to: (action size - 1) ].
                        parts size > 1 ifTrue: [
                            target := ''.
                            2 to: parts size do: [ :i |
                                target := target, (parts at: i).
                                (i < parts size) ifTrue: [ target := target, ' ' ].
                            ].
                            target := target asLowercase.
                            (target endsWith: '.') ifTrue: [ target := target copyFrom: 1 to: (target size - 1) ].
                        ] ifFalse: [ target := nil ].
                    ].
                ].
                
                activeEnemy ifNil: [
                    (action = 'quit') ifTrue: [ isGameOver := true ].
                    (action = 'help') ifTrue: [ self printInstructions ].
                    (action = 'look') ifTrue: [ Transcript cr. world look ].
                    (action = 'stats') ifTrue: [ player displayStats ].
                    (action = 'search') ifTrue: [ self handleSearch ].
                    (action = 'inventory') ifTrue: [
                        Transcript cr; show: '--- YOUR INVENTORY ---'; cr.
                        Transcript show: 'You are carrying:'; cr.
                        player inventory do: [ :i | Transcript show: '* ', i name; cr ].
                        Transcript cr.
                        Transcript show: 'Commands: use [item]. examine [item]. drop [item].'; cr.
                    ].
                    (action = 'go') ifTrue: [
                        target ifNotNil: [
                            (world moveTo: target) ifTrue: [
                                (world currentRoom name = 'Foyer' and: [ GameState current contractTaken ]) ifTrue: [
                                    world currentRoom enemies add: (Enemy name: 'Raphael' hp: 100 maxHp: 100 ac: 16 dc: 15 description: 'The lord of this house. He is furious.').
                                ].
                                self enterCombat: world currentRoom.
                            ].
                        ] ifNil: [ Transcript show: 'Where to?'; cr ].
                    ].
                    (action = 'take') ifTrue: [
                        target ifNotNil: [
                            (world currentRoom findItemNamed: target) ifNotNil: [ :item |
                                player takeItem: item. world currentRoom removeItem: item.
                                Transcript show: 'You took: ', item name; cr.
                                (item name sameAs: 'Soul Contract') ifTrue: [ GameState current contractTaken: true. Transcript show: '*** YOU FEEL RAPHAEL''S GROWING ANGER ***'; cr ].
                            ] ifNil: [ Transcript show: 'You do not see that here.'; cr ].
                        ] ifNil: [ Transcript show: 'What do you want to take?'; cr ].
                    ].
                    (action = 'examine') ifTrue: [
                        target ifNotNil: [
                            (player findItemNamed: target) ifNotNil: [ :item |
                                Transcript show: item description; cr.
                                (player rollCheck: 'intelligence' against: 12) = #success ifTrue: [ 
                                    (item hint notNil and: [ item hint isEmpty not ]) ifTrue: [ 
                                        Transcript show: 'Hint: ', item hint; cr 
                                    ] ifFalse: [ 
                                        Transcript show: 'You don''t find any hidden clues about this item.'; cr 
                                    ].
                                ].
                            ] ifNil: [ Transcript show: 'You do not have that.'; cr ].
                        ] ifNil: [ Transcript show: 'What do you want to examine?'; cr ].
                    ].
                    (action = 'use') ifTrue: [ target ifNotNil: [ self handleUse: target ] ifNil: [ Transcript show: 'What do you want to use?'; cr ] ].
                    (action = 'talk') ifTrue: [ target ifNotNil: [ self handleTalk: target ] ifNil: [ Transcript show: 'Who do you want to talk to?'; cr ] ].
                ] ifNotNil: [
                    ((action = 'attack') or: [ cleanCmd sameAs: 'attack' ]) ifTrue: [ self handleAttack ].
                    ((action = 'flee') or: [ cleanCmd sameAs: 'flee' ]) ifTrue: [ self handleFlee ].
                    ((action = 'help') or: [ cleanCmd sameAs: 'help' ]) ifTrue: [ self printInstructions ].
                    ((action = 'drink_potion') or: [ (action = 'drinkpotion') or: [ (cleanCmd sameAs: 'drink potion') or: [ cleanCmd sameAs: 'use potion' ] ] ]) ifTrue: [ self handleCombatUsePotion ].
                ].
            ].
        ].
        Transcript cr; show: 'Thanks for playing!'; cr.
    ]
]

GameEngine new run.

"String extension for cleaning up input."
String extend [
    trim [
        | start end |
        start := 1.
        [ start <= self size and: [ (self at: start) isSeparator ] ] whileTrue: [ start := start + 1 ].
        end := self size.
        [ end >= start and: [ (self at: end) isSeparator ] ] whileTrue: [ end := end - 1 ].
        ^ (start > end) ifTrue: [ '' ] ifFalse: [ self copyFrom: start to: end ]
    ]
]

"GameEngine class
Responsibilities:
* handle game loop
* character creation and recruitment
* command parser
* main coordinator for World and Player"

Object subclass: GameEngine [
    | isGameOver player world activeEnemy introductionText instructionsText combatTurn commandMap |

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
            '  go [direction]  - north, south, east, west'
            '  look            - describe room and exits'
            '  search          - search for items in the room'
            '  take [item]     - pick up an item'
            '  inventory       - your equipment'
            '  examine [item]  - investigate an item'
            '  use [item]      - use an item'
            '  talk [npc]      - talk to an NPC'
            '  stats           - your current statistics'
            '  help            - display this help'
            '  quit            - exit the game'
            ''
            'Combat Actions:'
            '  attack          - standard physical attack (Strength)'
            '  sneak           - escape quietly on Turn 1 (Dexterity, DC 14)'
            '  flee            - run away mid-fight from Turn 2 (Dexterity, DC 17)'
            '  drink_potion    - heal 10 HP'
            ''
        ).

        player := Player new.
        world := World current.
        world player: player.
        activeEnemy := nil.
        self setupCommandMap.
    ]

    setupCommandMap [
        commandMap := Dictionary new.
        commandMap at: 'quit' put: [ isGameOver := true ].
        commandMap at: 'help' put: [ self printInstructions ].
        commandMap at: 'look' put: [ world look ].
        commandMap at: 'stats' put: [ player displayStats ].
        commandMap at: 'search' put: [ self handleSearch ].
        commandMap at: 'inventory' put: [ self handleInventory ].
        commandMap at: 'go' put: [ :target | self handleGo: target ].
        commandMap at: 'take' put: [ :target | self handleTake: target ].
        commandMap at: 'examine' put: [ :target | self handleExamine: target ].
        commandMap at: 'use' put: [ :target | self handleUse: target ].
        commandMap at: 'talk' put: [ :target | self handleTalk: target ].
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
        | line prompt |
        activeEnemy ifNotNil: [ Transcript cr; show: '--- TURN ', combatTurn printString, ' ---'; cr ].
        activeEnemy ifNil: [ 
            prompt := '> (look, go [dir], search, examine [item], take [item], use [item], stats, help, quit) '.
        ] ifNotNil: [ 
            (combatTurn = 1) ifTrue: [
                prompt := 'Choose: attack | sneak | drink_potion | help. [COMBAT T1] > '.
            ] ifFalse: [
                prompt := 'Choose: attack | flee | drink_potion | help. [COMBAT T', combatTurn printString, '] > '.
            ].
        ].
        Transcript show: prompt.
        line := FileStream stdin nextLine.
        line ifNil: [ isGameOver := true. ^'quit' ].
        ^ line
    ]

    "Character Creation"
    characterCreation [
        | points choice mapping |
        points := 5.
        mapping := Dictionary new.
        #('strength' 'str') do: [ :s | mapping at: s put: 'strength' ].
        #('dexterity' 'dex') do: [ :s | mapping at: s put: 'dexterity' ].
        #('intelligence' 'int') do: [ :s | mapping at: s put: 'intelligence' ].
        #('charisma' 'cha') do: [ :s | mapping at: s put: 'charisma' ].
        #('endurance' 'end') do: [ :s | mapping at: s put: 'endurance' ].

        Transcript show: '*** STEP 1: DEFINE YOUR HERO ***'; cr; cr.
        
        [ points > 0 and: [ isGameOver not ] ] whileTrue: [
            Transcript show: '--- CHARACTER DEVELOPMENT ---'; cr.
            Transcript show: '[STR: ', (player stats at: 'strength') printString, 
                         ' | DEX: ', (player stats at: 'dexterity') printString,
                         ' | INT: ', (player stats at: 'intelligence') printString,
                         ' | CHA: ', (player stats at: 'charisma') printString,
                         ' | END: ', (player stats at: 'endurance') printString, ']'; cr.
            Transcript show: 'Points remaining: ', points printString; cr.
            Transcript show: 'Choose a stat to increase (strength, dexterity, intelligence, charisma, endurance): '.
            
            choice := self normalize: FileStream stdin nextLine.
            (choice sameAs: 'quit') ifTrue: [ isGameOver := true. ^self ].
            isGameOver ifTrue: [ ^self ].

            (mapping includesKey: choice) ifTrue: [
                | stat |
                stat := mapping at: choice.
                player increaseStat: stat.
                points := points - 1.
                Transcript show: '>> Your ', stat, ' increased to ', (player stats at: stat) printString, '!'; cr; cr.
            ] ifFalse: [
                (choice isEmpty) ifFalse: [
                    Transcript show: 'Error: Attribute "', choice, '" not recognized. Please try again.'; cr; cr.
                ].
            ].
        ].
        Transcript show: '*** Your attributes are forged! ***'; cr; cr.
    ]

    "Recruitment"
    recruitment [
        | count choice comps |
        count := 3.
        comps := Dictionary new.
        comps at: 'astarion' put: (Companion name: 'astarion' stat: 'dexterity' value: 5).
        comps at: 'gale' put: (Companion name: 'gale' stat: 'intelligence' value: 4).
        comps at: 'laezel' put: (Companion name: 'laezel' stat: 'strength' value: 3).
        comps at: 'shadowheart' put: (Companion name: 'shadowheart' stat: 'endurance' value: 4).
        comps at: 'wyll' put: (Companion name: 'wyll' stat: 'charisma' value: 3).

        Transcript show: '*** STEP 2: ASSEMBLE YOUR PARTY ***'; cr; cr.

        [ count > 0 and: [ isGameOver not ] ] whileTrue: [
            Transcript show: 'Recruiting for slot #', count printString, ':'; cr.
            Transcript show: '--- AVAILABLE COMPANIONS ---'; cr.
            comps keysAndValuesDo: [ :name :val | 
                Transcript show: '- ', name, ': Provides +', val bonusValue printString, ' bonus to ', val boostedStat, ' checks.'; cr.
            ].
            Transcript cr; show: 'Type the name of the companion (e.g., astarion): '.
            
            choice := self normalize: FileStream stdin nextLine.
            (choice sameAs: 'quit') ifTrue: [ isGameOver := true. ^self ].
            isGameOver ifTrue: [ ^self ].
            
            (comps includesKey: choice) ifTrue: [
                player companions add: (comps at: choice).
                comps removeKey: choice.
                Transcript show: '>> SUCCESS: ', choice, ' has joined!'; cr; cr.
                count := count - 1.
            ] ifFalse: [
                (choice isEmpty) ifFalse: [
                    Transcript show: 'Error: Companion "', choice, '" is not available.'; cr; cr.
                ].
            ].
        ].
        Transcript show: '*** Your party is complete and ready for the House of Hope! ***'; cr; cr.
    ]

    "Combat Logic"
    enterCombat: aRoom [
        aRoom enemies isEmpty ifFalse: [
            activeEnemy := aRoom enemies asArray first.
            combatTurn := 1.
            Transcript cr; show: '!!! WARNING !!! (Roll: d20 vs AC)'; cr.
            Transcript show: 'A wild ', activeEnemy name, ' appears in the ', aRoom name asLowercase, '!'; cr; cr.
            Transcript show: 'You are fighting: ', activeEnemy name; cr.
            Transcript show: activeEnemy description; cr.
        ]
    ]

    handleEnemyTurn [
        | roll ac dmg enemyHeader |
        activeEnemy ifNil: [ ^self ].
        
        roll := DiceRoller current d20.
        ac := 12 + (player calculateModifier: 'dexterity').
        
        enemyHeader := '--- ', activeEnemy name asUppercase, ' ATTACKS ---'.
        Transcript cr; show: enemyHeader; cr.
        
        (roll = 20) ifTrue: [ Transcript show: 'CRITICAL HIT!'; cr. ].

        (roll >= ac or: [ roll = 20 ]) ifTrue: [
            | baseDmg bonus |
            (roll = 20) ifTrue: [ 
                baseDmg := (DiceRoller current roll: 3 to: 8) * 2.
            ] ifFalse: [
                baseDmg := DiceRoller current roll: 3 to: 8.
            ].
            bonus := player calculateModifier: 'endurance'.
            dmg := (baseDmg - bonus) max: 1.
            
            player takeDamage: dmg.
            Transcript show: 'Took ', dmg printString, ' dmg (Endurance saved: ', bonus printString, '). HP: ', player hp printString; cr.
            (player isAlive) ifFalse: [
                Transcript show: 'YOU DIED... The House of Hope has claimed your soul.'; cr.
                isGameOver := true.
            ]
        ] ifFalse: [ Transcript show: 'You avoided the attack!'; cr ].

        (GameState current hopeFree) ifTrue: [
            dmg := (DiceRoller current roll: 3 to: 8).
            player heal: dmg.
            Transcript cr; show: 'Hope prays for you! Divine light heals you for ', dmg printString, ' HP. ', player hpDisplay; cr.
        ].
    ]

    handleSneak [
        Transcript show: 'You try to slip away before the fight starts...'; cr.
        ((player rollCheck: 'dexterity' against: 14) = #success) ifTrue: [
            Transcript show: 'Success! You escaped the ', activeEnemy name; cr.
            activeEnemy := nil.
            world fleeBack.
            ^true
        ].
        Transcript show: 'The enemy heard you! Combat begins!'; cr.
        self handleEnemyTurn.
        combatTurn := combatTurn + 1.
        ^true
    ]

    handleAttack [
        | result damage |
        activeEnemy ifNil: [ ^false ].
        result := player rollCheck: 'strength' against: activeEnemy armorClass.
        
        (result = #success or: [ result = #criticalSuccess ]) ifTrue: [
            (result = #criticalSuccess) ifTrue: [ 
                damage := (player stats at: 'strength').
            ] ifFalse: [
                damage := DiceRoller current roll: 8.
            ].
            activeEnemy takeDamage: damage.
            
            (result = #criticalSuccess) ifTrue: [ 
                Transcript cr; show: '*** CRITICAL HIT! *** ', damage printString, ' dmg! (Enemy HP: ', activeEnemy hp printString, ')'; cr.
            ] ifFalse: [
                Transcript cr; show: 'HIT! ', damage printString, ' dmg. (Enemy HP: ', activeEnemy hp printString, ')'; cr.
            ].
            (activeEnemy isAlive) ifFalse: [
                (activeEnemy name sameAs: 'Raphael') ifTrue: [
                    Transcript cr.
                    Transcript show: 'Raphael falls to his knees, his golden armor shattered.'; cr.
                    Transcript show: 'Hope appears by your side, her light blinding the devil.'; cr.
                    Transcript show: 'Hope: "Begone, Raphael! This house is no longer your prison!"'; cr.
                    Transcript show: 'Together, you cast him out into the void.'; cr.
                    Transcript show: '*** YOU HAVE WON THE GAME ***'; cr.
                    isGameOver := true.
                ] ifFalse: [
                    Transcript show: 'ENEMY DEFEATED!'; cr.
                    world currentRoom enemies remove: activeEnemy.
                ].
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
        potion ifNil: [ Transcript show: 'No potions left!'; cr. ^false ].
        
        player heal: 10.
        player inventory remove: potion.
        Transcript show: 'You drink a potion... +10 HP ', player hpDisplay; cr.
        
        self handleEnemyTurn.
        combatTurn := combatTurn + 1.
        ^true
    ]

    handleFlee [
        Transcript show: 'You desperately try to break away from the fight!'; cr.
        ((player rollCheck: 'dexterity' against: 17) = #success) ifTrue: [
            Transcript show: 'You managed to run away!'; cr.
            activeEnemy := nil.
            world fleeBack.
            ^true
        ].
        Transcript show: 'The enemy blocks your path! You are stuck!'; cr.
        self handleEnemyTurn.
        combatTurn := combatTurn + 1.
        ^true
    ]

    handleInventory [
        Transcript cr; show: '--- YOUR INVENTORY ---'; cr.
        Transcript show: 'Items:'; cr.
        player inventory do: [ :i | Transcript show: '* ', i name; cr ].
        Transcript cr; show: 'Commands: use [item], examine [item], drop [item].'; cr.
    ]

    handleSearch [
        | items |
        items := world currentRoom items.
        Transcript cr.
        items isEmpty ifTrue: [ Transcript show: 'Nothing found here.'; cr ]
        ifFalse: [
            Transcript show: '>> You found the following items. Use "take [item]" to pick them up.'; cr.
            items do: [ :i | Transcript show: '- ', i name, ': ', i description; cr ].
        ].
        ^true
    ]

    handleGo: direction [
        direction ifNil: [ Transcript show: 'Go where? (Examples: go north, go south)'; cr. ^false ].
        (world moveTo: direction) ifTrue: [
            (world currentRoom name = 'Foyer' and: [ GameState current contractTaken ]) ifTrue: [
                world currentRoom enemies add: (Enemy name: 'Raphael' hp: 100 maxHp: 100 ac: 16 dc: 15 description: 'The lord of this house.').
            ].
            self enterCombat: world currentRoom.
        ].
    ]

    handleTake: itemName [
        itemName ifNil: [ Transcript show: 'Take what?'; cr. ^false ].
        (world currentRoom findItemNamed: itemName) ifNotNil: [ :item |
            player takeItem: item.
            world currentRoom removeItem: item.
            Transcript show: 'You took: ', item name; cr.
            (item name sameAs: 'Soul Contract') ifTrue: [ 
                GameState current contractTaken: true. 
                Transcript show: '*** YOU FEEL RAPHAEL''S GROWING ANGER ***'; cr 
            ].
        ] ifNil: [ Transcript show: 'Item "', itemName, '" not found here.'; cr ].
    ]

    handleExamine: itemName [
        itemName ifNil: [ Transcript show: 'Examine what?'; cr. ^false ].
        (player findItemNamed: itemName) ifNotNil: [ :item |
            Transcript show: item description; cr.
            (player rollCheck: 'intelligence' against: 12) = #success ifTrue: [ 
                (item hint notNil and: [ item hint isEmpty not ]) ifTrue: [ Transcript show: 'Hint: ', item hint; cr ].
            ].
        ] ifNil: [ Transcript show: 'You don''t have "', itemName, '".'; cr ].
    ]

    handleUse: itemName [
        | item |
        itemName ifNil: [ Transcript show: 'Use what?'; cr. ^false ].
        item := player findItemNamed: itemName.
        item ifNil: [ Transcript show: 'Item "', itemName, '" not in inventory.'; cr. ^false ].
        
        (item name sameAs: 'Potion') ifTrue: [
            player heal: 10. player inventory remove: item.
            Transcript show: 'Drank potion. +10 HP.'; cr. ^true
        ].
        (item name sameAs: 'Incantation') ifTrue: [
            (world currentRoom name = 'Banquet Hall') ifTrue: [
                Transcript show: 'Vault barrier disappears!'; cr.
                GameState current barrierOpen: true. player inventory remove: item. ^true
            ] ifFalse: [ Transcript show: 'Nothing happens.'; cr. ^false ].
        ].
        (item name sameAs: 'Orphic Hammer') ifTrue: [
            (world currentRoom name = 'Prison') ifTrue: [
                Transcript show: 'Hope is free!'; cr.
                GameState current hopeFree: true. ^true
            ] ifFalse: [ Transcript show: 'No one to free here.'; cr. ^false ].
        ].
        Transcript show: 'Cannot use this here.'; cr. ^true
    ]

    handleTalk: npcName [
        | npc answer |
        npcName ifNil: [ Transcript show: 'Talk to whom?'; cr. ^false ].
        npc := world currentRoom findNpcNamed: npcName.
        npc ifNil: [ Transcript show: 'No one named "', npcName, '" here.'; cr. ^false ].
        Transcript show: npc name, ': ', npc description; cr.

        (npc name sameAs: 'Collector') ifTrue: [
            (player findItemNamed: 'Old Coin') ifNotNil: [
                Transcript show: 'Collector: "Ah! Kitchen has the Rusty Key!"'; cr. ^true
            ].
        ].
        npc riddle ifNotNil: [
            Transcript show: 'RIDDLE: ', npc riddle; cr.
            Transcript show: 'Answer: '.
            answer := self normalize: FileStream stdin nextLine.
            isGameOver ifTrue: [ ^false ].
            
            (answer sameAs: npc answer) ifTrue: [
                Transcript show: 'Correct!'; cr.
                (npc name sameAs: 'Sphinx') ifTrue: [ Transcript show: 'Sphinx: "Use the hammer to free Hope."'; cr ].
            ] ifFalse: [ Transcript show: 'Wrong! (-5 HP)'; cr. player takeDamage: 5 ].
        ].
        ^true
    ]

    normalize: aString [
        | clean |
        aString ifNil: [ isGameOver := true. ^'' ].
        clean := aString asLowercase trim.
        (clean endsWith: '.') ifTrue: [ clean := clean copyFrom: 1 to: (clean size - 1) ].
        ^clean
    ]

    parseCommand: aString [
        | cmd parts action target openIdx closeIdx |
        "Normalize input: lowercase, trim, remove trailing dot"
        cmd := self normalize: aString.
        parts := cmd subStrings.
        parts isEmpty ifTrue: [ ^#('' nil) ].
        
        (cmd includes: $() ifTrue: [
            openIdx := cmd indexOf: $(.
            closeIdx := cmd indexOf: $).
            closeIdx = 0 ifTrue: [ closeIdx := cmd size + 1 ].
            action := (cmd copyFrom: 1 to: (openIdx - 1)) trim.
            target := (cmd copyFrom: (openIdx + 1) to: (closeIdx - 1)) trim.
            ^Array with: action with: target
        ] ifFalse: [
            action := parts first.
            parts size > 1 ifTrue: [
                "Join all remaining parts into a single target string with single spaces"
                target := (parts copyFrom: 2 to: parts size) inject: '' into: [ :acc :each | 
                    acc isEmpty ifTrue: [ each ] ifFalse: [ acc, ' ', each ]
                ].
            ^Array with: action with: target
            ].
        ].
        ^Array with: action with: nil
    ]

    handleCombatCommand: action fullCmd: cmd [
        (action = 'quit' or: [ cmd sameAs: 'quit' ]) ifTrue: [ isGameOver := true. activeEnemy := nil. ^true ].
        ((action = 'attack') or: [ cmd sameAs: 'attack' ]) ifTrue: [ self handleAttack. ^true ].
        
        ((action = 'sneak') or: [ cmd sameAs: 'sneak' ]) ifTrue: [ 
            (combatTurn = 1) ifTrue: [ self handleSneak. ^true ] 
            ifFalse: [ Transcript show: 'Too late to sneak! Use "flee".'; cr. ^true ].
        ].
        
        ((action = 'flee') or: [ cmd sameAs: 'flee' ]) ifTrue: [ 
            (combatTurn > 1) ifTrue: [ self handleFlee. ^true ]
            ifFalse: [ Transcript show: 'Use "sneak" in the first round.'; cr. ^true ].
        ].

        ((action = 'help') or: [ cmd sameAs: 'help' ]) ifTrue: [ self printInstructions. ^true ].
        (#('drink_potion' 'drinkpotion' 'use potion' 'drink potion') anySatisfy: [ :p | cmd sameAs: p ]) ifTrue: [ self handleCombatUsePotion. ^true ].
        ^false
    ]

    run [
        | cmd parse action target block |
        self characterCreation.
        isGameOver ifTrue: [ ^self ].
        
        self recruitment.
        isGameOver ifTrue: [ ^self ].

        self printInstructions.
        world look.

        [ isGameOver ] whileFalse: [
            cmd := self readCommand.
            isGameOver ifFalse: [
                activeEnemy ifNil: [
                    parse := self parseCommand: cmd.
                    action := parse first. target := parse second.
                    block := commandMap at: action ifAbsent: [ nil ].
                    block ifNotNil: [
                        block numArgs = 0 ifTrue: [ block value ] ifFalse: [ block value: target ].
                    ] ifNil: [ 
                        (action isEmpty) ifFalse: [
                            Transcript show: 'Unknown command. Type "help" for list.'; cr 
                        ].
                    ].
                ] ifNotNil: [
                    self handleCombatCommand: (self normalize: cmd) fullCmd: (self normalize: cmd).
                ]
            ]
        ].
        Transcript cr; show: 'Thanks for playing!'; cr.
    ]
]

GameEngine new run.

"Player class - Represents the main character in the game, managing stats, inventory, and companions."
Entity subclass: Player [
    | stats inventory companions |

    " Creates and initializes a new player instance "
    Player class >> new [
        | p |
        p := super new.
        p initPlayer.
        ^p
    ]

    " Initializes the player's attributes, empty inventory, and empty companion list "
    initPlayer [
        stats := Dictionary new.
        stats at: 'strength' put: 10.
        stats at: 'dexterity' put: 10.
        stats at: 'intelligence' put: 10.
        stats at: 'charisma' put: 10.
        stats at: 'endurance' put: 10.

        inventory := OrderedCollection new.
        companions := OrderedCollection new.
        
        self hp: 20; maxHp: 20.
    ]

    " the player's stats dictionary "
    stats [ ^stats ]

    " the player's current inventory collection "
    inventory [ ^inventory ]

    " the player's current list of companions "
    companions [ ^companions ]

    " --- Stat Management --- "

    " Increases the specified stat by 1 "
    increaseStat: statName [
        self increaseStat: statName by: 1.
    ]

    " Increases the specified stat by a given integer amount "
    increaseStat: statName by: anInteger [
        | current |
        current := stats at: statName ifAbsent: [ 10 ].
        stats at: statName put: (current + anInteger).
    ]

    " Returns an item from the inventory by its name, or nil if not found "
    findItemNamed: aString [
        ^inventory detect: [ :item | item name sameAs: aString ] ifNone: [ nil ]
    ]

    " Adds an item to the player's inventory "
    takeItem: anItem [ inventory add: anItem. ]

    " Removes and returns an item from the inventory by its name "
    dropItem: aString [
        | item |
        item := self findItemNamed: aString.
        item ifNil: [ ^nil ].
        inventory remove: item. ^item
    ]

    " Calculates the modifier for a given stat, including bonuses from companions "
    calculateModifier: statName [
        | base mod |
        base := stats at: statName ifAbsent: [ 10 ].
        mod := (base - 10).
        companions do: [ :comp | 
            (comp boostedStat sameAs: statName) ifTrue: [ mod := mod + comp bonusValue ].
        ].
        ^mod
    ]
    
    " Performs a skill or combat check (d20 + modifier) against a Difficulty Class (DC) "
    rollCheck: aStatName against: manualDC [
        | roll modifier total |
        roll := DiceRoller current d20.
        modifier := self calculateModifier: aStatName.
        total := roll + modifier.
        
        Transcript show: aStatName asLowercase, ' CHECK :  Rolled: ', roll printString, ' + Bonus: ', modifier printString, ' = ', total printString, ' (DC: ', manualDC printString, ')'; cr.

        (roll = 20) ifTrue: [
            Transcript show: '>> CRITICAL SUCCESS!'; cr. ^#criticalSuccess
        ].

        (total >= manualDC) ifTrue: [ 
            Transcript show: '>> SUCCESS!'; cr. ^#success
        ] ifFalse: [
            Transcript show: '>> FAILURE!'; cr. ^#failure
        ].
    ]

    " Prints the player's current stats and companions to the Transcript "
    displayStats [
        Transcript show: '--- CURRENT STATISTICS ---'; cr.
        Transcript show: '[STR: ', (stats at: 'strength') printString, 
                     ' | DEX: ', (stats at: 'dexterity') printString,
                     ' | INT: ', (stats at: 'intelligence') printString,
                     ' | CHA: ', (stats at: 'charisma') printString,
                     ' | END: ', (stats at: 'endurance') printString, ']'; cr.
        Transcript show: 'Companions: '.
        companions isEmpty ifTrue: [ Transcript show: 'None' ]
        ifFalse: [ companions do: [ :c | Transcript show: c name, ' ' ] ].
        Transcript cr; cr.
    ]
]

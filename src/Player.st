"Player class - Represents the main character in the House of Hope."

Entity subclass: Player [
    | stats inventory companions |

    Player class >> new [
        | p |
        p := super new.
        p initPlayer.
        ^p
    ]

    initPlayer [
        stats := Dictionary new.
        stats at: 'strength' put: 10.
        stats at: 'dexterity' put: 10.
        stats at: 'intelligence' put: 10.
        stats at: 'charisma' put: 10.
        stats at: 'endurance' put: 10.

        inventory := OrderedCollection new.
        companions := OrderedCollection new.
        
        self hp: 30; maxHp: 30.
    ]

    increaseStat: statName [
        self increaseStat: statName by: 1.
    ]

    increaseStat: statName by: anInteger [
        | current |
        current := stats at: statName ifAbsent: [ 10 ].
        stats at: statName put: (current + anInteger).
    ]

    stats [ ^stats ]
    inventory [ ^inventory ]
    companions [ ^companions ]

    findItemNamed: aString [
        ^inventory detect: [ :item | item name sameAs: aString ] ifNone: [ nil ]
    ]

    takeItem: anItem [ inventory add: anItem. ]
    dropItem: aString [
        | item |
        item := self findItemNamed: aString.
        item ifNil: [ ^nil ].
        inventory remove: item. ^item
    ]

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

    calculateModifier: statName [
        | base mod |
        base := stats at: statName ifAbsent: [ 10 ].
        mod := (base - 10).
        companions do: [ :comp | 
            (comp boostedStat sameAs: statName) ifTrue: [ mod := mod + comp bonusValue ].
        ].
        ^mod
    ]
    
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
]

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
        "Default stats according to OPIS_GRY.md (starts at 10)"
        stats := Dictionary new.
        stats at: 'strength' put: 10.
        stats at: 'dexterity' put: 10.
        stats at: 'intelligence' put: 10.
        stats at: 'charisma' put: 10.
        stats at: 'endurance' put: 10.

        inventory := OrderedCollection new.
        companions := OrderedCollection new.
        
        "Starting life is usually linked to endurance or fixed"
        self hp: 30; maxHp: 30.
    ]

    stats [ ^stats ]
    inventory [ ^inventory ]
    companions [ ^companions ]

    findItemNamed: aString [
        ^inventory detect: [ :item | item name sameAs: aString ] ifNone: [ nil ]
    ]

    dropItem: aString [
        | item |
        item := self findItemNamed: aString.
        item ifNil: [ ^nil ].
        inventory remove: item.
        ^item
    ]

    "Calculate modifier: (Stat - 10) + item_bonuses + companion_bonuses"
    calculateModifier: statName [
        | base mod |
        base := stats at: statName ifAbsent: [ 10 ].
        mod := (base - 10).
        ^mod
    ]

    takeItem: anItem [
        inventory add: anItem.
    ]

    useItem: anItem [
        "Logic for consuming items"
        (anItem isKindOf: Consumable) ifTrue: [
            anItem applyTo: self.
            inventory remove: anItem.
        ]
    ]
    
    rollCheck: aStatName against: manualDC [
        | roll modifier total |
        roll := DiceRoller current d20.
        modifier := self calculateModifier: aStatName.
        total := roll + modifier.
        
        Transcript show: 'Rzut kością (', aStatName, ' DC ', manualDC printString, '): ', roll printString, ' + ', modifier printString, ' = ', total printString; cr.

        roll = 20 ifTrue: [ 
            Transcript show: 'SUKCES KRYTYCZNY!'; cr.
            ^ #criticalSuccess 
        ].
        total >= manualDC ifTrue: [ 
            Transcript show: 'Sukces!'; cr.
            ^ #success 
        ] ifFalse: [ 
            Transcript show: 'Porażka...'; cr.
            ^ #failure 
        ].
    ]
]

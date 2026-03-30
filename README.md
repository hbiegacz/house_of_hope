# House of Hope

Step into the infernal **House of Hope**, the lair of the devil Raphael. Your soul is at stake, bound by a contract he refuses to break. Your mission is to infiltrate the house, find your **Soul Contract**  and face Raphael in a final confrontation to reclaim your freedom. Along the way, you can free the captive **Hope**, whose divine light will aid you in your darkest hour.

## Instructions

### Prerequisites

- [GNU Smalltalk](https://www.gnu.org/software/smalltalk/) (`gst`) must be installed on your system.

### How to Run

Execute the following command from the project root:

```bash
gst src/Entity.st src/Player.st src/Companion.st src/Enemy.st src/DiceRoller.st src/GameState.st src/Item.st src/NPC.st src/Room.st src/World.st src/GameEngine.st
```

### How to Play

1. **Character Creation** – Allocate **5 attribute points** among five stats ( strength, endurance, dexterity, intelligence and charisma).

2. **Assemble Your Party** – Recruit **3 companions** from: Astarion, Gale, Lae'zel, Shadowheart, Wyll. Each grants a passive bonus to one stat.

3. **Exploration Commands:**

   | Command | Description |
   |---|---|
   | `go [direction]` | Move north, south, east, or west |
   | `look` | Re-describe current room and exits |
   | `search` | Find items in the room |
   | `take [item]` | Pick up an item |
   | `inventory` | View your items |
   | `examine [item]` | Inspect an item (may reveal hints) |
   | `use [item]` | Use an item from inventory |
   | `talk [npc]` | Talk to an NPC |
   | `stats` | Display your current attributes |
   | `help` | Show all available commands |
   | `quit` | Exit the game |

4. **Combat Commands:**

   | Command | Description |
   |---|---|
   | `attack` | Standard attack roll vs. enemy AC |
   | `sneak` | Escape before combat starts (Turn 1, DEX DC 14) |
   | `flee` | Run away mid-fight (Turn 2+, DEX DC 17) |
   | `drink_potion` | Heal 10 HP |

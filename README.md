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

## Class Diagram

The project consists of 11 distinct classes, designed following the Single Responsibility Principle (SRP) to ensure clear modularity and maintainability.

### Class Hierarchy
[![](https://mermaid.ink/img/pako:eNqdVktv2zgQ_isGTyrqBHKsxI7Ry9ZOd3vIA62xBRa-0ORE4poiBZJyk2bz33coOQ4pKQF2fbDNbzjDmW8e5BNhmgNZECaptStBc0PLjRrhhwsDzAmtRuvPG9Viza7R7fZvlMTYlXLCPY6eWsx_ThQtIVgWVbAo6cMfwfqjsL9JsYfkQ4AV1UrYStLHCHV0Byta0hwSWupauUgFqByAhWIGqIVrf2osf47DuMPjwERhWEedDdZC7UE5bR4DjOmyogq5stGpwrX2kiFnvqPdxBu_QZ7CDfdC8a8OSo_zRHWkPn4vTQR-hQJudNUIuhq8ZdGfZyNPGJWsltTBtebiXqCfQ-4YLeWyALY7Sscjzobpu1JQxkVAnaNst2IhZEptln5_AHKwzIjK19ug5eULw--V2FZr64D7SCNU1fZPKmsYtHxzt3zPZs-xFhVU6rwONxrBuQwBquxPMJ2CuKlYMsydz91_d6QQyg2a-6b1_zCnQOTFVpuo4NGxcK0qFi4Bcy6gW_j--KjYKOc-dlTu1jrCw6XuVQ7-JAbtjf1MCjfk4K4ehEs6MOoNdoiBUu-Hm-f9nmu52sIbmfuhjeQR197bkCNWG4NDw5MSoJWBvdC17cLNzOjw2ZwREWrB1dU1rSKwMlgPXdBHvdbJcaBHgUuAz9ihkYLUevdGrL8jNb6_IIp3S43B-XFbgYriE1arDljoCr4Y6HfOdy33wKOhqpyhzK1x4oUWLOAAdetaKZCx8YapL5Lm9g3vV4LBN5xn8Yj_yM_SpDvyEryi-phQ49GrYICbK5ULFZMjrBfc7sOc9pJ88tMnOJwemKo9NAM1unyc0bxu0riGBxeJrDOtxHZEeD1tKTJmVAyWVHEslg6B3tt-pS2P2_sF9zU4OiYSKD8oxjdPQX1mwSxxh1fraDFTC1dix0Q4rlGjiaWZB9HNj0fIli4fZ-wjNRZe3EBPhcqj42rVK5f2iTP69M_JyeFp08ePV1JfhHdKH_TzpY--Nn-I_nithhA-dl9f9Fraw2ptYb7Ed3iuNdK7oBRD_FB7ZExy7FCywBTDmJRgSuqXpKnxDXEF4MVCFviXU7PbkI16Rh2k5i8M7UXN6DovyOKeSouruuIYxOG5edwCivv84uOMLCbTxgRZPJEHsphnp9n59Pximmbp_PLsMhuTR7KYzk_TWTqdXU6yeXoxy2bPY_KrOTM9nZ1n2WSSZpPZ9OIiPZuPCXCBr7brw3PX_zz_C86QNQo?type=png)](https://mermaid.live/edit#pako:eNqdVktv2zgQ_isGTyrqBHKsxI7Ry9ZOd3vIA62xBRa-0ORE4poiBZJyk2bz33coOQ4pKQF2fbDNbzjDmW8e5BNhmgNZECaptStBc0PLjRrhhwsDzAmtRuvPG9Viza7R7fZvlMTYlXLCPY6eWsx_ThQtIVgWVbAo6cMfwfqjsL9JsYfkQ4AV1UrYStLHCHV0Byta0hwSWupauUgFqByAhWIGqIVrf2osf47DuMPjwERhWEedDdZC7UE5bR4DjOmyogq5stGpwrX2kiFnvqPdxBu_QZ7CDfdC8a8OSo_zRHWkPn4vTQR-hQJudNUIuhq8ZdGfZyNPGJWsltTBtebiXqCfQ-4YLeWyALY7Sscjzobpu1JQxkVAnaNst2IhZEptln5_AHKwzIjK19ug5eULw--V2FZr64D7SCNU1fZPKmsYtHxzt3zPZs-xFhVU6rwONxrBuQwBquxPMJ2CuKlYMsydz91_d6QQyg2a-6b1_zCnQOTFVpuo4NGxcK0qFi4Bcy6gW_j--KjYKOc-dlTu1jrCw6XuVQ7-JAbtjf1MCjfk4K4ehEs6MOoNdoiBUu-Hm-f9nmu52sIbmfuhjeQR197bkCNWG4NDw5MSoJWBvdC17cLNzOjw2ZwREWrB1dU1rSKwMlgPXdBHvdbJcaBHgUuAz9ihkYLUevdGrL8jNb6_IIp3S43B-XFbgYriE1arDljoCr4Y6HfOdy33wKOhqpyhzK1x4oUWLOAAdetaKZCx8YapL5Lm9g3vV4LBN5xn8Yj_yM_SpDvyEryi-phQ49GrYICbK5ULFZMjrBfc7sOc9pJ88tMnOJwemKo9NAM1unyc0bxu0riGBxeJrDOtxHZEeD1tKTJmVAyWVHEslg6B3tt-pS2P2_sF9zU4OiYSKD8oxjdPQX1mwSxxh1fraDFTC1dix0Q4rlGjiaWZB9HNj0fIli4fZ-wjNRZe3EBPhcqj42rVK5f2iTP69M_JyeFp08ePV1JfhHdKH_TzpY--Nn-I_nithhA-dl9f9Fraw2ptYb7Ed3iuNdK7oBRD_FB7ZExy7FCywBTDmJRgSuqXpKnxDXEF4MVCFviXU7PbkI16Rh2k5i8M7UXN6DovyOKeSouruuIYxOG5edwCivv84uOMLCbTxgRZPJEHsphnp9n59Pximmbp_PLsMhuTR7KYzk_TWTqdXU6yeXoxy2bPY_KrOTM9nZ1n2WSSZpPZ9OIiPZuPCXCBr7brw3PX_zz_C86QNQo)


### Class relations and interactions

[![](https://mermaid.ink/img/pako:eNp9lNtu2kAQhl9ltVIkIhEKxhzii0otQajqQVGSqlLFzXQ9wIK9i3bXTQ3iplIeou1j9BGavFdnjSEmtOHGzOibmX_-XXvNhY6RR1wkYO2FhKmBdKwY_WJpUDipFbt5PVbbXEGxywRyNNXMUGGaVxMDnS5BUXE1-eFyUA3fOEyr8ZXWB_EnbZK4mhhBitcOHFaTF1LglU6SQ0EeHaqpVLiTfnLCXhkxkw4XLjPARg_f__y-VcBq17klJTlbgVnd38UrmN_fCTzdlj02YmdnL8vVWcSEQRJiGaiYpaBgivafBcUSxGf2P8B-KYKoZ2yZLaKJ2bnxpKDwmuByKhM6_QKusuZ2H_bw81aCAybZO70AMZes9pZORa9yMYdyu60639Wb79fSyoFUltUMJewRtt9_phOSanCCBpXAp9zzW23pYqSH_UU4mE2HtJ-9p-j2HEBqKY6YnTePFFJG4hH4nD5Wm2jDYrTCyKV_AU4r5o4MiBV5OlzcymWmcPHiBq3L2UeaMr__4ZR--CXkFi_N8vP274O3DkiX2CV20ipw6UfBSfUVldMmP8Yeb355v_yhJclghmJBNK_zqZExj5zJsM5TNCn4kK99pzF3M0xxzCP6G4NZjPlYbaiGVH0ml3ZlRmfTGY8mkFiKsmVMLpWfiT2CKkYz0JlyPAo6RQserfk3HrWCoBF22p2w3esE7eC8H9Z5zqN2t9HsNdvdfj9sngedVn9T56tiaLPR64Rhq9UMW712t9sMzuscY0kGvC-_U_6x-QvSSobs?type=png)](https://mermaid.live/edit#pako:eNp9lNtu2kAQhl9ltVIkIhEKxhzii0otQajqQVGSqlLFzXQ9wIK9i3bXTQ3iplIeou1j9BGavFdnjSEmtOHGzOibmX_-XXvNhY6RR1wkYO2FhKmBdKwY_WJpUDipFbt5PVbbXEGxywRyNNXMUGGaVxMDnS5BUXE1-eFyUA3fOEyr8ZXWB_EnbZK4mhhBitcOHFaTF1LglU6SQ0EeHaqpVLiTfnLCXhkxkw4XLjPARg_f__y-VcBq17klJTlbgVnd38UrmN_fCTzdlj02YmdnL8vVWcSEQRJiGaiYpaBgivafBcUSxGf2P8B-KYKoZ2yZLaKJ2bnxpKDwmuByKhM6_QKusuZ2H_bw81aCAybZO70AMZes9pZORa9yMYdyu60639Wb79fSyoFUltUMJewRtt9_phOSanCCBpXAp9zzW23pYqSH_UU4mE2HtJ-9p-j2HEBqKY6YnTePFFJG4hH4nD5Wm2jDYrTCyKV_AU4r5o4MiBV5OlzcymWmcPHiBq3L2UeaMr__4ZR--CXkFi_N8vP274O3DkiX2CV20ipw6UfBSfUVldMmP8Yeb355v_yhJclghmJBNK_zqZExj5zJsM5TNCn4kK99pzF3M0xxzCP6G4NZjPlYbaiGVH0ml3ZlRmfTGY8mkFiKsmVMLpWfiT2CKkYz0JlyPAo6RQserfk3HrWCoBF22p2w3esE7eC8H9Z5zqN2t9HsNdvdfj9sngedVn9T56tiaLPR64Rhq9UMW712t9sMzuscY0kGvC-_U_6x-QvSSobs)
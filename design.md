Design document for iRogue
======

Navigation tree
------
- Main Screen
  - Items
    - click on item to select
    - options at bottom change to
      - "drop"
      - empty
      - empty
      - variable button
        - "drink" (potions)
        - "eat" (food)
        - "equip" (weapons, armor, jewelry)
        - "unequip" (weapons, armor, jewelry)
        - "fire" (ranged weapons)
          - bring back to main screen
          - prompt for target
        - "read" (scrolls)
          - may prompt for target in inventory
        - "butcher" (corpses)
  - Magic
    - click on spell to perform
  - Religion
    - click on religious task to perform
    - options at bottom change to
      - "pray"
      - "sacrifice"
        - bring to item screen
        - prompt for target
      - empty
      - "defect"
  - Variable button
    - "pickup" when standing on item
      - pops up list of items to pick up
      - list stays up while items are clicked to pick up
      - button says "done"
      - list hides when done is clicked
    - "go up" when standing on >
    - "go down" when standing on <
    - "pray" when standing on altar
    - "drink" when standing on water
    - "close" when standing on open door
    - "multiple" when standing on terrain with items and action
      - pops up list of items and terrain action
      - button says "done"
      - list stays until:
        - action taken if it leaves tile
          - eg: stairs
        - "done" clicked
    

Object Tree
------

- Action
	- Subclasses:
		- Move 
			- Direction
		- Attack
			- Target
		- Pick up Item
			- Item to pick up
		- Use Item
			- Item to use
			- Target
		- Drop item
			- Item to drop


- Scheduler
	- DoTurn( Action )
		- Calls AIAction on all non-player mobs
		- Calls PerformAction on all mobs

- Dungeon
	- List of TerrainTypes
	- Global info?
	- Levels
		- List of Entities
		-	Array of TerrainTiles

- Entity
	- Name 
	- Look (text)
	- Draw info: character, fg color, bg color

- TerrainTile
	- TerrainType (isa Entity)
		- Action (open/close, use, etc)
		- Passable
	- HasBeenSeen bool
	-	IsVisible bool
	- Properties (string:int, can be read by the TerrainType class)

- Mob (isa Entity)
	- List of Items
	- Properties (string:int)
	- PerformAction(Action) (called by Scheduler)
	- AIAction

- Item (isa Entity)
	- Autopickup (bool)
	- Properties (string:int)
		
	- Walked Onto Action
	- Pick up Action
		- Can be hidden (traps)
	- Drop Action
		- Can be denied (cursed clothing, etc)
	- Action
		- Actions have custom names per item
		- Can act on:
			- Self
			- Another item
			- Direction
			- Target Mob

    
    
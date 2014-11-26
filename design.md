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
    
    
    
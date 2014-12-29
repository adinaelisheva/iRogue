//
//  Scheduler.swift
//  iRogue
//
//  Created by Alex Karantza on 11/26/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import Foundation

protocol Action {
    
}

class MoveAction : Action {
    let direction : Direction
    
    init(direction: Direction) {
        self.direction = direction
    }
    
}

class InteractAction : Action {
    let interactWith : Entity
    
    init(interactWith:Entity) {
        self.interactWith = interactWith
    }
}

class AttackAction : Action {
    let weapon : Weapon? // Nil means no weapon used?
    let direction : Direction

    init(direction: Direction, weapon: Weapon?) {
        self.weapon = weapon
        self.direction = direction
    }
}

class Scheduler {
    
    func doTurn(level: Level, action: Action, playerMob: Mob) {
        // For every mob in the level, perform an action. The player mob performs 'action'
        
        for entity in level.things {
            if let mob = entity as? Mob{
                if mob === playerMob {
                    Game.sharedInstance.doAction(action, mob:mob)
                } else {
                    // If AIAction returns nil, then it's waiting
                    if let ai = mob.AIAction()? {
                        Game.sharedInstance.doAction(ai, mob:mob)
                    }
                }
            }
        }
        
    }
    
}
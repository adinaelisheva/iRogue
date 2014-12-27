//
//  Scheduler.swift
//  iRogue
//
//  Created by Alex Karantza on 11/26/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import Foundation


enum Direction : UInt32 {
    case NORTH, SOUTH, WEST, EAST, NE, NW, SE, SW
}

protocol Action {
    
}

class MoveAction : Action {
    let direction : Direction?
    
    init(direction: Direction?) {
        self.direction = direction
    }
    
}

class InteractAction : Action {
    let interactWith : Entity
    
    init(interactWith:Entity) {
        self.interactWith = interactWith
    }
}

class Scheduler {
    
    func doTurn(level: Level, action: Action, playerMob: Mob) {
        // For every mob in the level, perform an action. The player mob performs 'action'
        
        for entity in level.things as [Mob] {
            if entity === playerMob {
                Game.sharedInstance.doAction(action, mob:entity)
            } else {
                Game.sharedInstance.doAction(entity.AIAction(), mob:entity)
            }
        }
        
    }
    
}
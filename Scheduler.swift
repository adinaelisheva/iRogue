//
//  Scheduler.swift
//  iRogue
//
//  Created by Alex Karantza on 11/26/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import Foundation


enum Direction : UInt32 {
    case UP = 0, DOWN, LEFT, RIGHT
}

class Action {
    let direction : Direction?
    
    init(direction:Direction) {
        self.direction = direction
    }
    
}

class Scheduler {
    
    func doTurn(level: Level, action: Action, playerMob: Mob) {
        // For every mob in the level, perform an action. The player mob performs 'action'
        
        for entity in level.things as [Mob] {
            if entity === playerMob {
                entity.doAction(action)
            } else {
                entity.doAction(entity.AIAction())
            }
        }
        
    }
    
}
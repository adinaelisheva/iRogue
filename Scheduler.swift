//
//  Scheduler.swift
//  iRogue
//
//  Created by Alex Karantza on 11/26/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import Foundation


enum DIRECTION {
    case UP
    case DOWN
    case LEFT
    case RIGHT
}

class Action {
    let direction : DIRECTION?
    
    init(direction:DIRECTION) {
        self.direction = direction
    }
    
}

class Scheduler {
    
    func doTurn(level: Level, action: Action) {
     
        // For every mob in the level, perform an action. The player mob performs 'action'

    }
    
}
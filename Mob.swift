//
//  Mob.swift
//  iRogue
//
//  Created by Adina Rubinoff on 11/26/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import Foundation
import UIKit

class Mob : Entity {
    var inventory = [Item]()
    
    var gold = 0

    func AIAction() -> Action{
        
        //random walk
        var dir = Direction(rawValue:arc4random_uniform(4))
        
        return MoveAction(direction:dir!)
        
    }
    
    func pickup(item:Item){
        inventory.append(item)
        Game.sharedInstance.Log("\(name) picked up \(item.name)")
        
    }
    
}

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
    
    var properties = [String:Int]()
    
    override init(name:String?, description:String?, char:Character?, color:UIColor?) {
        
        super.init(name:name, description:description, char:char, color:color)
        
    }
    
    func doAction(action:Action){
        var temp = (x:coords.x,y:coords.y)
        if let dir = action.direction? {
            switch dir {
            case .UP:
                temp.y++
                break
            case .DOWN:
                temp.y--
                break
            case .LEFT:
                temp.x--
                break
            case .RIGHT:
                temp.x++
                break
            default:
                break
            }
        }
        if Game.sharedInstance.level.isPassable(temp){
            coords = temp
        }
    }
    
    func AIAction() -> Action{
        
        //random walk
        var dir = Direction(rawValue:arc4random_uniform(4))
        
        return Action(direction:dir!)
        
    }
    
}

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
        if let dir = action.direction? {
            switch dir {
            case .UP:
                coords.y++
                break
            case .DOWN:
                coords.y--
                break
            case .LEFT:
                coords.x--
                break
            case .RIGHT:
                coords.x++
                break
            default:
                break
            }
        }
    }
    
    func AIAction() -> Action{
        
        //random walk
        var dir = Direction(rawValue:arc4random_uniform(4))
        
        return Action(direction:dir!)
        
    }
    
}

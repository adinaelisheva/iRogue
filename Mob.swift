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
    
    private func performAction(action:Int){ //should be Action
        if true {//let dir = action.direction?
            switch 5 {//action.direction {
            case 1: //UP
                coord.y++
                break
            case 2: //DOWN
                coord.y--
                break
            case 3: //LEFT
                coord.x--
                break
            case 4: //RIGHT
                coord.x++
                break
            default:
                break
            }
        }
    }
    
}

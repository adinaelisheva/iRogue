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
    
    private func performAction(action:Action){
        if let dir = action.direction? {
            switch dir {
            case .UP:
                coord.y++
                break
            case .DOWN:
                coord.y--
                break
            case .LEFT:
                coord.x--
                break
            case .RIGHT:
                coord.x++
                break
            default:
                break
            }
        }
    }
    
}

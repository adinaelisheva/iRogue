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
    var inventory = [ItemTypes : [Item]]()
    
    var gold = 0
    var hp = 0
    var maxHP = 0
    
    //slots
    var weapon : Item?
    var clothing : Item?
    var ring : Item?
    var amulet : Item?
    
    init(name: String?, description: String?, char: Character?, color: UIColor?,hp:Int) {
        self.hp = hp
        self.maxHP = hp
        super.init(name: name,description: description,char: char,color: color)
    }

    func AIAction() -> Action{
        
        //random walk
        var dir = Direction(rawValue:arc4random_uniform(4))
        
        return MoveAction(direction:dir!)
        
    }
    
    func addToHP(amt:Int){
        hp += amt
        if hp > maxHP{ hp = maxHP }
        if hp < 0 { hp = 0 }
    }
    
    func pickup(item:Item){
        if inventory[item.type] == nil{
            inventory[item.type] = [item]
        } else {
            inventory[item.type]!.append(item)
        }
        Game.sharedInstance.Log("\(name) picked up \(item.name)")
    }
    
}

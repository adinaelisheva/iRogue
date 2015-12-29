//
//  Terrain.swift
//  iRogue
//
//  Created by Adina Rubinoff on 11/28/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import Foundation
import UIKit

class TerrainTile : Entity {
    
    var passable = true
    var seen = false
    var visible = false
    
    // For temp pathfinding use
    var distance = INT32_MAX
    var backtrace : TerrainTile?
    var visited = false
    
    init(coords:(x:Int,y:Int)){
        super.init(name: "floor", description: "Plain stone floor", char: ".", color: UIColor.whiteColor())
        self.coords = coords
    }
    
    func bump(mob: Mob) {
    }
}

//alias for basic terrain tile
class Floor : TerrainTile {}

class Wall : TerrainTile {
    override init(coords:(x:Int,y:Int)){
        super.init(coords:coords)
        name = "wall"
        description = "An immovable wall."
        char = "#"
        color = UIColor(red:0.67,green:0.65,blue:0.294,alpha:1)
        passable = false
    }
}

class Water : TerrainTile {
    override init(coords:(x:Int,y:Int)){
        super.init(coords:coords)
        name = "water"
        description = "Some water covers the floor here."
        char = "~"
        color = UIColor.cyanColor()
        //todo - drink water
        //interactAdj = true
        //interactable = "Drink"
    }
}

class Lava : TerrainTile {
    override init(coords:(x:Int,y:Int)){
        super.init(coords:coords)
        name = "lava"
        description = "The ground here is covered in hot lava!"
        char = "~"
        color = UIColor.redColor()
    }
}

class Door : TerrainTile {
    override init(coords:(x:Int,y:Int)){
        super.init(coords:coords)
        name = "door"
        description = "An old wooden door"
        char = "+"
        passable = false
        interactable = "Open"
        interactAdj = true
        interactOn = false
    }
    
    func changeDoor(open:Bool){
        passable = open
        interactable = open ? "Close" : "Open"
        let str = open ? "opens." : "closes."
        Game.sharedInstance.Log("The door \(str)")
        char = open ? "-" : "+"
    }
    
    override func interact(mob: Mob) {
        changeDoor(!passable)
    }
    
    override func bump(mob: Mob) {
        changeDoor(!passable)
    }
}

class Stair : TerrainTile {
    var fromLvl : Int = 0
    var toLvl : Int = 0

    init(coords:(x:Int,y:Int), fromLvl:Int, toLvl:Int){
        super.init(coords:coords)
        name = "stair"
        description = "A stair to level \(toLvl)"
        char = (toLvl > fromLvl) ? ">" : "<"
        
        interactable = (toLvl > fromLvl) ? "Go Down" : "Go Up"
        
        self.fromLvl = fromLvl
        self.toLvl = max(1,toLvl)
    }
    
    override func interact(mob: Mob) {
        
        if Game.sharedInstance.dlvl == toLvl {
            Game.sharedInstance.Log("These stairs go nowhere...")
            return
        }
        
        
        let oldlevel = Game.sharedInstance.level
        
        // Create / Select the next level
        Game.sharedInstance.dlvl = toLvl
        let newLevel = Game.sharedInstance.level

        // Remove us from the old level
        oldlevel.removeEntity(mob)
        
        // Place us in the right spot
        if (toLvl > fromLvl) {
            mob.coords = (newLevel as! BasicLevel).upStair!.coords
        } else {
            mob.coords = (newLevel as! BasicLevel).downStair!.coords
        }

        // Add us to the new level
        newLevel.addEntity(mob)

    }
}




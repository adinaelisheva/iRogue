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
        
        interactable = "Climb"
    }
    
    override func interact() {
        Game.sharedInstance.Log("climbing stair")
    }
}




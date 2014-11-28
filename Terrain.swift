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
    
    init(coords:(x:Int,y:Int)){
        super.init(name: "floor", description: "Plain stone floor", char: ".", color: UIColor.whiteColor())
        self.coords = coords
    }
    
}

//alias for basic terrain tile
class Floor : TerrainTile {
    override init(coords:(x:Int,y:Int)){
        super.init(coords:coords)
    }
}

class Wall : TerrainTile {
    override init(coords:(x:Int,y:Int)){
        super.init(coords:coords)
        name = "wall"
        description = "An immovable wall."
        char = "#"
        color = UIColor.whiteColor()
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
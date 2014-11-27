//
//  Level.swift
//  iRogue
//
//  Created by Alex Karantza on 11/26/14.
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
        color = UIColor.blueColor()
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

class Level {
    
    var things = [Entity]()
    
    var map = [TerrainTile?]()
    
    
    let mapSize : (w:Int,h:Int)

    private func getMapArrayIndex(coord: (x:Int, y:Int)) -> Int? {
        let index = coord.x + coord.y * mapSize.w
        
        if (coord.x >= mapSize.w || coord.y >= mapSize.h || index >= map.count) {
            return nil
        }
        
        return index
    }
    
    func setTile(tile: TerrainTile?) {
        if let coords = tile?.coords {
            if let index = getMapArrayIndex(coords) {
                map[index] = tile
            }
        }
    }
    
    func getTileAt(coord: (x:Int, y:Int)) -> TerrainTile? {
        if let index = getMapArrayIndex(coord) {
            return map[index]
        } else {
            return nil
        }
    }
    
    func isPassable(coord: (x:Int, y:Int)) -> Bool {
        
        if let tile = getTileAt(coord){
            return tile.passable
        }
        return false
        
    }
    
    init(w:Int,h:Int) {
        
        mapSize = (w,h)
        map = [TerrainTile?](count:mapSize.w * mapSize.h, repeatedValue:nil)
        
        for i in 0..<w {
            for j in 0..<h {
                setTile(TerrainTile(coords:(i,j)))
            }
        }
        
    }
    
    
}
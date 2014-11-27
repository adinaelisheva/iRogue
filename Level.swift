//
//  Level.swift
//  iRogue
//
//  Created by Alex Karantza on 11/26/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import Foundation

// TODO
class TerrainTile {}

class Level {
    
    var things = [Entity]()
    
    var map = [TerrainTile?]()
    
    
    let mapSize : (w:Int,h:Int)

    private func getMapArrayIndex(coord: (x:Int, y:Int)) -> Int? {
        let index = coord.x + coord.y * mapSize.w
        
        if (coord.x > mapSize.w || coord.y > mapSize.h || index > map.count) {
            return nil
        }
        
        return index
    }
    
    func setTileAt(coord: (x:Int, y:Int), tile: TerrainTile?) {
        if let index = getMapArrayIndex(coord) {
            map[index] = tile
        }
    }
    
    func getTileAt(coord: (x:Int, y:Int)) -> TerrainTile? {
        if let index = getMapArrayIndex(coord) {
            return map[index]
        } else {
            return nil
        }
    }
    
    init() {
        
        mapSize = (20,20)
        map = [TerrainTile?](count:mapSize.w * mapSize.h, repeatedValue:nil)
        
    }
    
    
}
//
//  Level.swift
//  iRogue
//
//  Created by Alex Karantza on 11/26/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import Foundation

class Level {
    
    var things = [Entity]()
    var map = [TerrainTile?]()
    
    
    var rooms : [Room]
    //the dimensions in number of rooms
    var numRooms : (w:Int,h:Int)
    
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
                map[index]?.remove()
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
        
        rooms = []
        numRooms = (0,0)
        
        //fill in all spaces with plain ground
        //for i in 0..<w {
        //    for j in 0..<h {
        //        setTile(TerrainTile(coords:(i,j)))
        //    }
        //}
        
    }
    
    
}
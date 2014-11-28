//
//  Room.swift
//  iRogue
//
//  Created by Adina Rubinoff on 11/28/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import Foundation

class Room {
    init(x:Int,y:Int,setFunc:(TerrainTile?)->(),roomSize:Int) {
        var roomW = roomSize
        var roomH = roomSize
        //minimum size for a room is 3 floors, 2 walls, and 1 hallway = 6
        if roomSize > 6{
            roomW = Int(arc4random_uniform(UInt32(roomSize - 5))) + 6
            roomH = Int(arc4random_uniform(UInt32(roomSize - 5))) + 6
        }
        //add walls for room, leave 1 for hallways
        for i in x..<x+roomW-1 {
            for j in y..<y+roomH-1 {
                if i == x || j == y || i == x+roomW-2 || j == y+roomH-2 {
                    setFunc(Wall(coords: (x:i,y:j)))
                } else {
                    setFunc(Floor(coords: (x:i,y:j)))
                }
            }
        }
    }
    
}
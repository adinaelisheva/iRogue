//
//  Room.swift
//  iRogue
//
//  Created by Adina Rubinoff on 11/28/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import Foundation

class Room {
    var doors : [Game.DoorMask : Math.Point] = [:]
    
    // This is the area of the floor. You can place things within these points inclusive
    let area : (x1:Int, y1:Int, x2:Int, y2:Int)
    
    func randomPoint() -> (x:Int, y:Int) {
        return (
            Int(arc4random_uniform(UInt32(area.x2 - area.x1 + 1))) + area.x1,
            Int(arc4random_uniform(UInt32(area.y2 - area.y1 + 1))) + area.y1)
    }
    
    init(x:Int,y:Int,setFunc:(TerrainTile?)->(),roomSize:Int,doorsMask:Int) {

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
        
        
        area = (x+1,y+1,x+roomW-3,y+roomH-3 )
        
        //add doors
        if(doorsMask & Game.DoorMask.UP.rawValue > 0){
            let coord = Int(arc4random_uniform(UInt32(roomW-3))) + 1
            let tx = x+coord
            let ty = y+roomH-2
            setFunc(Door(coords:(x:tx,y:ty)))
            doors[Game.DoorMask.UP] = (x:tx,y:ty)
        }
        if(doorsMask & Game.DoorMask.DOWN.rawValue > 0){
            let coord = Int(arc4random_uniform(UInt32(roomW-3))) + 1
            let tx = x+coord
            let ty = y
            setFunc(Door(coords:(x:tx,y:ty)))
            doors[Game.DoorMask.DOWN] = (x:tx,y:ty)
        }
        if(doorsMask & Game.DoorMask.LEFT.rawValue > 0){
            let coord = Int(arc4random_uniform(UInt32(roomH-3))) + 1
            let tx = x
            let ty = y+coord
            setFunc(Door(coords:(x:tx,y:ty)))
            doors[Game.DoorMask.LEFT] = (x:tx,y:ty)
        }
        if(doorsMask & Game.DoorMask.RIGHT.rawValue > 0){
            let coord = Int(arc4random_uniform(UInt32(roomH-3))) + 1
            let tx = x+roomW-2
            let ty = y+coord
            setFunc(Door(coords:(x:tx,y:ty)))
            doors[Game.DoorMask.RIGHT] = (x:tx,y:ty)
        }
    }
    
    
    
}
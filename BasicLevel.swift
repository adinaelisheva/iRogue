//
//  BasicLevel.swift
//  iRogue
//
//  Created by Adina Rubinoff on 11/28/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import Foundation

class BasicLevel : Level {
    
    // Stairs to/from this level
    var upStair : TerrainTile?
    var downStair : TerrainTile?
    
    init(w:Int,h:Int,level:Int) {
        
        //rooms default to 5x5, 2 blocks for walls, one for hallway
        let roomSize = 8
        
        //make the width and height even multiples of roomSize
        let x = (w/roomSize) //number of rooms across
        let y = (h/roomSize) //number of rooms vertically
        
        super.init(w:x*roomSize,h:y*roomSize)
        numRooms = (w:x,h:y)
        
        //iterate through and make rooms!
        for j in 0..<y {
            for i in 0..<x {
                var mask = Game.DoorMask.UP.rawValue | Game.DoorMask.LEFT.rawValue | Game.DoorMask.DOWN.rawValue | Game.DoorMask.RIGHT.rawValue
                if i == 0 { mask = mask - Game.DoorMask.LEFT.rawValue }
                if j == 0 { mask = mask - Game.DoorMask.DOWN.rawValue }
                if i == x-1 { mask = mask - Game.DoorMask.RIGHT.rawValue }
                if j == y-1 { mask = mask - Game.DoorMask.UP.rawValue }
                
                rooms.append(Room(x:i*roomSize,y:j*roomSize,setFunc:setTile,roomSize:roomSize, doorsMask:mask))
                
            }
        }
        
        for i in 0..<x{
            for j in 0..<y{
                if j != y-1 {
                    //vertical connection
                    let d1 = getRoomAt(i,y:j)?.doors[Game.DoorMask.UP]
                    let d2 = getRoomAt(i,y:j+1)?.doors[Game.DoorMask.DOWN]
                    connectByHallway(d1,d2:d2,vertical:true)
                }
                if i != x-1 {
                    //horizontal connection
                    let d1 = getRoomAt(i,y:j)?.doors[Game.DoorMask.RIGHT]
                    let d2 = getRoomAt(i+1,y:j)?.doors[Game.DoorMask.LEFT]
                    connectByHallway(d1,d2:d2,vertical:false)
                }
            }
        }
        
        
        // Find places for up/down stairs
        let uproom = rooms[Int(arc4random_uniform(UInt32(rooms.count)))]
        let dnroom = rooms[Int(arc4random_uniform(UInt32(rooms.count)))]
        
        let uppos = uproom.randomPoint()
        let dnpos = dnroom.randomPoint()
        
        upStair = Stair(coords: uppos, fromLvl: level, toLvl: level - 1)
        downStair = Stair(coords: dnpos, fromLvl: level, toLvl: level + 1)
        
        setTile(upStair)
        setTile(downStair)
        
        //add some random items per room - between 0 and 3
        for r in rooms{
            let rand = arc4random_uniform(100)
            var x = 0
            //calculate my own distribution:
            //50% chance of 0 items, 30% 1, 10% 2, 7% 3, 3% 4
            if rand < 50 {
                x = 0
            } else if rand < 80 {
                x = 1
            } else if rand < 90 {
                x = 2
            } else if rand < 97 {
                x = 3
            } else {
                x = 4
            }
            for i in 0...x{
                let it = getDistRandomItem()
                it.coords = r.randomPoint()
                things.append(it)
            }
        }
        
        
    }
    
    func connectByHallway(d1:Math.Point?,d2:Math.Point?,vertical:Bool){
        if d1 == nil || d2 == nil {
            return
        }
        //get rid of !s
        let p1 = d1!
        let p2 = d2!
        
        //find min and max points
        let maxY = max(p1.y,p2.y)
        let minY = min(p1.y,p2.y)
        let maxX = max(p1.x,p2.x)
        let minX = min(p1.x,p2.x)
        
        //array for saving the path
        var path : [Math.Point] = []
        
        //draw the path itself as floor
        if vertical{
            let bend = (maxY+minY)/2
            for j in minY+1..<bend{
                let p = Math.Point(x:p1.x,y:j)
                setTile(Floor(coords:p))
                path.append(p)
            }
            for i in minX...maxX {
                let p = Math.Point(x:i,y:bend)
                setTile(Floor(coords:p))
                path.append(p)
            }
            for j in bend..<maxY{
                let p = Math.Point(x:p2.x,y:j)
                setTile(Floor(coords:p))
                path.append(p)
            }
        } else {
            let bend = (maxX+minX)/2
            for i in minX+1..<bend{
                let p = Math.Point(x:i,y:p1.y)
                setTile(Floor(coords:p))
                path.append(p)
            }
            for j in minY...maxY {
                let p = Math.Point(x:bend,y:j)
                setTile(Floor(coords:p))
                path.append(p)
            }
            for i in bend..<maxX{
                let p = Math.Point(x:i,y:p2.y)
                setTile(Floor(coords:p))
                path.append(p)
            }
        }
        
        //add walls all around on all non-null tiles!
        for p in path {
            if getTileAt((p.x-1,p.y)) == nil{
                setTile(Wall(coords:(p.x-1,p.y)))
            }
            if getTileAt((p.x+1,p.y)) == nil{
                setTile(Wall(coords:(p.x+1,p.y)))
            }
            if getTileAt((p.x,p.y-1)) == nil{
                setTile(Wall(coords:(p.x,p.y-1)))
            }
            if getTileAt((p.x,p.y+1)) == nil{
                setTile(Wall(coords:(p.x,p.y+1)))
            }
            if getTileAt((p.x-1,p.y-1)) == nil{
                setTile(Wall(coords:(p.x-1,p.y-1)))
            }
            if getTileAt((p.x+1,p.y+1)) == nil{
                setTile(Wall(coords:(p.x+1,p.y+1)))
            }
            if getTileAt((p.x-1,p.y+1)) == nil{
                setTile(Wall(coords:(p.x-1,p.y+1)))
            }
            if getTileAt((p.x+1,p.y-1)) == nil{
                setTile(Wall(coords:(p.x+1,p.y-1)))
            }
        }
        
        
    }
    
    func getRoomAt(x:Int,y:Int) -> (Room?) {
        let index = y*numRooms.w + x
        if index >= rooms.count {
            return nil
        }
        return rooms[index]
    }
    
    func setRoomAt(x:Int,y:Int,room:Room) {
        let index = y*numRooms.w + x
        if index < rooms.count{
            rooms[index] = room
        }
    }
    
    
}



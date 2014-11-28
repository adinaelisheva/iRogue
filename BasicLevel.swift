//
//  BasicLevel.swift
//  iRogue
//
//  Created by Adina Rubinoff on 11/28/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import Foundation

class BasicLevel : Level {
    
    override init(w:Int,h:Int){
        
        //rooms default to 5x5, 2 blocks for walls, one for hallway
        let roomSize = 8
        
        //make the width and height even multiples of roomSize
        let x = (w/roomSize) //number of rooms across
        let y = (h/roomSize) //number of rooms vertically
        
        super.init(w:x*roomSize,h:y*roomSize)
        numRooms = (w:x,h:y)
        //iterate through and make rooms!
        for i in 0..<x {
            for j in 0..<y {
                var mask = Game.DoorMask.UP.rawValue | Game.DoorMask.LEFT.rawValue | Game.DoorMask.DOWN.rawValue | Game.DoorMask.RIGHT.rawValue
                if i == 0 { mask = mask - Game.DoorMask.LEFT.rawValue }
                if j == 0 { mask = mask - Game.DoorMask.DOWN.rawValue }
                if i == x-1 { mask = mask - Game.DoorMask.RIGHT.rawValue }
                if j == y-1 { mask = mask - Game.DoorMask.UP.rawValue }
                
                rooms.append(Room(x:i*roomSize,y:j*roomSize,setFunc:setTile,roomSize:roomSize, doorsMask:mask))
            }
        }
        
        //TODO: step through the rooms, get their doors, connect them
        
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



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
        
        let nw = x*roomSize
        let nh = y*roomSize
        
        super.init(w:nw,h:nh)
        
        //iterate through and make rooms!
        for i in 0..<x {
            for j in 0..<y {
                Room(x:i*roomSize,y:j*roomSize,setFunc:setTile,roomSize:roomSize)
            }
        }
        
    }
    
}
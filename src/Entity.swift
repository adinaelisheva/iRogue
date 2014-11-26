//
//  Entity.swift
//  iRogue
//
//  Created by Adina Rubinoff on 11/26/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import Foundation
import UIKit

class Entity {

    var name : String = "???"
    var description : String = "What is this mysterious object?"
    var char : Character = "?"
    var color : UIColor = UIColor.whiteColor()
    var coord : (x:Int,y:Int) = (0,0)
    
    init(name:String?, description:String?, char:Character?, color:UIColor?) {
        self.name = name? ?? self.name
        self.description = description? ?? self.description
        self.char = char? ?? self.char
        self.color = color? ?? self.color
        
    }
    
}

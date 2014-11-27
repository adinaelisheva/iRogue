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
    
    var char : Character = "?" {
        didSet {
            self.sprite.character = char
        }
    }
    
    var color : UIColor = UIColor.whiteColor() {
        didSet {
            self.sprite.color = color
        }
    }
    
    var coords : (x:Int,y:Int) = (0,0) {
        didSet {
            self.sprite.position = Game.sharedInstance.scene.getCellPosFromCoords(coords)
        }
    }
    
    let sprite : EntitySKNode!
    
    init(name:String?, description:String?, char:Character?, color:UIColor?) {
        self.name = name? ?? self.name
        self.description = description? ?? self.description
        self.char = char? ?? self.char
        self.color = color? ?? self.color

        self.sprite = Game.sharedInstance.scene.addEntity(self)
    }
    
    func remove() {
        sprite.removeFromParent()
    }
    
    func touched() {
        Game.sharedInstance.Log(description)
    }
 
    
    
}

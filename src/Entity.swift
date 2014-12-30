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
    
    var char : Character = " " {
        didSet {
            self.sprite.character = char
        }
    }
    
    // If non-nil, show up in the Interact menu.
    var interactable : String?
    var properties = [String:Int]()
    
    var color : UIColor = UIColor.whiteColor()
    
    var coords : (x:Int,y:Int) = (0,0)
    
    let sprite : EntitySKNode!
    
    init(name:String?, description:String?, char:Character?, color:UIColor?) {
        self.name = name? ?? self.name
        self.description = description? ?? self.description
        self.char = char? ?? self.char
        self.color = color? ?? self.color

        self.sprite = Game.sharedInstance.scene.addEntity(self)
    }
    
    // Adds the entity to the display
    func show() {
        if (sprite.parent != nil) { return }
        Game.sharedInstance.scene.camera.addChild(sprite)
    }
    
    // Removes the entity from teh display
    func hide() {
        if (sprite.parent == nil) { return }
        sprite.removeFromParent()
    }
    
    func getOwnIndex(arr : [AnyObject]) -> Int?{
        for i in 0..<arr.count{
            if arr[i] === self {return i}
        }
        return nil
    }
    
    func removeSelfFromLevel(){
        if let i = getOwnIndex(Game.sharedInstance.level.things)? {
            Game.sharedInstance.level.things.removeAtIndex(i)
        }
        hide()
        return
    }
     
    // This happens when we touch the item in the Interact menu.
    func interact(mob: Mob) {
        Game.sharedInstance.Log("Can't interact with \(name)")
    }
    
}

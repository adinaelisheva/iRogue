//
//  EntitySKNode.swift
//  iRogue
//
//  Created by Alex Karantza on 11/26/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import Foundation
import SpriteKit

let asciiMap = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"

class EntitySKNode : SKSpriteNode {
    
    let entity : Entity!
    
    var character : Character = "?" {
        didSet {
            self.texture = EntitySKNode.textureForCharacter(character)
        }
    }
    
    class func textureForCharacter(char : Character) -> SKTexture? {
        if let index = asciiMap.rangeOfString(String(char)) {
            let intIdx = asciiMap.startIndex.distanceTo(index.startIndex)
            let x = intIdx % 10
            let y = 9 - intIdx / 10
            let rect = CGRectMake(CGFloat(x)/10.0, CGFloat(y)/10.0, 0.1, 0.1)
            return SKTexture(rect: rect, inTexture: Game.sharedInstance.scene.ascii)
        }
        return nil
    }
    
    init(character:Character, color:UIColor, entity:Entity) {
        let tex = EntitySKNode.textureForCharacter(character)!
        self.entity = entity
        self.character = character
        
        super.init(texture: tex, color:entity.color, size: tex.size())
        
        self.colorBlendFactor = 1
        userInteractionEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        self.entity = nil
        super.init(coder: aDecoder)
    }
    
    func updateFromEntity() {
        self.position = Game.sharedInstance.scene.getCellPosFromCoords(entity.coords)
        
        if let tile = Game.sharedInstance?.level.getTileAt(entity.coords) {
            if !tile.visible {
                if tile.seen {
                    self.color = UIColor.darkGrayColor()
                } else {
                    self.color = UIColor.blackColor()
                }
            } else {
                self.color = entity.color
            }
        }
    }
    
}

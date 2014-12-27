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
            self.texture = textureForCharacter(character)?
        }
    }
    
    func textureForCharacter(char : Character) -> SKTexture? {
        var index = asciiMap.rangeOfString(String(char))
        if let index = index? {
            var intIdx = distance(asciiMap.startIndex, index.startIndex)
            var x = intIdx % 10
            var y = 9 - intIdx / 10
            var rect = CGRectMake(CGFloat(x)/10.0, CGFloat(y)/10.0, 0.1, 0.1)
            return SKTexture(rect: rect, inTexture: Game.sharedInstance.scene.ascii)
        }
        return nil
    }
    
    init(character:Character, color:UIColor, entity:Entity) {
        super.init()
        
        self.entity = entity
        self.character = character
        self.texture = textureForCharacter(character)?
        //        self.blendMode = SKBlendMode.Add
        self.colorBlendFactor = 1
        userInteractionEnabled = true
    }

    override init() {
        super.init()
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateFromEntity() {
        self.position = Game.sharedInstance.scene.getCellPosFromCoords(entity.coords)
        
        if let tile = Game.sharedInstance?.level?.getTileAt(entity.coords) {
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
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {

        /* Fix this somehow...
        self.color = UIColor(red:0.3,green:0.3,blue:0.3,alpha:1)
        runAction(SKAction.colorizeWithColor(UIColor.blackColor(), colorBlendFactor: 1, duration: 0.1))
        */
        entity.touched()
    }
    
}

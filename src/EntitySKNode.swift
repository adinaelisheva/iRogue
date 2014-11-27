//
//  EntitySKNode.swift
//  iRogue
//
//  Created by Alex Karantza on 11/26/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import Foundation
import SpriteKit

class EntitySKNode : SKSpriteNode {
    
    let entity : Entity!
    let label : SKLabelNode!
    
    init(character:Character, color:UIColor, entity:Entity) {
        super.init()
        
        self.entity = entity
        
        label = SKLabelNode(fontNamed: "Menlo")
        label.fontSize = 14
        label.fontColor = color
        label.text = String(character)
        label.position = CGPoint(x:0, y: -GameScene.cellSize.h / 2)
        self.addChild(label)
        
        self.color = UIColor.blackColor()
        
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
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {

        self.color = UIColor.whiteColor()
        runAction(SKAction.colorizeWithColor(UIColor.blackColor(), colorBlendFactor: 1, duration: 0.1))
        
        entity.touched()
    }
    
}

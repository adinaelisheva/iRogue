//
//  EntitySKNode.swift
//  iRogue
//
//  Created by Alex Karantza on 11/26/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import Foundation
import SpriteKit

class EntitySKNode : SKLabelNode {
    
    let entity : Entity?
    
    init(character:Character, color:UIColor, entity:Entity) {
        super.init(fontNamed: "Menlo")
        
        self.entity = entity
        fontSize = 14
        fontColor = color
        text = String(character)
        
        userInteractionEnabled = true
    }

    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        entity?.touched()
        
    }
    
}

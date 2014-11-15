//
//  GameScene.swift
//  iRogue
//
//  Created by Adina Rubinoff on 11/15/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var charPos:(x:Int,y:Int) = (15,12)
    var cellSize:(w:Int,h:Int) = (0,0)
    var gridSize:(w:Int,h:Int) = (0,0)
    let char = SKLabelNode(fontNamed:"Menlo")
    
    
    //kind of like a constructor - set up is in here
    override func didMoveToView(view: SKView) {
        
        //create the main character
        char.text = "@"
        char.fontSize = 14
        //use @ to find the grid size
        var size = char.calculateAccumulatedFrame().size
        cellSize = (w:Int(size.width*1.1),h:Int(size.height*1.1))
        
        self.addChild(char)
        
        self.backgroundColor = UIColor.blackColor()
        
    }
    
    override func didChangeSize(oldSize: CGSize) {
        var frame = self.frame
        if cellSize.w != 0 && cellSize.h != 0 {
            gridSize = (w:Int(frame.width)/cellSize.w,h:Int(frame.height)/cellSize.h)
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        var oldpos = char.position
        
        var x = (charPos.x*cellSize.w) + (cellSize.w/2)
        var y = (charPos.y*cellSize.h) + (cellSize.h/2)
        
        char.position = CGPoint(x:Int(x),y:Int(y))
    
    }
    
    func activityLog(str:String){
        if let mainvc = self.view?.window?.rootViewController as? MainViewController {
            mainvc.log(str)
        }
    }
}

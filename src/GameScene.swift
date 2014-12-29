
import SpriteKit

private let _cellSize:(w:Int,h:Int) = (8,16) // 12x16?

class GameScene: SKScene {
    //hardcoded font size
    class var cellSize:(w:Int,h:Int) {
        return _cellSize
    }
    
    var gridSize:(w:Int,h:Int) = (0,0)
    
    let ascii = SKTexture(imageNamed: "characters")
    
    let camera = SKNode()
    
    func addEntity(e:Entity) -> EntitySKNode {
        //create the main character]
        let c = EntitySKNode(character: e.char, color: e.color, entity: e)
        c.size = CGSize(width: _cellSize.w, height: _cellSize.h)
        camera.addChild(c)
        
        return c
    }
    
    //kind of like a constructor - set up is in here
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.blackColor()
        self.addChild(camera)
    }
    
    override func didChangeSize(oldSize: CGSize) {
        var frame = self.frame
        if _cellSize.w != 0 && _cellSize.h != 0 {
            gridSize = (w:Int(frame.width)/_cellSize.w,h:Int(frame.height)/_cellSize.h)
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if let touch = touches.allObjects.first as? UITouch {
            // Get all nodes that we've tapped on
            let nodes = self.nodesAtPoint(touch.locationInNode(self))
            // Get the coordinate we're on too
            let pixelcoord = touch.locationInNode(camera)
            let coords = (
                x:Int(pixelcoord.x) / GameScene.cellSize.w,
                y:Int(pixelcoord.y) / GameScene.cellSize.h)
            
            
            // Put together a string.
            var retStr = ""
            
            // Determine the visibility of this tile.
            if let tile = Game.sharedInstance?.level?.getTileAt(coords) {
                if !tile.seen {
                    retStr = "You're not sure what's here."
                    
                } else {
                    let entNodes = nodes.filter({ $0 is EntitySKNode }) as [EntitySKNode]
                    
                    for (i, entityNode) in enumerate(entNodes) {
                        let ent = entityNode.entity
                        
                        // Skip floor tiles, if there's anything else to see
                        if (entNodes.count > 1 && ent is Floor) {
                            continue
                        }
                        
                        if (tile.visible) {
                            retStr += "\(ent.char) \(ent.description)"
                        } else {
                            retStr += "(\(ent.char) \(ent.description))"
                        }
                        
                        if i < entNodes.count - 1 {
                            retStr += "\n"
                        }
                        
                    }
                    
                }
            } else {
                retStr = "Nothing here."
            }
            
            Game.sharedInstance.Log(retStr)
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
    func getCellPosFromCoords(coords : (x:Int,y:Int)) -> CGPoint {
        var x = (coords.x*_cellSize.w) + (_cellSize.w/2)
        var y = (coords.y*_cellSize.h) + (_cellSize.h/2)
        return CGPoint(x:x,y:y)
    }
    
    func activityLog(str:NSAttributedString){
        if let mainvc = self.view?.window?.rootViewController as? MainViewController {
            mainvc.log(str)
        }
    }
}

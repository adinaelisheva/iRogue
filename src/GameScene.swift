
import SpriteKit

private let _cellSize:(w:Int,h:Int) = (8,16) // 12x16?

class GameScene: SKScene {
    //hardcoded font size
    class var cellSize:(w:Int,h:Int) {
        return _cellSize
    }
    
    var gridSize:(w:Int,h:Int) = (0,0)
    
    let ascii = SKTexture(imageNamed: "characters")
    
    let cameraNode = SKNode()
    
    func addEntity(e:Entity) {
        //create the main character]
        cameraNode.addChild(e.sprite)
    }
    
    //kind of like a constructor - set up is in here
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.blackColor()
        self.addChild(cameraNode)
    }
    
    override func didChangeSize(oldSize: CGSize) {
        let frame = self.frame
        if _cellSize.w != 0 && _cellSize.h != 0 {
            gridSize = (w:Int(frame.width)/_cellSize.w,h:Int(frame.height)/_cellSize.h)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        if let touch = touches.first {
            // Get all nodes that we've tapped on
            let nodes = self.nodesAtPoint(touch.locationInNode(self))
            // Get the coordinate we're on too
            let pixelcoord = touch.locationInNode(cameraNode)
            let coords = (
                x:Int(pixelcoord.x) / GameScene.cellSize.w,
                y:Int(pixelcoord.y) / GameScene.cellSize.h)
            
            
            // Determine the visibility of this tile.
            if let tile = Game.sharedInstance?.level.getTileAt(coords) {
                if tile.seen {
                    let entNodes = nodes.filter({ $0 is EntitySKNode }) as! [EntitySKNode]
                    
                    for entityNode in entNodes {
                        let ent = entityNode.entity
                        
                        // Skip floor tiles, if there's anything else to see
                        if (entNodes.count > 1 && ent is Floor) {
                            continue
                        }
                        
                        if (tile.visible) {
                            Game.sharedInstance.Log("\(ent.char) \(ent.description)")
                        } else {
                            Game.sharedInstance.Log("(\(ent.char) \(ent.description))")
                        }
                    }
                    
                    return
                }
            }
            Game.sharedInstance.Log("You're not sure what's here.")
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
    func getCellPosFromCoords(coords : (x:Int,y:Int)) -> CGPoint {
        let x = (coords.x*_cellSize.w) + (_cellSize.w/2)
        let y = (coords.y*_cellSize.h) + (_cellSize.h/2)
        return CGPoint(x:x,y:y)
    }
    
    func activityLog(str:NSAttributedString){
        if let mainvc = self.view?.window?.rootViewController as? MainViewController {
            mainvc.log(str)
        }
    }
}

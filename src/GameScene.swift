
import SpriteKit

class GameScene: SKScene {
    //hardcoded font size
    var cellSize:(w:Int,h:Int) = (12,16)
    var gridSize:(w:Int,h:Int) = (0,0)
    let char = SKLabelNode(fontNamed:"Menlo")
    
    func addEntity(e:Entity) -> SKLabelNode{
        //create the main character]
        let c = EntitySKNode(character: e.char, color: e.color, entity: e)
        self.addChild(c)
        
        return c
    }
    
    //kind of like a constructor - set up is in here
    override func didMoveToView(view: SKView) {
        
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
        
        for ent in self.children as [EntitySKNode] {
            if let gameEntity = ent.entity? {
                ent.position = getCellPosFromCoords(gameEntity.coords)
            }
        }
        
    }
    
    func getCellPosFromCoords(coords : (x:Int,y:Int)) -> CGPoint {
        var x = (coords.x*cellSize.w) + (cellSize.w/2)
        var y = (coords.y*cellSize.h) + (cellSize.h/2)
        return CGPoint(x:x,y:y)
    }
    
    

    
    func activityLog(str:String){
        if let mainvc = self.view?.window?.rootViewController as? MainViewController {
            mainvc.log(str)
        }
    }
}

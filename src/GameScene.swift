
import SpriteKit

class GameScene: SKScene {
    //hardcoded font size
    var cellSize:(w:Int,h:Int) = (12,16)
    var gridSize:(w:Int,h:Int) = (0,0)
    let char = SKLabelNode(fontNamed:"Menlo")
    
    func addEntity(e:Entity) -> SKLabelNode{
        //create the main character]
        let c = SKLabelNode(fontNamed:"Menlo")
        c.text = String(e.char)
        c.fontSize = 14
        c.fontColor = e.color
        
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
        
    
    }
    
    func activityLog(str:String){
        if let mainvc = self.view?.window?.rootViewController as? MainViewController {
            mainvc.log(str)
        }
    }
}

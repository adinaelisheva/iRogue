
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
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
    func getCellPosFromCoords(coords : (x:Int,y:Int)) -> CGPoint {
        var x = (coords.x*_cellSize.w) + (_cellSize.w/2)
        var y = (coords.y*_cellSize.h) + (_cellSize.h/2)
        return CGPoint(x:x,y:y)
    }
    
    func activityLog(str:String){
        if let mainvc = self.view?.window?.rootViewController as? MainViewController {
            mainvc.log(str)
        }
    }
}

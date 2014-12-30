
import Foundation
import UIKit

private var _SharedInstance : Game?

class Game {
    
    // Singleton Stuff
    class var sharedInstance: Game! {
        return _SharedInstance
    }
    
    // Public global object things

    var level : Level!
    var xpLevel = 1
    var xp = 0 
    var playerMob : Mob!
    var aiMob : AIMob!
    
    enum ZOrder : UInt32 {
        case TERRAIN = 0, ITEM, MOB, PLAYER
    }
    enum DoorMask : Int {
        case UP = 1
        case DOWN = 2
        case LEFT = 4
        case RIGHT = 8
    }
    
    ///// LOGGING 
    
    private var logMessages : [String] = []
    
    var logCallback : ((NSAttributedString) -> Void)?;
    var logString: NSAttributedString {
        get {
            let oldAttrs : [NSObject:AnyObject] = [
                NSForegroundColorAttributeName: UIColor.grayColor(),
                NSFontAttributeName: UIFont(name: "Menlo", size: CGFloat(12))!]
            
            let newAttrs : [NSObject:AnyObject] = [
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: UIFont(name: "Menlo", size: CGFloat(12))!]
            
            var str = NSMutableAttributedString()
            for (i, message) in enumerate(logMessages.reverse()) {
                
                var attrmessage = NSAttributedString(string: "\n"+message, attributes: (i == 0) ? newAttrs : oldAttrs)
                
                str.appendAttributedString(attrmessage)
            }
            return str
        }
    }
    
    func Log(line : String) {
        logMessages.append(line)
        logCallback?(logString)
    }
    
    ///// Game Internal Stuff
    
    let scene : GameScene!
    private let scheduler = Scheduler()
    
    init(scene : GameScene) {
        _SharedInstance = self
        
        self.scene = scene // Must be initialized before creating any entities!
        self.level = BasicLevel(w:64,h:24,level: 1)
        
        self.playerMob = Mob(name: "Adinex", description: "A brave and noble adventurer", char: "@", color: UIColor.whiteColor())
        self.playerMob.sprite.zPosition = CGFloat(ZOrder.PLAYER.rawValue)
        
        self.aiMob = AIMob(name: "AI", description: "A scary monster", char: "M", color: UIColor.greenColor())
        self.aiMob.sprite.zPosition = CGFloat(ZOrder.MOB.rawValue)
        self.aiMob.target = self.playerMob
        
        //add test items
        level.things.append(playerMob)
        level.things.append(aiMob)
        aiMob.coords = (level as BasicLevel).downStair!.coords
        playerMob.coords = (level as BasicLevel).upStair!.coords
        
        level.computeVisibilityFrom(playerMob.coords)
        level.updateSprites()

    }
    
    func takeTurnWithAction(action : Action) {
        scheduler.doTurn(level, action: action, playerMob: playerMob)
        
        level.computeVisibilityFrom(playerMob.coords)
        level.updateSprites()
    }
    
    
    // ACTION HANDLING
    
    func doAction(action: Action, mob: Mob){
        
        if let action = action as? MoveAction {
            
            var temp = (x:mob.coords.x,y:mob.coords.y) + action.direction
            if level.isPassable(temp){
                mob.coords = temp
            } else {
                // We ran into something. WalkInto it?
                // TODO
            }
        } else if let action = action as? InteractAction {
            action.interactWith.interact(mob)
        }
        
        
    }

    
}
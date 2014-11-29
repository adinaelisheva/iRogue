
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
    var aiMob : Mob!
    
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
    
    var logCallback : ((String) -> Void)?;
    var logString: String {
        get { return "\n".join(logMessages.reverse()) }
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
        self.level = BasicLevel(w:32,h:24)
        
        self.playerMob = Mob(name: "Adinex", description: "A brave and noble adventurer", char: "@", color: UIColor.whiteColor())
        self.playerMob.sprite.zPosition = CGFloat(ZOrder.PLAYER.rawValue)
        self.aiMob = Mob(name: "AI", description: "A scary monster", char: "M", color: UIColor.greenColor())
        self.aiMob.sprite.zPosition = CGFloat(ZOrder.MOB.rawValue)
        
        //add test items
        level.things.append(playerMob)
        level.things.append(aiMob)
        aiMob.coords = (2,2)
        playerMob.coords = (3,3)
        
        level.computeVisibilityFrom(playerMob.coords)
        level.updateSprites()

    }
    
    func takeTurnWithAction(action : Action) {
        scheduler.doTurn(level, action: action, playerMob: playerMob)
        
        level.computeVisibilityFrom(playerMob.coords)
        level.updateSprites()
    }
    
    
}
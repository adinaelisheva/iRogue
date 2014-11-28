
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
        self.level = BasicLevel(w:24,h:24)
        
        self.playerMob = Mob(name: "Adinex", description: "A brave and noble adventurer", char: "@", color: UIColor.whiteColor())
        self.playerMob.sprite.zPosition = 3 // 3 = player mob TODO:enum!!!!
        self.aiMob = Mob(name: "AI", description: "A scary monster", char: "M", color: UIColor.greenColor())
        self.aiMob.sprite.zPosition = 2 // 2 = other mobs
        
        //add test items
        level.things.append(playerMob)
        level.things.append(aiMob)
        aiMob.coords = (2,2)
        playerMob.coords = (3,3)
        
        level.computeVisibilityFrom(playerMob.coords)
        
    }
    
    func takeTurnWithAction(action : Action) {
        scheduler.doTurn(level, action: action, playerMob: playerMob)
        
        level.computeVisibilityFrom(playerMob.coords)
    }
    
    
}
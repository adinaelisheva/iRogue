
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
        self.level = Level(w:20,h:20)
        
        self.playerMob = Mob(name: "Adinex", description: "A brave and noble adventurer", char: "@", color: UIColor.whiteColor())
        self.playerMob.sprite.zPosition = 3 // 3 = player mob
        self.aiMob = Mob(name: "AI", description: "A scary monster", char: "M", color: UIColor.greenColor())
        self.aiMob.sprite.zPosition = 2 // 2 = other mobs
        
        //create test level
        for i in 0..<20 {
            level.setTile(Wall(coords: (x:i,y:0)))
            level.setTile(Wall(coords: (x:i,y:19)))
            level.setTile(Wall(coords: (x:0,y:i)))
            level.setTile(Wall(coords: (x:19,y:i)))
        }
        
        for i in 4...7{
            for j in 12...14 {
                level.setTile(Lava(coords: (x:i,y:j)))
            }
        }
        
        
        for i in 14...18{
            for j in 3...5 {
                level.setTile(Water(coords: (x:i,y:j)))
            }
        }
        
        //add test items
        level.things.append(playerMob)
        level.things.append(aiMob)
        aiMob.coords = (10,10)
        playerMob.coords = (12,15)
        
    }
    
    func takeTurnWithAction(action : Action) {
        scheduler.doTurn(level, action: action, playerMob: playerMob)
    }
    
    
}
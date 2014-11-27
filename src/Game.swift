
import Foundation
import UIKit

private let _SharedInstance = Game()

class Game {
    
    // Singleton Stuff
    class var sharedInstance: Game {
        return _SharedInstance
    }
    
    // Public global object things

    var testLevel = Level()
    var playerLevel = 1
    var xp = 0 
    var playerMob = Mob(name: "Player", description: "A brave and noble adventurer", char: "@", color: UIColor.whiteColor())
    var aiMob = Mob(name: "AI", description: "A scary monster", char: "M", color: UIColor.greenColor())
    
    
    
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
    
    private let scheduler = Scheduler()
    
    init() {
        
        testLevel.things.append(playerMob)
        testLevel.things.append(aiMob)
        aiMob.coords = (10,10)
        playerMob.coords = (12,15)
        
    }
    
    func takeTurnWithAction(action : Action) {
        scheduler.doTurn(testLevel, action: action, playerMob: playerMob)
    }
    
    
}
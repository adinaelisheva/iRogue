
import Foundation
import UIKit

private var _SharedInstance : Game?


private let lvlWidth = 32
private let lvlHeight = 24

class Game {
    
    // Singleton Stuff
    class var sharedInstance: Game! {
        return _SharedInstance
    }
    
    // Public global object things
    var level : Level {
        get {
            while (dungeon.count < dlvl) {
                dungeon.append(BasicLevel(w: lvlWidth, h: lvlHeight, level: dungeon.count + 1))
            }
            
            return dungeon[dlvl-1]
        }
    }
    
    private var dungeon : [Level] = []
    
    var dlvl : Int = 0 {
        didSet {
            if dlvl < 1 {
                dlvl = 1
            }
            if oldValue != dlvl {
                dungeon[oldValue - 1].hideSprites()
                if dungeon.count >= dlvl {
                    dungeon[dlvl - 1].showSprites()
                }
                Log("You are on level \(dlvl).")
            }
        }
    }
    
    var turnCount = 0
    var xpLevel = 1
    var xp = 0 
    var playerMob : Mob!
    var aiMob : AIMob!
    
    //for us to reach the MVC
    var UICallback : (() -> Void)?
    
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
    
    struct LogMessage {
        let turn : Int
        let message : String
    }
    
    private var logMessages : [LogMessage] = []
    
    var logString: NSAttributedString {
        get {
            let oldAttrs : [NSObject:AnyObject] = [
                NSForegroundColorAttributeName: UIColor.grayColor(),
                NSFontAttributeName: UIFont(name: "Menlo", size: CGFloat(12))!]
            
            let newAttrs : [NSObject:AnyObject] = [
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: UIFont(name: "Menlo", size: CGFloat(12))!]
            
            var str = NSMutableAttributedString()
            for x in logMessages.reverse() {
                
                var attrmessage = NSAttributedString(string: "\n" + x.message, attributes: (x.turn == turnCount) ? newAttrs : oldAttrs)
                
                str.appendAttributedString(attrmessage)
            }
            return str
        }
    }
    
    func Log(lines: [String]) {
        for line in lines.reverse() {
            Log(line)
        }
    }
    
    func Log(line : String) {
        logMessages.append(LogMessage(turn: turnCount, message: line))
    }
    
    ///// Game Internal Stuff
    
    let scene : GameScene!
    private let scheduler = Scheduler()
    
    init(scene : GameScene) {
        
        self.scene = scene // Must be initialized before creating any entities!
        self.dlvl = 1
        
        _SharedInstance = self
        
        self.playerMob = Mob(name: "Adinex", description: "A brave and noble adventurer", char: "@", color: UIColor.whiteColor(),hp:20)
        self.playerMob.sprite.zPosition = CGFloat(ZOrder.PLAYER.rawValue)
        self.aiMob = AIMob(name: "Monster", description: "A scary monster", char: "M", color: UIColor.greenColor(),hp:10)
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
        turnCount++
        
        scheduler.doTurn(level, action: action, playerMob: playerMob)
        
        level.computeVisibilityFrom(playerMob.coords)
        level.updateSprites()
        
        UICallback?()
    }
    
    
    // Called when a mob's HP drops to zero, or is otherwise killed
    func kill(mob : Mob) {
        
        if mob === playerMob {
            
            Log("You die... (resetting HP for testing)")
            
            // TODO: get around to handling the endgame. For now we reset to maxhp.
            mob.hp = mob.maxHP
            
        } else {
            Log("\(mob.name) is killed! +\(mob.maxHP) XP")
            xp += mob.maxHP
            
            // Put the mob's inventory onto the map
            for (type,items) in mob.inventory {
                for item in items {
                    item.coords = mob.coords
                    level.things.append(item)
                    item.show()
                }
            }
            
            // Remove the mob
            mob.removeSelfFromLevel()
        }
        
    }
    
    // ACTION HANDLING
    
    func doAction(action: Action, mob: Mob){
        
        if let action = action as? MoveAction {
            var temp = (x:mob.coords.x,y:mob.coords.y) + action.direction
            
            let targets = level.things.filter({ $0 is Mob && $0.coords == temp }) as [Mob]
            if targets.count > 0 {
                // There's a mob in our way!
                // TODO: use the right weapon for melee combat...
                doAttackAction(AttackAction(direction: action.direction, weapon: nil), mob:mob)
            } else if level.isPassable(temp){
                mob.coords = temp
            } else {
                // We ran into something.
                level.getTileAt(temp)?.bump(mob)
            }
        }
        else if let action = action as? InteractAction { action.interactWith.interact(mob) }
        else if let action = action as? UseAction { action.item.useFn(mob) }
        else if let action = action as? AttackAction { doAttackAction(action, mob:mob) }
        
    }
    
    func doAttackAction(action: AttackAction, mob: Mob) {
        let targetsquare = mob.coords + action.direction
        let targets = level.things.filter({ $0 is Mob && $0.coords == targetsquare }) as [Mob]
        for target in targets {
            let weaponname = mob.weapon?.name ?? "bare hands"
            Log("* \(mob.name) hits \(target.name) with \(weaponname)")
            target.hp--
        }
        
    }

    
}

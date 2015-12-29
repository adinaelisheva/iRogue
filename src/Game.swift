
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
    var level : Level { get { return genLevel(dlvl) } }
    
    var scrollNames = [ScrollType : String]()
    var potionAdjs = [PotionType : String]()
    var potionColors = [PotionType : UIColor]()
    var identifiedScrolls = [ScrollType : Bool]()
    var identifiedPotions = [PotionType : Bool]()
    
    private var dungeon : [Level] = []
    
    private func genLevel(dlvl : Int) -> Level
    {
        while (dungeon.count < dlvl) {
            dungeon.append(BasicLevel(w: lvlWidth, h: lvlHeight, level: dungeon.count + 1))
        }
        
        return dungeon[dlvl-1]
    }
    
    private func displayLevel(l : Level) {
        Game.sharedInstance.scene.cameraNode.addChild(l.node)
        Log("You are on level \(dlvl).")
    }
    
    var dlvl : Int = 0 {
        didSet {
            let oldlevel = genLevel(oldValue)
            let newlevel = genLevel(dlvl)

            oldlevel.node.removeFromParent()
            displayLevel(newlevel)
        }
    }
    
    var turnCount = 0
    var xpLevel = 1
    var xp = 0 
    var playerMob : Mob!
    
    //for us to reach the MVC
    var UICallback : (() -> Void)?
        
    
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
    
    var logCallback : ((Void)->Void)?
    private var logMessages : [LogMessage] = [] {
        didSet {
            logCallback?()
        }
    }
    
    
    var logString: NSAttributedString {
        get {
            let oldAttrs : [String:AnyObject] = [
                NSForegroundColorAttributeName: UIColor.grayColor(),
                NSFontAttributeName: UIFont(name: "Menlo", size: CGFloat(12))!]
            
            let newAttrs : [String:AnyObject] = [
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: UIFont(name: "Menlo", size: CGFloat(12))!]
            
            let str = NSMutableAttributedString()
            for x in Array(logMessages.reverse()) {
                let attrmessage = NSAttributedString(string: "\n\(x.message)", attributes: (x.turn == turnCount) ? newAttrs : oldAttrs)
                str.appendAttributedString(attrmessage)
            }
            return str
        }
    }
    
    func Log(lines: [String]) {
        for line in lines {
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
        
        dlvl = 1
        
        //set up scroll names
        var i = 0 as UInt32
        var end = ScrollType.LAST.rawValue
        while i < end {
            if let type = ScrollType(rawValue:i){
                let length = 6 + arc4random_uniform(4)
                var name = ""
                for _ in 0..<length{
                    //ascii caps chars are 101 to 132
                    let char = 65 + arc4random_uniform(25)
                    name.append(Character(UnicodeScalar(char)))
                }
                scrollNames[type] = name
            }
            i++
        }
        //now potions
        i = 0
        end = PotionType.LAST.rawValue
        let colorNames = ["red","orange","yellow","green","blue","purple","black","white","teal","brown","grey"]
        let adjs = ["frothy","bubbly","sparkly","thick","viscous","clear","shimmery"]
        let colors = [UIColor.redColor(),UIColor.orangeColor(),UIColor.yellowColor(),UIColor.greenColor(),UIColor.blueColor(),UIColor.purpleColor(),UIColor.grayColor(),UIColor.brownColor(),UIColor.whiteColor()]
        while i < end {
            if let type = PotionType(rawValue:i){
                let colorN = colorNames[Int(arc4random_uniform(UInt32(colorNames.count)))]
                let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
                let a = adjs[Int(arc4random_uniform(UInt32(adjs.count)))]
                let adj = "\(a) \(colorN)"
                potionAdjs[type] = adj
                potionColors[type] = color
            }
            i++
        }
        
        _SharedInstance = self
        
        self.playerMob = Mob(name: "Adinex", description: "A brave and noble adventurer", char: "@", color: UIColor.whiteColor(),hp:20)
        self.playerMob.team = Mob.Team.FRIEND
        self.playerMob.sprite.zPosition = CGFloat(Entity.ZOrder.PLAYER.rawValue)
        
        //add test items
        level.addEntity(playerMob)
        
        playerMob.coords = (level as! BasicLevel).upStair!.coords
        
        level.computeVisibilityFrom(playerMob.coords)
        level.updateSprites()

        displayLevel(level)
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
            for items in mob.inventory.values {
                for item in items {
                    item.coords = mob.coords
                    level.addEntity(item)
                    item.show()
                }
            }
            
            // Remove the mob
            level.removeEntity(mob)
        }
        
    }
    
    // ACTION HANDLING
    
    func doAction(action: Action, mob: Mob){
        
        if let action = action as? MoveAction {
            let temp = (x:mob.coords.x,y:mob.coords.y) + action.direction
            
            let targets = level.things.filter({ $0 is Mob && $0.coords == temp }) as! [Mob]
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
        let targets = level.things.filter({ $0 is Mob && $0.coords == targetsquare }) as! [Mob]
        for target in targets {
            if(target.team == mob.team) {
                Log("\(mob.name) and \(target.name) trade places")
                let tmp = target.coords
                target.coords = mob.coords
                mob.coords = tmp                
            } else {
                
                let attack = mob.DC - target.AC
                
                //only log if the player was involved
                if(mob.team == playerMob.team || target.team == playerMob.team) {
                    if (attack < 0) {
                        Log("\(mob.name) misses \(target.name)!")
                    } else {
                        Log("\(mob.name) hits \(target.name) for \(attack)HP!")
                        target.hp -= attack
                    }
                }
            }
        }
        
    }

    
}

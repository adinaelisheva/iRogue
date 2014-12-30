
import Foundation
import UIKit

class Mob : Entity {
    var inventory = [ItemTypes : [Item]]()
    
    var gold = 0
    
    var hp : Int = 0 {
        didSet {
            if hp > maxHP{ hp = maxHP }
            if hp < 0 { hp = 0 }
        }
    }
    
    var maxHP = 0
    
    //slots
    var weapon : Item?
    var clothing : Item?
    var ring : Item?
    var amulet : Item?
    
    init(name: String?, description: String?, char: Character?, color: UIColor?,hp:Int) {
        self.hp = hp
        self.maxHP = hp
        super.init(name: name,description: description,char: char,color: color)
    }

    func AIAction() -> Action? {
        return nil // No action by default
    }
    
    func pickup(item:Item){
        if inventory[item.type] == nil{
            inventory[item.type] = [item]
        } else {
            inventory[item.type]!.append(item)
        }
        Game.sharedInstance.Log("\(name) picked up \(item.name)")
    }
}


class AIMob : Mob {
    
    enum AIState {
        case Peaceful, WaitForTarget, AttackTarget, FleeTarget
    }
    
    // This is the current activity this mob is doing
    var state : AIState = .WaitForTarget
    
    // If we're targeting something in particular, it's held here
    weak var target : Entity!
    
    
    func Wander() -> Action? {
        //random walk
        var dir = Direction(rawValue:arc4random_uniform(8))!
        
        // If the space is blocked, try another direction at random
        var cw = arc4random_uniform(2) == 0
        
        for _ in 1...8 { // Try changing directions 8 times at most. Then give up.
            if (!(Game.sharedInstance.level.getTileAt(self.coords + dir)?.passable ?? false)) {
                dir = Math.changeDirection(dir, cw: cw)
            } else {
                return MoveAction(direction:dir)
            }
        }
        return nil
    }
    
    override func AIAction() -> Action? {
    
        switch (state) {
        case .Peaceful:
            return Wander()
            
        case .WaitForTarget:
            // check for nearby target to attack?
            if target == nil { return Wander() }
            
            // If the target is out of range, wait
            if (Math.distance(self.coords, b: target.coords) > 5) { return Wander() }
            
            // If the target is blocked by something in the level, wait
            let line = Math.lineFrom(self.coords, to: target.coords)
            for point in line {
                if !Game.sharedInstance.level.isPassable(point) { return Wander() }
            }
            
            
            // We have seen the target; do an attack!
            state = .AttackTarget
            return AIAction()
        
        case .AttackTarget:
            
            // If we don't have a target set, or it's gone, wander.
            if target == nil {
                state = .WaitForTarget
                return nil
            }
            
            // Pathfind to target if possible
            if let path = Math.pathfind(self.coords , goal: target.coords, level: Game.sharedInstance.level) {
                
                var dir : Direction! = Math.dirToCoord(path.first! - self.coords)
                
                if (dir == nil) {
                    return nil
                }
                
                // Get distance to mob
                if (Math.distance(self.coords, b: target.coords) > 1) {
                    // Try to get closer.
                    return MoveAction(direction: dir)
                } else {
                    // Attack
                    return AttackAction(direction:dir, weapon:nil);
                }
            } else {
                Game.sharedInstance.Log("\(name): I can't find \(target.name)!")
                state = .WaitForTarget
                return nil
            }
            
        case .FleeTarget:
            
            // If we don't have a target set, or it's gone, wander.
            if target == nil {
                state = .Peaceful
                return nil
            }
            
            // Pathfind to target if possible
            if let path = Math.pathfind(self.coords , goal: target.coords, level: Game.sharedInstance.level) {
                
                if path.count > 10 {
                    state = .WaitForTarget
                    
                    Game.sharedInstance.Log("\(name) resumes attacking \(target.name)")
                    return AIAction()
                }
                
                if var dir = Math.dirToCoord(path.first! - self.coords)? {
                    // Run away!
                    // TODO make a better way to go backwards...
                    dir = Math.changeDirection(dir, cw: true)
                    dir = Math.changeDirection(dir, cw: true)
                    dir = Math.changeDirection(dir, cw: true)
                    dir = Math.changeDirection(dir, cw: true)
                    
                    return MoveAction(direction: dir)
                } else {
                    return nil
                }
            } else {
                Game.sharedInstance.Log("\(name): I can't find \(target.name)!")
                state = .WaitForTarget
                return nil
            }
        }
    }
}


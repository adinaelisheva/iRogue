
import Foundation
import UIKit

class Mob : Entity {
    var inventory = [Item]()
    
    var gold = 0

    func AIAction() -> Action? {
        return nil // No action by default
    }
    
    func pickup(item:Item){
        inventory.append(item)
        Game.sharedInstance.Log("\(name) picked up \(item.name)")
        
    }
}


class AIMob : Mob {
    
    enum AIState {
        case Peaceful, WaitForTarget, AttackTarget
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
            
            Game.sharedInstance.Log("\(name): Sighted the target \(target.name)")
            
            // We have seen the target; do an attack!
            state = .AttackTarget
            return AIAction()
        
        case .AttackTarget:
            
            // If we don't have a target set, or it's gone, wander.
            if target == nil {
                state = .WaitForTarget
                return nil
            }
            
            // TODO: Replace with real pathfinding
            var dir : Direction!
            
            if (self.coords.y >  target.coords.y &&
                self.coords.x == target.coords.x) { dir = .NORTH }
            if (self.coords.y <  target.coords.y &&
                self.coords.x == target.coords.x) { dir = .SOUTH }
            
            if (self.coords.y == target.coords.y &&
                self.coords.x >  target.coords.x) { dir = .WEST }
            if (self.coords.y == target.coords.y &&
                self.coords.x <  target.coords.x) { dir = .EAST }
            
            if (self.coords.y > target.coords.y &&
                self.coords.x >  target.coords.x) { dir = .NW }
            if (self.coords.y > target.coords.y &&
                self.coords.x <  target.coords.x) { dir = .NE }
            
            if (self.coords.y < target.coords.y &&
                self.coords.x >  target.coords.x) { dir = .SW }
            if (self.coords.y < target.coords.y &&
                self.coords.x <  target.coords.x) { dir = .SE }
            
            if (dir == nil) {
                // um... we're on top of it?
                return nil
            }
            
            // Get distance to mob
            if (Math.distance(self.coords, b: target.coords) > 1) {
                // Try to get closer.
                return MoveAction(direction: dir)
            } else {
                // Attack
                Game.sharedInstance.Log("\(name): Attacking \(target.name)")
                return AttackAction(direction:dir, weapon:nil);
            }
        }
    }
}


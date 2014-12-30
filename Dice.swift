
import Foundation


class RollSpec {
    var num : Int
    var sides : Int
    var mod : Int
    
    init(n: Int, d: Int, plus: Int) {
        num = n
        sides = d
        mod = plus
    }
    
    func roll() -> Int {
        var sum = mod
        for i in 0..<num {
            sum += Int(arc4random_uniform(UInt32(sides)))
        }
        return sum
    }
    
    func roll(mod: Int) -> Int {
        return roll() + mod
    }
    
}
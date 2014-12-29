//
//  Math.swift
//  iRogue
//
//  Created by Alex Karantza on 11/27/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import Foundation

typealias Coord = (x: Int, y: Int)

enum Direction : UInt32 {
    case NORTH, SOUTH, WEST, EAST, NE, NW, SE, SW
}



func + (coords: Coord, dir: Direction) -> Coord {
    var temp = coords
    switch dir {
    case .NORTH:
        temp.y++
        break
    case .SOUTH:
        temp.y--
        break
    case .WEST:
        temp.x--
        break
    case .EAST:
        temp.x++
        break
    case .NE:
        temp.x++
        temp.y++
        break
    case .NW:
        temp.x--
        temp.y++
        break
    case .SE:
        temp.x++
        temp.y--
        break
    case .SW:
        temp.x--
        temp.y--
        break
        
    }
    return temp
}

class Math {
    
    class func distance(a:Coord, b:Coord) -> Int {
        // The chessboard distance between two points is the maximum
        // of the distances along each axis/
        return max( abs(a.x - b.x), abs(a.y - b.y) )
    }
    
    class func changeDirection(dir: Direction, cw: Bool) -> Direction {
        switch (dir) {
        case .NORTH:
            return cw ? .NE : .NW
        case .SOUTH:
            return cw ? .SW : .SE
        case .WEST:
            return cw ? .NW : .SW
        case .EAST:
            return cw ? .SE : .NE
        case .NE:
            return cw ? .EAST : .NORTH
        case .NW:
            return cw ? .NORTH : .WEST
        case .SE:
            return cw ? .SOUTH : .EAST
        case .SW:
            return cw ? .WEST : .SOUTH
        }
    }
    
    
    // returns a Bresenham line between two Coords.
    class func lineFrom(from:Coord, to:Coord) -> [Coord] {
        let d = Coord((to.x - from.x), (to.y - from.y))
        
        // Determine which octant direction our line goes to:
//         \2|1/
//         3\|/0
//        ---+---
//         4/|\7
//         /5|6\

        var octant = 0
        if (d.y >= 0) {
            if (d.x >= 0) {
                if (d.x >= d.y) {
                    octant = 0
                } else {
                    octant = 1
                }
            } else {
                if (-d.x >= d.y) {
                    octant = 3
                } else {
                    octant = 2
                }
            }
        } else {
            if (d.x >= 0) {
                if (d.x >= -d.y) {
                    octant = 7
                } else {
                    octant = 6
                }
            } else {
                if (-d.x >= -d.y) {
                    octant = 4
                } else {
                    octant = 5
                }
            }
        }
        
        // Calculate the line, in octant 0
        var line = lineAlgorithm(octantZero(d, octant: octant))
        
        for i in 0..<line.count {
            // Undo the coordinate transfer
            let step =  octantUndo(line[i], octant: octant);
            line[i] = (step.x + from.x, step.y + from.y)
        }
        
        return line
    }
    
    
    private class func lineAlgorithm(delta:Coord) -> [Coord] {
        let deltax = Float(delta.x)
        let deltay = Float(delta.y)
        let deltaerr = fabs (deltay / deltax)
        var error : Float = 0

        var y = 0
        
        var line = [Coord](count: delta.x+1, repeatedValue:(0,0))
        
        for x in 0...delta.x {
            line[x].x = x
            line[x].y = y
            
            error += deltaerr
            if error >= 0.5 {
                y = y + 1
                error = error - 1.0
            }
        }
        
        return line
        
    }
    
    
    private class func octantZero(p: Coord, octant: Int) -> Coord {
        let x = p.x; let y = p.y
        switch(octant) {
        case 0: return Coord(x,y)
        case 1: return Coord(y,x)
        case 2: return Coord(y, -x)
        case 3: return Coord(-x, y)
        case 4: return Coord(-x, -y)
        case 5: return Coord(-y, -x)
        case 6: return Coord(-y, x)
        case 7: return Coord(x, -y)
        default: return Coord(0,0)
        }
    }
    private class func octantUndo(p: Coord, octant: Int) -> Coord {
        let x = p.x; let y = p.y
        switch(octant) {
        case 0: return Coord(x,y)
        case 1: return Coord(y,x)
        case 2: return Coord(-y, x)
        case 3: return Coord(-x, y)
        case 4: return Coord(-x, -y)
        case 5: return Coord(-y, -x)
        case 6: return Coord(y, -x)
        case 7: return Coord(x, -y)
        default: return Coord(0,0)
        }
    }
    

    
}
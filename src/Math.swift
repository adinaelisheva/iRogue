//
//  Math.swift
//  iRogue
//
//  Created by Alex Karantza on 11/27/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import Foundation

class Math {
    
    typealias Point = (x: Int, y: Int)
   
    class func lineFrom(from:Point, to:Point) -> [Point] {
        let d = Point((to.x - from.x), (to.y - from.y))
        
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
    
    
    private class func lineAlgorithm(delta:Point) -> [Point] {
        let deltax = Float(delta.x)
        let deltay = Float(delta.y)
        let deltaerr = fabs (deltay / deltax)
        var error : Float = 0

        var y = 0
        
        var line : [Point] = []
        
        for x in 0...delta.x {
            line.append( Point(x,y) )
            error += deltaerr
            if error >= 0.5 {
                y = y + 1
                error = error - 1.0
            }
        }
        
        return line
        
    }
    
    
    private class func octantZero(p: Point, octant: Int) -> Point {
        let x = p.x; let y = p.y
        switch(octant) {
        case 0: return Point(x,y)
        case 1: return Point(y,x)
        case 2: return Point(y, -x)
        case 3: return Point(-x, y)
        case 4: return Point(-x, -y)
        case 5: return Point(-y, -x)
        case 6: return Point(-y, x)
        case 7: return Point(x, -y)
        default: return Point(0,0)
        }
    }
    private class func octantUndo(p: Point, octant: Int) -> Point {
        let x = p.x; let y = p.y
        switch(octant) {
        case 0: return Point(x,y)
        case 1: return Point(y,x)
        case 2: return Point(-y, x)
        case 3: return Point(-x, y)
        case 4: return Point(-x, -y)
        case 5: return Point(-y, -x)
        case 6: return Point(y, -x)
        case 7: return Point(x, -y)
        default: return Point(0,0)
        }
    }
    

    
}
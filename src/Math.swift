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
        var line = lineAlgorithmFrom(octantRelativeCoord(from, octant: octant),
            to: octantRelativeCoord(to, octant: octant))
        
        for i in 0..<line.count {
            // Undo the coordinate transfer
            line[i] = octantRelativeCoord(line[i], octant: octant);
        }
        
        return line
    }
    
    private class func octantRelativeCoord(p: Point, octant: Int) -> Point {
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
    
    
    private class func lineAlgorithmFrom(from:Point, to:Point) -> [Point] {
        let deltax = Float(to.x - from.x)
        let deltay = Float(to.y - from.y)
        let deltaerr = fabs (deltay / deltax)
        var error : Float = 0

        var y = from.y
        
        var line : [Point] = []
        
        for x in from.x...to.x {
            line.append( Point(x,y) )
            error += deltaerr
            if error >= 0.5 {
                y = y + 1
                error = error - 1.0
            }
        }
        
        return line
        
    }
    
}
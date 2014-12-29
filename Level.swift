//
//  Level.swift
//  iRogue
//
//  Created by Alex Karantza on 11/26/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import Foundation

class Level {
    
    var things = [Entity]()
    var map = [TerrainTile?]()
    
    
    var rooms : [Room]
    //the dimensions in number of rooms
    var numRooms : (w:Int,h:Int)
    
    let mapSize : (w:Int,h:Int)

    private func getMapArrayIndex(coord: (x:Int, y:Int)) -> Int? {
        let index = coord.x + coord.y * mapSize.w
        
        if (coord.x >= mapSize.w || coord.y >= mapSize.h || coord.x < 0 || coord.y < 0 || index >= map.count) {
            return nil
        }
        
        return index
    }
    
    func setTile(tile: TerrainTile?) {
        if let coords = tile?.coords {
            if let index = getMapArrayIndex(coords) {
                map[index]?.remove()
                map[index] = tile
            }
        }
    }
    
    func getTileAt(coord: (x:Int, y:Int)) -> TerrainTile? {
        if let index = getMapArrayIndex(coord) {
            return map[index]
        } else {
            return nil
        }
    }
    
    func isPassable(coord: (x:Int, y:Int)) -> Bool {
        
        if let tile = getTileAt(coord){
            return tile.passable
        }
        return false
    }
    
    // Sets terrain visible flags from the given viewpoint
    func computeVisibilityFrom(coord: Math.Point) {
        
        // Set all things invisible
        for tile in map {
            tile?.visible = false
        }
        
        var minview = (x:coord.x - 5, y:coord.y - 5)
        var maxview = (x:coord.x + 5, y:coord.y + 5)
        
        var perimiter : [Math.Point] = []
        // Build up a list of perimiter cells
        for x in (minview.x)...(maxview.x) {
            perimiter.append( (x:x, y:minview.y) )
            perimiter.append( (x:x, y:maxview.y) )
        }
        for y in (minview.y)...(maxview.y) {
            perimiter.append( (x:minview.x, y:y) )
            perimiter.append( (x:maxview.x, y:y) )
        }
        
        for p in perimiter {
            var visible = true
            // Cast a ray from our viewpoint to the perimiter
            var los = Math.lineFrom(coord, to: p)
            
            for cell in los {
                if let tile = getTileAt(cell)? {
                    visible &= (tile.passable)
                    tile.visible |= visible
                    // Mark obstructions as invisible, for now...
                } else {
                    // nil tiles block vision
                    visible = false
                }
            }
        }
        
        // Now iterate over every tile, if it's 8adjacent to a visible tile
        // then set it visible. This lets us see walls, into corners, etc.
        // We delay setting visible in the first pass so we don't propogate it
        var setVis : [TerrainTile] = []

        for x in 0..<mapSize.w {
            for y in 0..<mapSize.h {
                if let tile = getTileAt((x,y))? {
                    
                    // Don't do this bleeding effect onto more floor tiles!
                    if (tile.passable) {
                        continue
                    }
                    
                    var nVis = false
                    if let tvis = getTileAt((x-1,y-1))?.visible { nVis |= tvis }
                    if let tvis = getTileAt((x  ,y-1))?.visible { nVis |= tvis }
                    if let tvis = getTileAt((x+1,y-1))?.visible { nVis |= tvis }
                    if let tvis = getTileAt((x-1,y  ))?.visible { nVis |= tvis }
                    if let tvis = getTileAt((x+1,y  ))?.visible { nVis |= tvis }
                    if let tvis = getTileAt((x-1,y+1))?.visible { nVis |= tvis }
                    if let tvis = getTileAt((x  ,y+1))?.visible { nVis |= tvis }
                    if let tvis = getTileAt((x+1,y+1))?.visible { nVis |= tvis }
                    
                    if nVis {
                        setVis.append(tile)
                    }
                }
            }
        }
        
        for tile in setVis {
            tile.visible = true
        }
        
        for tile in map {
            if let tile = tile? {
                tile.seen |= tile.visible
            }
        }
        
    }
    
    
    // returns the shortest path between two points, or nil if no path.
    func pathfindFrom(from:Math.Point, to:Math.Point) -> [Math.Point]? {

        
        // all tiles' pathing fields are reset
        for tile in map {
            tile?.distance = INT32_MAX
            tile?.backtrace = nil
        }
        
        // Start at 'from'
        var current : TerrainTile! = getTileAt(from)
        current?.distance = 0
        
        var success = false
        
        // Calculate the path to neighboring unvisited tiles
        while (current != nil) {
            if current.coords.x == to.x && current.coords.y == to.y {
                // We've found our target!
                success = true
                break
            }
            
            let nextDist = current.distance + 1
            let c = current.coords
            
            if let t1 = getTileAt((c.x - 1, c.y)) {
                if t1.passable && !t1.visited && t1.distance > nextDist { // shorter route
                    t1.distance = nextDist
                    t1.backtrace = current
                }
            }
            if let t2 = getTileAt((c.x + 1, c.y)) {
                if t2.passable && !t2.visited  && t2.distance > nextDist { // shorter route
                    t2.distance = nextDist
                    t2.backtrace = current
                }
            }
            if let t3 = getTileAt((c.x, c.y - 1)) {
                if t3.passable && !t3.visited  && t3.distance > nextDist { // shorter route
                    t3.distance = nextDist
                    t3.backtrace = current
                }
            }
            if let t4 = getTileAt((c.x, c.y + 1)) {
                if t4.passable && !t4.visited  && t4.distance > nextDist { // shorter route
                    t4.distance = nextDist
                    t4.backtrace = current
                }
            }
            
            current.visited = true
            
            // Find the next current, the unvisited node with the lowest distance
            current = map.filter({ if let tile = $0? { return !tile.visited } else { return false } })
                .reduce(nil, combine: {
                    let d0 = $0!.distance
                    let d1 = $1!.distance
                    if (d0 < d1) { return $0 } else { return $1 }
                })
        }
        
        // We've exited the scan
        if (success) {
            // build the return path
            var list : [Math.Point] = []
            while current.backtrace != nil {
                list.append(current.coords)
                current = current.backtrace
            }
            return list // last element in list is next "step" to taks
        } else {
            // failed to find a path
            return nil
        }
        
    }
    
    
    // Updates all sprites on the level to match their entities (position, color, etc)
    func updateSprites() {
        for ent in map {
            ent?.sprite.updateFromEntity()
        }
        for ent in things {
            ent.sprite.updateFromEntity()
        }
    }
    
    init(w:Int,h:Int) {
        mapSize = (w,h)
        map = [TerrainTile?](count:mapSize.w * mapSize.h, repeatedValue:nil)
        
        rooms = []
        numRooms = (0,0)

    }
    
    
}
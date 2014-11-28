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
    
    
    func computeVisibilityFrom(coord: Math.Point) {
        
        // Set all things invisible
        for tile in map {
            tile?.visible = false
        }
        
        var perimiter : [Math.Point] = []
        // Build up a list of perimiter cells
        for x in 0..<mapSize.w {
            perimiter.append( (x:x, y:0) )
            perimiter.append( (x:x, y:mapSize.h - 1) )
        }
        for y in 0..<mapSize.h {
            perimiter.append( (x:0, y:y) )
            perimiter.append( (x:mapSize.w-1, y:y) )
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
                }
            }
        }
        
        // Now iterate over every tile, if it's 8adjacent to a visible tile
        // then set it visible. This lets us see walls, into corners, etc.
        
        // There has to be a more efficient algorith for this.
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
                    
                    tile.visible |= nVis
                }
            }
        }
        
    }
    
    init(w:Int,h:Int) {

        mapSize = (w,h)
        map = [TerrainTile?](count:mapSize.w * mapSize.h, repeatedValue:nil)
        
        //fill in all spaces with plain ground
        //for i in 0..<w {
        //    for j in 0..<h {
        //        setTile(TerrainTile(coords:(i,j)))
        //    }
        //}
        
    }
    
    
}
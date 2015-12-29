//
//  Level.swift
//  iRogue
//
//  Created by Alex Karantza on 11/26/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import Foundation
import SpriteKit

class Level {
    
    var things : [Entity] { get { return _things }}
    
    private var _things : [Entity] = []
    private var map : [TerrainTile?] = []
    
    var rooms : [Room]
    //the dimensions in number of rooms
    var numRooms : (w:Int,h:Int)
    
    let mapSize : (w:Int,h:Int)
    
    let node = SKNode()
    
    
    init(w:Int,h:Int) {
        mapSize = (w,h)
        map = [TerrainTile?](count:mapSize.w * mapSize.h, repeatedValue:nil)
        
        rooms = []
        numRooms = (0,0)
    }
    
    func addEntity(e : Entity) {
        _things.append(e)
        node.addChild(e.sprite)
        e.level = self
    }
    
    func removeEntity(e : Entity) {
        if let i = things.indexOf({$0===e}) {
            _things.removeAtIndex(i)
            e.sprite.removeFromParent()
            e.level = nil
        }
    }
    
    
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

                if let existing = map[index] {    
                    existing.sprite.removeFromParent()
                }
                
                map[index] = tile
                
                if let s = tile?.sprite {
                    node.addChild(s)
                }
                
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
    func computeVisibilityFrom(coord: Coord) {
        
        // Set all things invisible
        for tile in map {
            tile?.visible = false
        }
        
        let minview = (x:coord.x - 5, y:coord.y - 5)
        let maxview = (x:coord.x + 5, y:coord.y + 5)
        
        var perimiter : [Coord] = []
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
            let los = Math.lineFrom(coord, to: p)
            
            for cell in los {
                if let tile = getTileAt(cell) {
                    visible = visible && (tile.passable)
                    tile.visible = tile.visible || visible
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
                if let tile = getTileAt((x,y)) {
                    
                    // Don't do this bleeding effect onto more floor tiles!
                    if (tile.passable) {
                        continue
                    }
                    
                    var nVis = false
                    if let tvis = getTileAt((x-1,y-1))?.visible { nVis = nVis || tvis }
                    if let tvis = getTileAt((x  ,y-1))?.visible { nVis = nVis || tvis }
                    if let tvis = getTileAt((x+1,y-1))?.visible { nVis = nVis || tvis }
                    if let tvis = getTileAt((x-1,y  ))?.visible { nVis = nVis || tvis }
                    if let tvis = getTileAt((x+1,y  ))?.visible { nVis = nVis || tvis }
                    if let tvis = getTileAt((x-1,y+1))?.visible { nVis = nVis || tvis }
                    if let tvis = getTileAt((x  ,y+1))?.visible { nVis = nVis || tvis }
                    if let tvis = getTileAt((x+1,y+1))?.visible { nVis = nVis || tvis }
                    
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
            if let tile = tile {
                tile.seen = tile.seen || tile.visible
            }
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
    
    
}
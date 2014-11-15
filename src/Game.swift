//
//  Game.swift
//  iRogue
//
//  Created by Alex Karantza on 11/15/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import Foundation


class Game {
    
    private var logMessages : [String] = []
    
    var logCallback : ((String) -> Void)?;
    var logString: String {
        get { return "\n".join(logMessages.reverse()) }
    }
    
    func Log(line : String) {
        logMessages.append(line)
        logCallback?(logString)
    }
    
    
    init() {
        
    }
    
}
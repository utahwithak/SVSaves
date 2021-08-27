//
//  Game.swift
//  Game
//
//  Created by Carl Wieland on 8/27/21.
//

import Foundation

struct Game : Identifiable {
    
    let name: String
    let url: URL

    var id: String {
        return url.path
    }
}

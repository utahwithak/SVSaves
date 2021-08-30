//
//  Game.swift
//  Game
//
//  Created by Carl Wieland on 8/27/21.
//

import Foundation
import SDGParser


class Game : ObservableObject, Identifiable {
    
    @Published var farmName: String = ""
    
    @Published
    var isLoading = true
    
    private let path: URL
    
    private var game: Game?
    
    private var gamePath: URL {
        let name = path.lastPathComponent
        return path.appendingPathComponent(name)
    }
    
    init(path: URL ) {
        self.path = path
        
    }
    
    func loadName() async {
        isLoading = true

        
        do {
            let loadedGame = try await Parser.parse(game: gamePath)
            DispatchQueue.main.async {
                self.farmName = loadedGame.player.farmName
                
                self.isLoading = false
                
            }
            
        } catch {
            print("Failed:\(error)")
        }
        
    }
    
    
    
    var id: String {
        return path.path
    }
    
    func load() async {
        isLoading = true
        
    }
}

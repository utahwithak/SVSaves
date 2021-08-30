//
//  Game.swift
//  Game
//
//  Created by Carl Wieland on 8/27/21.
//

import Foundation
import SDGParser


class Game : ObservableObject, Identifiable {
    
    @Published
    var farmName: String = "" {
        didSet {
            game?.player.farmName = farmName
        }
    }
    
    @Published
    var isLoading = true
    
    private let path: URL
    
    private var game: SDGParser.Game?
    
    private var gamePath: URL {
        let name = path.lastPathComponent
        return path.appendingPathComponent(name)
    }
    
    init(path: URL ) {
        self.path = path
        
    }
    
    func loadName() async {
        isLoading = true
        defer {
            isLoading = false
        }
        
        do {
            game = try await Parser.parse(game: gamePath)
            self.farmName = game?.player.farmName ?? ""
            
        } catch {
            print("Failed:\(error)")
        }
        
    }
    
    var id: String {
        return path.path
    }
    
    func load() async {
        isLoading = true
        defer {
            isLoading = false
        }
        
        do {
            game = try await Parser.parse(game: gamePath)
            self.farmName = game?.player.farmName ?? ""
            
        } catch {
            print("Failed:\(error)")
        }
    }
}

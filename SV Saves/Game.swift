//
//  Game.swift
//  Game
//
//  Created by Carl Wieland on 8/27/21.
//

import Foundation

class Game : ObservableObject, Identifiable {
    
    @Published var name: String = "Loading"
    
    private let path: URL
    
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
        print("Load Name")
    
    }
    
    @Published
    var isLoading = false
    
    var id: String {
        return path.path
    }
    
    func load() async {
        isLoading = true
        
    }
}

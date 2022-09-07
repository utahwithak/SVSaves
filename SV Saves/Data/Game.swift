//
//  Game.swift
//  Game
//
//  Created by Carl Wieland on 8/27/21.
//

import Foundation
import Combine
import SDGParser
import SwiftyXMLParser

@MainActor
class Game : ObservableObject, Identifiable {

    let id: String

    @Published
    var player: Player
    
    private let path: URL

    @Published
    public private(set) var accessor: SDGParser.Game
    
    private var gamePath: URL {
        let name = path.lastPathComponent
        return path.appendingPathComponent(name)
    }

    private var subscriptions = Set<AnyCancellable>()
    
    init(path: URL ) async throws {
        id = path.path
        self.path = path
        let name = path.lastPathComponent
        let accessor = try await Parser.parse(game: path.appendingPathComponent(name))
        self.accessor = accessor
        player = Player(player: accessor.player)

        $accessor
            .map { newGame in
                Player(player: newGame.player)
            }
            .assign(to: &$player)
    }

    func reload() async throws {
        if let accessor = try? await Parser.parse(game: gamePath) {
            self.accessor = accessor
        }
    }

    func saveGame() throws {
        let document = try accessor.makeDocument()
        let data = document.data(using: .utf8)
        try data?.write(to: gamePath)

    }
    
    func load() async {        
        do {
            accessor = try await Parser.parse(game: gamePath)            
        } catch {
            print("Failed:\(error)")
        }
    }
}

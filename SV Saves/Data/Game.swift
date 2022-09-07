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

    @Published
    public var chanceToRainTomorrow: Double

    @Published
    public var season: Season

    @Published
    public var dayOfMonth: Int

    @Published
    public var year: Int

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
        chanceToRainTomorrow = accessor.chanceToRainTomorrow
        season = accessor.currentSeason
        dayOfMonth = accessor.dayOfMonth
        year = accessor.currentYear


        $accessor
            .map { newGame in
                Player(player: newGame.player)
            }
            .assign(to: &$player)
        $chanceToRainTomorrow.assign(to: \.chanceToRainTomorrow, on: accessor).store(in: &subscriptions)
        $season.assign(to: \.currentSeason, on: accessor).store(in: &subscriptions)
        $dayOfMonth.assign(to: \.dayOfMonth, on: accessor).store(in: &subscriptions)
        $year.assign(to: \.currentYear, on: accessor).store(in: &subscriptions)

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

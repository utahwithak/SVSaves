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
    public private(set) var hasBackedupVersion = false

    @Published
    public private(set) var canBackupToiCloud = false

    @Published
    public private(set) var accessor: SDGParser.Game

    @Published
    public var chanceToRainTomorrow: Double

    @Published
    public var farmType: FarmType

    @Published
    public var season: Season

    @Published
    public var dayOfMonth: Int

    @Published
    public var year: Int

    @Published
    public var samBandName: String

    @Published
    public var elliottBookName: String

    @Published
    public var dailyLuck: Double

    @Published
    public var isRaining: Bool

    @Published
    public var shippingTax: Bool

    @Published
    public var bloomDay: Bool

    @Published
    public var isLightning: Bool

    @Published
    public var isSnowing: Bool

    @Published
    public var shouldSpawnMonsters: Bool


    private var gamePath: URL {
        let name = path.lastPathComponent
        return path.appendingPathComponent(name)
    }

    private var gameSubscription: AnyCancellable!

    private var subscriptions = Set<AnyCancellable>()
    
    init(path: URL) async throws {
        id = path.path
        self.path = path
        let name = path.lastPathComponent
        let accessor = try await Parser.parse(game: path.appendingPathComponent(name))

        canBackupToiCloud = FileManager.default.containerUrl != nil

        self.accessor = accessor

        player = Player(player: accessor.player)
        chanceToRainTomorrow = accessor.chanceToRainTomorrow
        farmType = accessor.farmType
        season = accessor.currentSeason
        dayOfMonth = accessor.dayOfMonth
        year = accessor.currentYear
        samBandName = accessor.samBandName
        elliottBookName = accessor.elliottBookName
        dailyLuck = accessor.dailyLuck
        isRaining = accessor.isRaining
        shippingTax = accessor.shippingTax
        bloomDay = accessor.bloomDay
        isLightning = accessor.isLightning
        isSnowing = accessor.isSnowing
        shouldSpawnMonsters = accessor.shouldSpawnMonsters

        $accessor
            .map { newGame in
                Player(player: newGame.player)
            }
            .assign(to: &$player)

        gameSubscription = $accessor.sink { [weak self] _ in
            self?.reloadFile()
        }

        reloadFile()
    }

    private func reloadFile() {
        chanceToRainTomorrow = accessor.chanceToRainTomorrow
        farmType = accessor.farmType
        season = accessor.currentSeason
        dayOfMonth = accessor.dayOfMonth
        year = accessor.currentYear
        samBandName = accessor.samBandName
        elliottBookName = accessor.elliottBookName
        dailyLuck = accessor.dailyLuck
        isRaining = accessor.isRaining
        shippingTax = accessor.shippingTax
        bloomDay = accessor.bloomDay
        isLightning = accessor.isLightning
        isSnowing = accessor.isSnowing
        shouldSpawnMonsters = accessor.shouldSpawnMonsters

        subscriptions.removeAll(keepingCapacity: true)
        $chanceToRainTomorrow.assign(to: \.chanceToRainTomorrow, on: accessor).store(in: &subscriptions)
        $farmType.assign(to: \.farmType, on: accessor).store(in: &subscriptions)
        $season.assign(to: \.currentSeason, on: accessor).store(in: &subscriptions)
        $dayOfMonth.assign(to: \.dayOfMonth, on: accessor).store(in: &subscriptions)
        $year.assign(to: \.currentYear, on: accessor).store(in: &subscriptions)

        $samBandName.assign(to: \.samBandName, on: accessor).store(in: &subscriptions)
        $elliottBookName.assign(to: \.elliottBookName, on: accessor).store(in: &subscriptions)
        $dailyLuck.assign(to: \.dailyLuck, on: accessor).store(in: &subscriptions)
        $isRaining.assign(to: \.isRaining, on: accessor).store(in: &subscriptions)
        $shippingTax.assign(to: \.shippingTax, on: accessor).store(in: &subscriptions)
        $bloomDay.assign(to: \.bloomDay, on: accessor).store(in: &subscriptions)
        $isLightning.assign(to: \.isLightning, on: accessor).store(in: &subscriptions)
        $isSnowing.assign(to: \.isSnowing, on: accessor).store(in: &subscriptions)
        $shouldSpawnMonsters.assign(to: \.shouldSpawnMonsters, on: accessor).store(in: &subscriptions)

    }

    func reload() async throws {
        self.accessor = try await Parser.parse(game: gamePath)

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


    func checkForBackup() {

    }

    func backupGame() {
        
    }

    func restoreOldFile() {
        Task {
            let oldFile = self.path.appending(path: path.lastPathComponent + "_old")
            print("Old:\(oldFile)")
            if FileManager.default.fileExists(atPath: oldFile.path) {
                do {
                    try FileManager.default.removeItem(at: gamePath)
                    try FileManager.default.copyItem(at: oldFile, to: gamePath)
                    try await reload()
                } catch {
                    print("Failed to copy over item: \(error)")
                }

            }

        }

    }
}

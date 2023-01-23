//
//  GameManager.swift
//  GameManager
//
//  Created by Carl Wieland on 8/27/21.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class GameManager : ObservableObject {

    private var subscriptions = Set<AnyCancellable>()
    
    @Published
    var canAccessUrl = false

    @Published
    private var currentURL: URL? {
        willSet {
            currentURL?.stopAccessingSecurityScopedResource()
        }
        didSet {
            canAccessUrl = currentURL?.startAccessingSecurityScopedResource() ?? false
        }
    }

    @Published
    var isLoading = false

    let settings: Settings

    var localBackupDirectory: URL {
        FileManager.default.documentsDirectory.appendingPathComponent("Backups", isDirectory: true)
    }

    var cloudBackupDirectory: URL? {
        FileManager.default.createBackupFolderIfNeeded()
        return FileManager.default.containerUrl?.appendingPathComponent("Backups", isDirectory: true)
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HHmmssZ"
        return formatter
    }()

    init?(settings: Settings) {
        guard let url = settings.stardewValleyFolderLocation else {
            return nil
        }

        self.settings = settings
        self.games = []
        self.currentURL = url

        canAccessUrl = url.startAccessingSecurityScopedResource()

        guard canAccessUrl else {
            return nil
        }

        settings.$stardewValleyFolderLocation.assign(to: &$currentURL)

        $currentURL
            .receive(on: RunLoop.main)
            .sink { [weak self] url in
                self?.refresh()
            }.store(in: &subscriptions)

        Log.info("SV folder: \(url)")
        Log.info("Local Backup folder: \(localBackupDirectory)")
        Log.info("Cloud Backup folder: \(String(describing: cloudBackupDirectory))")
    }

    @Published
    var games: [Game] {
        willSet {
            hasGames = !games.isEmpty
        }
    }
    
    @Published
    var hasGames = false
    
    func refresh() {
        guard let currentURL else {
            canAccessUrl = false
            return
        }
        
        games.removeAll()
        guard canAccessUrl else {
            return
        }

        if let enumerator = FileManager.default.enumerator(at: currentURL, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsSubdirectoryDescendants]) {

            Task {
                self.isLoading = true
                let games = await withTaskGroup(of: Game?.self, returning: [Game].self) { group in

                    var games = [Game?]()

                    for case let fileURL as URL in enumerator {
                        Log.debug("checking:\(fileURL.lastPathComponent)")
                        guard let resourceValues = try? fileURL.resourceValues(forKeys: [.isDirectoryKey]), resourceValues.isDirectory == true else {
                            continue
                        }

                        if isGame(parentDir: fileURL) {
                            group.addTask {
                                do {
                                    return try await Game(path: fileURL, delegate: self)
                                } catch {
                                    Log.error("Failed to load game:\(fileURL.lastPathComponent), error:\(error)")
                                    return nil

                                }
                            }

                        } else {
                            print("No game found at:\(fileURL.lastPathComponent)")
                        }

                    }

                    for await result in group {
                        games.append(result)
                    }
                    return games.compactMap({ $0 }).sorted { lhs, rhs in
                        lhs.player.farmName < rhs.player.farmName
                    }
                }
                self.isLoading = false

                self.games = games
            }
        }
    }
    
    private func isGame(parentDir: URL) -> Bool {
        
        let suspectedName = parentDir.lastPathComponent
        var isDir: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: parentDir.appendingPathComponent(suspectedName).path, isDirectory: &isDir)
        return exists && !isDir.boolValue
    }

    func backupAllGames() {
        for game in games {
            backupGame(game)
        }
    }

    func backupGame(_ game: Game) {
        if settings.shouldBackupToiCloud {
            guard let cloudBackupDirectory else {
                Log.error("Cloud backup directory not available")
                return
            }
            backupGame(game, to: cloudBackupDirectory)
        } else {
            backupGame(game, to: localBackupDirectory)
        }
    }

    func backupGame(_ game: Game, to: URL) {
        let gameName = game.path.lastPathComponent
        // create backup folder for this game
        let gameBackupFolder = to.appendingPathComponent(gameName)

        let versionFolderName = Self.dateFormatter.string(from: Date())
        let destination = gameBackupFolder.appendingPathComponent(versionFolderName, isDirectory: true)

        do {
            try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: true)
        } catch {
            Log.error("Failed to create backup dir:\(error)")
            return

        }

        do {
            try FileManager.default.copyItem(at: game.path, to: destination.appendingPathComponent(gameName, isDirectory: true))
        } catch {
            Log.error("Failed to copy game to backup folder: \(error)")
        }

    }

    func removeAllBackups() {
        removeLocalBackups()
        removeiCloudBackups()
    }


    private func removeLocalBackups() {
        let localDir = localBackupDirectory
        do {
            try FileManager.default.removeItem(at: localDir)
        } catch {
            Log.error("Failed to remove local items:\(error)")
        }
    }

    private func removeiCloudBackups() {
        guard let cloudDir = cloudBackupDirectory else {
            return
        }
        do {
            try FileManager.default.removeItem(at: cloudDir)
        } catch {
            Log.error("Failed to remove cloud items:\(error)")
        }
    }
}

extension GameManager: GameDelegate {
    func backups(for game: Game) -> [Backup] {
        var localBackups = backups(for: game, in: localBackupDirectory, isLocal: true)
        if let cloudBackupDirectory {
            localBackups.append(contentsOf: backups(for: game, in: cloudBackupDirectory, isLocal: false))
        }
        return localBackups.sorted { lhs, rhs in
            lhs.date > rhs.date
        }

    }

    func backupGameLocally(_ game: Game) {
        backupGame(game, to: localBackupDirectory)
    }

    func backupGameToCloud(_ game: Game) {
        guard let cloudBackupDirectory else {
            Log.error("Cloud backup directory not available")
            return
        }
        backupGame(game, to: cloudBackupDirectory)
    }

    func backups(for game: Game, in root: URL, isLocal: Bool) -> [Backup] {
        let gameName = game.path.lastPathComponent
        // create backup folder for this game
        let gameBackupFolder = root.appendingPathComponent(gameName)
        var isDir: ObjCBool = false
        guard FileManager.default.fileExists(atPath: gameBackupFolder.path, isDirectory: &isDir), isDir.boolValue else {
            return []
        }

        do {
            let paths =  try FileManager.default.contentsOfDirectory(at: gameBackupFolder, includingPropertiesForKeys: nil)
            return paths.compactMap { Backup(url: $0, isLocal: isLocal) }.sorted(by: { $0.date > $1.date })
        } catch {
            Log.error("Failed to get contents of directory: \(error)")
            return []
        }

    }
}

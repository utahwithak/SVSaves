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
    
    private var urlPublisher: AnyPublisher<URL?, Never>
    private var subscription: AnyCancellable?
    
    @Published
    var canAccessUrl = false

    @Published
    private var currentURL: URL?

    init(url: URL, publisher: AnyPublisher<URL?, Never>) {
        self.currentURL = url
        self.urlPublisher = publisher
        
        self.canAccessUrl = true
        self.games = []
        
        self.urlPublisher.assign(to: &$currentURL)

        subscription = $currentURL.sink { [weak self] url in
            self?.refresh(with: url)
        }
    }
    
    deinit {
    }
    
    @Published
    var games: [Game] {
        willSet {
            hasGames = !games.isEmpty
        }
    }
    
    @Published
    var hasGames = false
    
    func refresh(with newSetting: URL? = nil) {
        guard let url = newSetting ?? currentURL else {
            canAccessUrl = false
            return
        }
        
        canAccessUrl = url.startAccessingSecurityScopedResource()
        games.removeAll()
        if canAccessUrl {
            
            defer {
                url.stopAccessingSecurityScopedResource()
            }
            
            if let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys:[ .isDirectoryKey], options: [.skipsSubdirectoryDescendants]) {

                Task {
                    let games = await withTaskGroup(of: Game?.self, returning: [Game].self) { group in

                        var games = [Game?]()

                        for case let fileURL as URL in enumerator {
                            guard let resourceValues = try? fileURL.resourceValues(forKeys: [.isDirectoryKey]),
                                  let isDirectory = resourceValues.isDirectory
                            else {
                                continue
                            }


                            if isDirectory && isGame(parentDir: fileURL) {
                                group.addTask {
                                    try? await Game(path: fileURL)
                                }

                            }

                        }

                        for await result in group {
                            games.append(result)
                        }
                        return games.compactMap({ $0 })
                    }

                    self.games = games
                }

            }
        }
    }
    
    private func isGame(parentDir: URL) -> Bool {
        
        let suspectedName = parentDir.lastPathComponent
        var isDir: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: parentDir.appendingPathComponent(suspectedName).path, isDirectory: &isDir)
        return exists && !isDir.boolValue
    }
    
    
}

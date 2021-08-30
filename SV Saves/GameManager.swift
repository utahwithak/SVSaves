//
//  GameManager.swift
//  GameManager
//
//  Created by Carl Wieland on 8/27/21.
//

import Foundation
import SwiftUI
import Combine


class GameManager : ObservableObject {
    
    private var rootURL: Published<URL?>
    private var subscription: AnyCancellable?
    
    @Published var canAccessUrl = false
    
    init(rootURL: Published<URL?>) {
        self.rootURL = rootURL
        
        self.canAccessUrl = true
        self.games = []
        
        subscription = self.rootURL.projectedValue.sink { url in
            self.refresh(with: url)
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
    
    private func refresh(with newSetting: URL?) {
        guard let url = newSetting else {
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
                
                for case let fileURL as URL in enumerator {
                    guard let resourceValues = try? fileURL.resourceValues(forKeys: [.isDirectoryKey]),
                          let isDirectory = resourceValues.isDirectory
                    else {
                        continue
                    }
                    
                    if isDirectory && isGame(parentDir: fileURL) {
                        games.append(Game(path: fileURL))
                    }
                    
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

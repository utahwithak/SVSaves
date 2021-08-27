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
    var games: [Game]
 
    private func refresh(with newSetting: URL?) {
        guard let url = newSetting else {
            canAccessUrl = false
            return
        }

        let resourceKeys = Set<URLResourceKey>([.nameKey, .isDirectoryKey])
        canAccessUrl = url.startAccessingSecurityScopedResource()
        games.removeAll()
        if canAccessUrl {
            
            defer {
                url.stopAccessingSecurityScopedResource()
            }
            
            if let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys:nil, options: [.skipsSubdirectoryDescendants]) {
                
                for case let fileURL as URL in enumerator {
                    guard let resourceValues = try? fileURL.resourceValues(forKeys: resourceKeys),
                          let isDirectory = resourceValues.isDirectory,
                          let name = resourceValues.name
                    else {
                        continue
                    }
                    
                    if isDirectory {
                        games.append(Game(name: name, url: fileURL))
                    }
                    
                }
            }
        }
        
        
        
    }
    
    
}

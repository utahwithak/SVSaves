//
//  Setting.swift
//  Setting
//
//  Created by Carl Wieland on 8/26/21.
//

import Foundation
import Combine

private var cancellables = [Setting : AnyCancellable]()

enum Setting: String {
    case stardewValleyFolderLocation
}

extension Published {
    
    init(wrappedValue defaultValue: Value, key: Setting) where Value: Codable {
        let value: Value
        if let data = UserDefaults.standard.object(forKey: key.rawValue) as? Data {
            do {
                value = try JSONDecoder().decode(Value.self, from: data)
            } catch {
                value = defaultValue
            }
        } else {
            value = defaultValue
        }
        
        self.init(initialValue: value)
        cancellables[key] = projectedValue.sink { val in
            
            guard let data = try? JSONEncoder().encode(val) else {
                return
            }
            
            UserDefaults.standard.set(data, forKey: key.rawValue)
        }
    }
    
    init(wrappedValue defaultValue: Value, key: Setting) where Value == URL? {
        let value: Value
        if let data = UserDefaults.standard.object(forKey: key.rawValue) as? Data {
            do {
                var isStale = false
                let decodedValue = try URL(resolvingBookmarkData: data, bookmarkDataIsStale: &isStale)
                
                if !isStale, decodedValue.startAccessingSecurityScopedResource() {
                    value = decodedValue
                    decodedValue.stopAccessingSecurityScopedResource()
                    
                } else {
                    // Handle stale data here.
                    value = defaultValue
                    
                }
                
            } catch {
                value = defaultValue
            }
        } else {
            value = defaultValue
        }
        
        self.init(initialValue: value)
        cancellables[key] = projectedValue.sink { newValue in
            guard let url = newValue else {
                UserDefaults.standard.removeObject(forKey: key.rawValue)
                return
            }
            // Start accessing a security-scoped resource.
            guard url.startAccessingSecurityScopedResource() else {
                UserDefaults.standard.removeObject(forKey: key.rawValue)
                return
            }
            defer { url.stopAccessingSecurityScopedResource() }

            guard let data = try? url.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil) else {
                UserDefaults.standard.removeObject(forKey: key.rawValue)
                return
            }
            
            UserDefaults.standard.set(data, forKey: key.rawValue)
        }
    }
}

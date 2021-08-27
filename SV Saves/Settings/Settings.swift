//
//  Settings.swift
//  Settings
//
//  Created by Carl Wieland on 8/26/21.
//

import Foundation
import SwiftUI


class Settings: ObservableObject {
    
    
    @Published(wrappedValue: nil, key: .stardewValleyFolderLocation)
    public var stardewValleyFolderLocation: URL?
    
    public var locationBinding: Published<URL?> {
        return _stardewValleyFolderLocation
    }
}

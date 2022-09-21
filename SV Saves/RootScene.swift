//
//  RootScene.swift
//  RootScene
//
//  Created by Carl Wieland on 8/26/21.
//

import Foundation
import SwiftUI

struct RootScene: Scene {

    @ObservedObject
    var settings = Settings()
    
    var body: some Scene {
        WindowGroup {
            if let manager = GameManager(settings: settings) {
                DirectoryView(manager: manager, settings: settings)
            } else {
                IntroView(settings: settings)
            }
        }
    }
    
}

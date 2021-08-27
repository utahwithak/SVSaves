//
//  RootScene.swift
//  RootScene
//
//  Created by Carl Wieland on 8/26/21.
//

import Foundation
import SwiftUI

struct RootScene: Scene {
    
    @State
    var hasShownIntro = false
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
    
}

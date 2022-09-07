//
//  RootScene.swift
//  RootScene
//
//  Created by Carl Wieland on 8/26/21.
//

import Foundation
import SwiftUI

struct RootScene: Scene {
    
    var body: some Scene {
        WindowGroup {
            IntroView(settings: Settings())
        }
    }
    
}

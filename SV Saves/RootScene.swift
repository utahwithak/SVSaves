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
    var rootViewModel: RootViewModel


    var body: some Scene {
        WindowGroup {
            if let manager = rootViewModel.manager {
                DirectoryView(manager: manager, settings: rootViewModel.settings)
            } else {
                IntroView(settings: rootViewModel.settings)
            }
        }
    }
    
}

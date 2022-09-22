//
//  SV_SavesApp.swift
//  SV Saves
//
//  Created by Carl Wieland on 7/6/21.
//

import SwiftUI

@main
struct SV_SavesApp: App {

    let viewModel: RootViewModel

    init() {
        viewModel = RootViewModel()
    }

    var body: some Scene {
        RootScene(rootViewModel: viewModel)
    }
}

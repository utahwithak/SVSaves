//
//  RootViewModel.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/22/22.
//

import Foundation
import Combine

@MainActor
class RootViewModel: ObservableObject {

    let settings = Settings()

    @Published
    var manager: GameManager?

    var subcription: AnyCancellable?

    init() {
        subcription = settings.$stardewValleyFolderLocation
            .receive(on: RunLoop.main)
            .sink {[weak self] _ in
            self?.updateManager()
        }
    }

    private func updateManager() {
        if manager == nil {
            manager = GameManager(settings: settings)
        }
    }
}

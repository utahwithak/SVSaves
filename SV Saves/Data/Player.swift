//
//  Player.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/7/22.
//

import Foundation
import Combine
import SDGParser

class Player: ObservableObject {
    let accessor: SDGParser.Player

    @Published
    var name: String

    @Published
    var farmName: String

    private var subscriptions = Set<AnyCancellable>()

    init(player: SDGParser.Player) {
        self.accessor = player

        name = accessor.name
        farmName = accessor.farmName

        $name.assign(to: \.name, on: accessor).store(in: &subscriptions)
        $farmName.assign(to: \.farmName, on: accessor).store(in: &subscriptions)
    }

}

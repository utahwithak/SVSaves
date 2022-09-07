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

    @Published
    var money: Int

    private var subscriptions = Set<AnyCancellable>()

    init(player: SDGParser.Player) {
        self.accessor = player

        name = accessor.name
        farmName = accessor.farmName
        money = accessor.money

        $name.assign(to: \.name, on: accessor).store(in: &subscriptions)
        $farmName.assign(to: \.farmName, on: accessor).store(in: &subscriptions)
        $money.assign(to: \.money, on: accessor).store(in: &subscriptions)
    }


}

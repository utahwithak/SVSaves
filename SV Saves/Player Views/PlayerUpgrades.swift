//
//  PlayerUpgrades.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/16/22.
//

import Foundation
import SwiftUI

struct PlayerUpgrades: View {
    @ObservedObject
    var player: Player
    init(player: Player) {
        self.player = player
    }

    var body: some View {
        List {
            Picker("Backpack Size", selection: $player.maxItems) {
                ForEach([12, 24, 36], id: \.self) {
                    Text("\($0)").tag($0)
                }
            }
            HStack {
                Text("Magnetic Radius")
                TextField("", value: $player.magneticRadius, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }

            HStack {
                Text("Trash Can Level")
                TextField("", value: $player.trashCanLevel, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }

            HStack {
                Text("House Upgrade Level")
                TextField("", value: $player.houseUpgradeLevel, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }

            HStack {
                Text("Days Until House Upgrade")
                TextField("", value: $player.daysUntilHouseUpgrade, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }

            HStack {
                Text("Days left for tool Upgrade")
                TextField("", value: $player.daysLeftForToolUpgrade, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }



        }.onTapGesture {

        }
    }
}

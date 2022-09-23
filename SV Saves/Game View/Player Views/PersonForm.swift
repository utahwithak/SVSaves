//
//  PersonForm.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/16/22.
//

import Foundation
import SwiftUI

struct PlayerInfo: View {

    @ObservedObject
    var player: Player

    var body: some View {

        HStack {
            Text("Player Name")
            TextField("Name", text: $player.name)
                .multilineTextAlignment(.trailing)
        }
        HStack {
            Text("Farm Name")
            TextField("Name", text: $player.farmName)
                .multilineTextAlignment(.trailing)
        }
        HStack {
            Text("Favorite Thing")
            TextField("Name", text: $player.favoriteThing)
                .multilineTextAlignment(.trailing)
        }

        HStack {
            Text("Money")
            TextField("", value: $player.money, format: .number)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
        }

        HStack {
            Text("Club Coins")
            TextField("", value: $player.clubCoins, format: .number)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
        }


    }

}

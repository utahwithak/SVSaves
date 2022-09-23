//
//  PlayerStatsView.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/23/22.
//

import Foundation

import SwiftUI

struct PlayerStatsVIew: View {

    @ObservedObject
    var player: Player

    var body: some View {
        Toggle(isOn: $player.isMale) {
            Text("Male")
        }

        HStack {
            Text("Health")
            TextField("", value: $player.health, format: .number)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
        }

        HStack {
            Text("Max Health")
            TextField("", value: $player.maxHealth, format: .number)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
        }

        HStack {
            Text("Stamina")
            TextField("", value: $player.stamina, format: .number)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
        }
        HStack {
            Text("Max Stamina")
            TextField("", value: $player.maxStamina, format: .number)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
        }
        HStack {
            Text("Speed")
            TextField("", value: $player.speed, format: .number)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
        }

    }
}

//
//  AttackViews.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/16/22.
//

import Foundation
import SwiftUI

struct AttackView: View {

    @ObservedObject
    var player: Player
    init(player: Player) {
        self.player = player
    }

    var body: some View {
        List {

                HStack {
                    Text("Attack")
                    TextField("", value: $player.attack, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }

            HStack {
                Text("Immunity")
                TextField("", value: $player.immunity, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }

            HStack {
                Text("Attach Increase Modifier")
                TextField("", value: $player.attackIncreaseModifier, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }

            HStack {
                Text("Knockback Modifier")
                TextField("", value: $player.knockbackModifier, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }

            HStack {
                Text("Weapon Speed Modifier")
                TextField("", value: $player.weaponSpeedModifier, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }
            HStack {
                Text("Crit Chance Modifier")
                TextField("", value: $player.critChanceModifier, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }

            HStack {
                Text("Crit Power Modifier")
                TextField("", value: $player.critPowerModifier, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }
        }.onTapGesture {

        }
    }
}

//
//  WeatherView.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/23/22.
//

import Foundation
import SwiftUI

struct WeatherView: View {

    @ObservedObject
    var game: Game

    var body: some View {
        Toggle(isOn: $game.isRaining) {
            Text("Is Raining")
        }

        Toggle(isOn: $game.bloomDay) {
            Text("Bloom Day")
        }

        Toggle(isOn: $game.isLightning) {
            Text("Is Lightning")
        }

        Toggle(isOn: $game.isSnowing) {
            Text("Is Snowing")
        }

        HStack {
            Text("Chance of Rain")
            TextField("Value", value: $game.chanceToRainTomorrow, format:.number)
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)

        }
    }
}

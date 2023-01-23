//
//  GameDataView.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/23/22.
//

import Foundation
import SwiftUI
import SDGParser

struct GameDataView: View {

    @ObservedObject
    var game: Game

    var body: some View {
        if game.accessor.is156OrGreater {
            HStack {
                Text("Golden Walnuts")
                TextField("", value: $game.goldenWalnuts, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }
        }

        dateView

        namesView

        Toggle(isOn: $game.parrotPlatformsUnlocked) {
            Text("Parrot Platforms Unlocked")
        }

        HStack {
            Text("Daily Luck")
            TextField("luck value", value: $game.dailyLuck, format:.number)
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)

        }

        Toggle(isOn: $game.shippingTax) {
            Text("Shipping Tax")
        }

        Toggle(isOn: $game.shouldSpawnMonsters) {
            Text("Should Spawn Monsters")
        }

        if game.accessor.is156OrGreater {
            Toggle(isOn: $game.farmPerfect) {
                Text("Farm Perfect")
            }

            Toggle(isOn: $game.parrotPlatformsUnlocked) {
                Text("Parrot Platforms Unlocked")
            }
            HStack {
                Text("Vists Until Y1 Guarantee")
                TextField("", value: $game.visitsUntilY1Guarantee, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }

        }

        if let communityCenter = game.communityCenter {
            NavigationLink {
                BundleDataView(bundleData: game.bundleData, communityCenter: communityCenter)
            } label: {
                Text("Bundle Data")
            }
        }


    }

    @ViewBuilder
    var dateView: some View {

        Picker("Current Season", selection: $game.season) {
            ForEach(Season.allCases) {
                Text($0.displayName).tag($0)
            }
        }

        HStack {
            Text("Current Year")
            TextField("year", value: $game.year, format: .number)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)

        }
        HStack {
            Text("Day of Month")
            TextField("day", value: $game.dayOfMonth, format: .number)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)

        }

        Picker("Farm Type", selection: $game.farmType) {
            ForEach(FarmType.allCases) {
                Text($0.displayName).tag($0)
            }
        }
    }

    @ViewBuilder
    var namesView: some View {

        HStack {
            Text("Sam's Band Name")
            TextField("name", text: $game.samBandName)
                .multilineTextAlignment(.trailing)

        }
        HStack {
            Text("Elliot's Book Name")
            TextField("name", text: $game.elliottBookName)
                .multilineTextAlignment(.trailing)

        }
    }
}

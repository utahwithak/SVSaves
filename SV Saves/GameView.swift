//
//  GameView.swift
//  GameView
//
//  Created by Carl Wieland on 8/27/21.
//

import Foundation
import SwiftUI
import SDGParser

struct GameView: View {
    @ObservedObject
    var game: Game

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State
    var promptForRestoreOldFile: Bool = false

    @State
    var promptForRestoreFromBackup: Bool = false

    var body: some View {

        Form {

            Section {
                Picker("Farm Type", selection: $game.farmType) {
                    ForEach(FarmType.allCases) {
                        Text($0.displayName).tag($0)
                    }
                }

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
            } header: {
                Text("Game")
            }

            Section {
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
            } header: {
                Text("Weather")
            }

            Section {
                PlayerForm(player: game.player)
                AttackView(player: game.player)
                PlayerUpgrades(player: game.player)
                ExperienceView(player: game.player)
            } header: {
                Text("Player")
            }

            Section {

                HStack {
                    Text("Game Version")
                    Spacer()
                    Text(game.accessor.gameVersion)
                }

                if game.canBackupToiCloud {
                    Button {
                        game.backupGame()
                    } label: {
                        Text("Backup Game Folder")
                    }
                }

                Button {
                    promptForRestoreOldFile = true
                } label: {
                    Text("Restore from _old file")
                        .foregroundColor(.red)
                }

                if game.hasBackedupVersion {
                    Button {
                        promptForRestoreFromBackup = true
                    } label: {
                        Text("Restore from backup files")
                            .foregroundColor(.red)
                    }
                }


            } header: {
                Text("Misc")
            }
        }
        .navigationTitle($game.player.farmName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: discardEdits){
            Text("Cancel")
        }, trailing: Button(action: saveGame){
            Text("Save")
        })
        .alert("Are you sure you want to restore from the _old file?", isPresented: $promptForRestoreOldFile) {
            Button("Cancel", role: .cancel) { }

            Button("Restore", role: .destructive) {
                game.restoreOldFile()
            }

        }
    }

    let doubleFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        return formatter
    }()

    private func discardEdits() {
        Task {
            do {
                try await game.reload()
                presentationMode.wrappedValue.dismiss()
            } catch {
                print("Failed to reload:\(error)")
            }
        }
    }

    private func saveGame() {
        do {
            try game.saveGame()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Failed to save game")
        }


    }
}


//struct GameView_Previews: PreviewProvider {
//    static var previews: some View {
////        GameView(game: Game(path: URL(fileURLWithPath: <#T##String#>)))
//    }
//}

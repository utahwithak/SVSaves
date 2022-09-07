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

    var body: some View {

        Form {

            Section(header: Text("Game")) {
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
            }

            Section(header: Text("Player")) {
                HStack {
                    Text("Farm Name")
                    TextField("Name", text: $game.player.farmName)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Player Name")
                    TextField("Name", text: $game.player.name)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("Money")
                    TextField("", value: $game.player.money, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
            }

            Section(header: Text("Misc")) {
                HStack {
                    Text("Chance of Rain")
                    TextField("Value", value: $game.chanceToRainTomorrow, format:.number)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }
                HStack {
                    Text("Game Version")
                    Text(game.accessor.gameVersion)
                        .multilineTextAlignment(.trailing)

                }
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

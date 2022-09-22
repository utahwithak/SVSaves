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

    @ObservedObject
    var settings: Settings

    init(game: Game, settings: Settings) {
        self.game = game
        self.settings = settings
    }

    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>

    @State
    var promptForRestoreOldFile: Bool = false

    @State
    var promptForRestoreFromBackup: Bool = false

    @State
    var promptForSaveBackup: Bool = false

    @State
    var showBackups: Bool = false

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
                        game.backupGame(to: .iCloud)
                    } label: {
                        Text("Backup Game to iCloud")
                    }
                    Button {
                        game.backupGame(to: .local)
                    } label: {
                        Text("Backup Game Locally")
                    }
                } else {
                    Button {
                        game.backupGame(to: .default)
                    } label: {
                        Text("Backup Game")
                    }
                }

                Button {
                    promptForRestoreOldFile = true
                } label: {
                    Text("Restore from _old file")
                        .foregroundColor(.red)
                }

                if !game.backups.isEmpty {
                    Button {
                        showBackups = true
                    } label: {
                        Text("Restore from Backups")
                    }
                }
            } header: {
                Text("Misc")
            }
        }
        .navigationTitle($game.player.farmName)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()

                Button("Done") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                    to: nil, from: nil, for: nil)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {

                if game.isDirty {
                    Button(action: discardEdits){
                        Text("Cancel")
                    }
                } else {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Done")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button {
                        shareGame()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    if game.isDirty {
                        Button {
                            checkSave()
                        } label: {
                            Text("Save")
                        }
                    }
                }
            }


        }
        .alert("Are you sure you want to restore from the _old file?", isPresented: $promptForRestoreOldFile) {
            Button("Cancel", role: .cancel) { }

            Button("Restore", role: .destructive) {
                game.restoreOldFile()
            }

        }
        .alert("Create backup before saving?", isPresented: $promptForSaveBackup) {
            Button("Backup") {
                game.backupGame()
                saveGame()
            }
            Button("Always Backup", role: .cancel) {
                settings.shouldAlwaysBackupBeforeSave = true
                game.backupGame()
                saveGame()
            }

            Button("Just Save", role: .destructive) {
                saveGame()
            }

        }
        .sheet(isPresented: $showBackups) {
            BackupView(game: game)

        }

    }

    let doubleFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        return formatter
    }()


    private func checkSave() {
        if !settings.shouldAlwaysBackupBeforeSave {
            promptForSaveBackup = true
        } else {
            game.backupGame()
            saveGame()
        }
    }

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
        } catch {
            print("Failed to save game")
        }

        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                to: nil, from: nil, for: nil)
    }

    private func shareGame() {
        Task { @MainActor in
            showShareSheet(gameArchive: game.path)
        }
    }
    func showShareSheet(gameArchive: URL) {
        let activityVC = UIActivityViewController(activityItems: [gameArchive], applicationActivities: nil)
        if let last = UIApplication.shared.currentUIWindow()?.rootViewController {
            last.present(activityVC, animated: true, completion: nil)
        }
    }


}
private extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }

        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }

        return window

    }
}

//struct GameView_Previews: PreviewProvider {
//    static var previews: some View {
////        GameView(game: Game(path: URL(fileURLWithPath: <#T##String#>)))
//    }
//}

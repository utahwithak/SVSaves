//
//  GameView.swift
//  GameView
//
//  Created by Carl Wieland on 8/27/21.
//

import Foundation
import SwiftUI
import SDGParser


enum GameViewContent: Int, Identifiable, Hashable, CaseIterable {


    case playerInfo
    case inventory
    case friendship
    case experience
    case combat
    case playerStats
    case upgrades
    case weather
    case gameData
    case backups
case misc

    var id: Int {
        rawValue
    }

    var title: String {
        switch self {
        case .gameData:
            return "Game Data"
        case .weather:
            return "Weather"
        case .playerStats:
            return "Stats"
        case .playerInfo:
            return "Player Info"
        case .inventory:
            return "Backpack"
        case .friendship:
            return "Relationships"
        case .experience:
            return "Experience"
        case .combat:
            return "Combat"
        case .backups:
            return "Backups"
        case .upgrades:
            return "Upgrades"
        case .misc:
            return "Misc"
        }
    }
}

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
    var promptForSaveBackup: Bool = false

    let content: [GameViewContent] = [.gameData, .weather]

    var body: some View {

        Form {

            ForEach(GameViewContent.allCases) { content in
                Section {
                    switch content {
                    case .gameData:
                        GameDataView(game: game)
                    case .weather:
                        WeatherView(game: game)
                    case .playerStats:
                        PlayerStatsVIew(player: game.player)
                    case .playerInfo:
                        PlayerInfo(player: game.player)
                    case .inventory:
                        PlayerBackpackView(player: game.player)
                    case .friendship:
                        PlayerRelationshipView(player: game.player)
                    case .experience:
                        ExperienceView(player: game.player)
                    case .combat:
                        AttackView(player: game.player)
                    case .upgrades:
                        PlayerUpgrades(player: game.player)
                    case .backups:
                        GameBackupSectionView(game: game)
                    case .misc:
                        GameViewExtras(game: game)
                    }
                } header: {
                    Text(content.title)
                }
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

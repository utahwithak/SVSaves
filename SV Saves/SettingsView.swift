//
//  SettingsView.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/20/22.
//

import Foundation
import SwiftUI

struct SettingsView: View {

    @ObservedObject
    var settings: Settings

    let manager: GameManager

    @State
    var verifyRemoveAll = false

    init(gameManager: GameManager, settings: Settings) {
        self.manager = gameManager
        self.settings = settings
    }

    var body: some View {

        NavigationView {
            Form {
                Section {
                    Toggle(isOn: $settings.shouldAlwaysBackupBeforeSave) {
                        Text("Always backup before save")
                    }
                } header: {
                    Text("Save Settings")
                }

//                Section {
//                    Button {
//                        restorePurchases()
//                    } label: {
//                        Text("Restore Purchases")
//                    }
//
//                    Button {
//                        unlockPro()
//                    } label: {
//                        Text("Purchase Unlimited Edits")
//                    }
//
//                    Button {
//                        subscribe()
//                    } label: {
//                        Text("1 Year Unlimited Edits")
//                    }
//
//
//                } header: {
//                    Text("Purchases")
//                }

                Section {
                    Toggle(isOn: $settings.shouldBackupToiCloud) {
                        Text("Backup to iCloud")
                    }

                    Button {
                        backupAllGames()
                    } label: {
                        Text("Backup all Games")

                    }

                    Button {
                        verifyRemoveAll = true
                    } label: {
                        Text("Remove all Backups")
                            .foregroundColor(Color(uiColor: .systemRed))
                    }

                } header: {
                    Text("Backups")
                }


                
            }
            .alert("Are you sure you want remove all backups?", isPresented: $verifyRemoveAll, actions: {
                Button(role: .cancel) {
                } label: {
                    Text("Cancel")
                }

                Button(role: .destructive) {
                    removeAllBackups()
                } label: {
                    Text("Remove All")
                }
            }, message: {
                Text("This operation cannot be undone")
            })
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }

    func restorePurchases() {

    }

    func unlockPro() {

    }

    func subscribe() {
        
    }

    func removeAllBackups() {
        manager.removeAllBackups()
    }

    func backupAllGames() {
        manager.backupAllGames()
    }
}


#if DEBUG

struct SettingsPreview: PreviewProvider {
    static let settings: Settings = {
        let s = Settings()
        s.stardewValleyFolderLocation = URL(string: "/usr/dev/null")
        return s
    }()

    static var previews: some View {
        SettingsView(gameManager: GameManager(settings: settings)!, settings: settings)
    }
}

#endif

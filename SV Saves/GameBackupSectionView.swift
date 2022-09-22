//
//  GameBackupSectionView.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/22/22.
//

import Foundation
import SwiftUI

struct GameBackupSectionView: View {

    @ObservedObject
    var game: Game


    @State
    var promptForRestoreOldFile: Bool = false

    @State
    var showBackups: Bool = false

    init(game: Game) {
        self.game = game
    }

    var body: some View {
        List {
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

        }
        .alert("Are you sure you want to restore from the _old file?", isPresented: $promptForRestoreOldFile) {
            Button("Cancel", role: .cancel) { }

            Button("Restore", role: .destructive) {
                game.restoreOldFile()
            }

        }
        .sheet(isPresented: $showBackups) {
            BackupView(game: game)

        }
    }
}

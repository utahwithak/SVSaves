//
//  BackupView.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/21/22.
//

import Foundation
import SwiftUI

struct BackupView: View {

    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>


    @State
    var promptForRestoreFile: Bool = false

    @ObservedObject
    var game: Game

    let backups: [Backup]

    var hasBoth: Bool {
        backups.contains { $0.isLocal } && backups.contains { !$0.isLocal }
    }

    @State
    var currentBackup: Backup?

    enum FilterType: Int {
        case local
        case iCloud
        case both

    }

    @State
    var filterType: FilterType = .both

    init(game: Game) {
        self.backups = game.backups
        self.game = game
    }

    var filteredBackups: [Backup] {
        switch filterType {
        case .both: return backups
        case .local: return backups.filter({ $0.isLocal })
        case .iCloud: return backups.filter({ !$0.isLocal })
        }
    }

    var body: some View {
        let hasBackup = Binding<Bool>(
            get: {
            currentBackup != nil
        }, set: { _ in
            currentBackup = nil
        })

        NavigationView {
            VStack {
                if hasBoth {
                    Picker("", selection: $filterType) {
                        Text("All").tag(FilterType.both)
                        Text("Local").tag(FilterType.local)
                        Text("iCloud").tag(FilterType.iCloud)
                    }
                    .pickerStyle(.segmented)
                    .padding([.leading, .trailing, .top])

                }
                List(filteredBackups) { backup in
                    Button {
                       currentBackup = backup
                    } label: {
                        Label(backup.name, systemImage: backup.isLocal ? "folder" : "icloud" )
                    }
                }
            }
            .alert(Text("Are you sure you want to restore file?"), isPresented: hasBackup, presenting: currentBackup, actions: { backup in
                Button("Cancel", role: .cancel) { }

                Button("Restore", role: .destructive) {
                    restoreGame(from: backup)
                }
            }, message: { _ in
                Text("Current save file will be overwritten, this cannot be undone.")
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Backups")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }

                }
            }
        }
        .navigationViewStyle(.stack)
    }

    func restoreGame(from backup: Backup){
        game.restoreGame(from: backup)

        presentationMode.wrappedValue.dismiss()
    }
}

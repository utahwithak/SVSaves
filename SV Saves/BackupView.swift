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

    @ObservedObject
    var game: Game

    let backups: [Backup]

    var hasBoth: Bool {
        backups.contains { $0.isLocal } && backups.contains { !$0.isLocal }
    }

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
        NavigationStack {
            VStack {
                if hasBoth {
                    Picker("", selection: $filterType) {
                        Text("All").tag(FilterType.both)
                        Text("Local").tag(FilterType.local)
                        Text("iCloud").tag(FilterType.iCloud)
                    }
                    .pickerStyle(.segmented)

                }
                List(filteredBackups) { backup in
                    Button {
                        restoreGame(from: backup)
                    } label: {
                        Label(backup.name, systemImage: backup.isLocal ? "folder" : "icloud" )
                    }
                }
            }
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
    }

    func restoreGame(from backup: Backup){
        game.restoreGame(from: backup)

        presentationMode.wrappedValue.dismiss()
    }
}

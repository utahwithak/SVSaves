//
//  DirectoryView.swift
//  DirectoryView
//
//  Created by Carl Wieland on 8/27/21.
//

import Foundation
import SwiftUI

struct DirectoryView: View {
    
    @ObservedObject
    var manager: GameManager
    
    @ObservedObject
    var settings: Settings
    
    @State
    private var showDocumentPicker = false

    @State
    private var showSettings = false

    @State var showHelp: Bool = false

    init(manager: GameManager, settings: Settings) {
        self.manager = manager
        self.settings = settings

    }

    var body: some View {
        
        NavigationView {
            VStack {
                if manager.canAccessUrl {
                    if manager.isLoading {
                        ProgressView {
                            Text("Loading Games")
                        }
                    } else {
                        if manager.games.isEmpty {
                            Text("No games found in current folder. Choose a different folder to check")
                                .padding()
                                .multilineTextAlignment(.center)
                            Text("Look for a Stardew Valley folder stored on the device. Open that folder and press Done ")
                                .padding()
                                .multilineTextAlignment(.center)
                            Button("Choose Stardew Valley Folder") {
                                showDocumentPicker = true
                            }
                        } else {
                            List {
                                ForEach(manager.games) { game in
                                    NavigationLink(destination: GameView(game: game, settings: settings)) {
                                        GameRowView(game: game)
                                    }
                                }
                            }.refreshable {
                                manager.refresh()
                            }
                        }
                    }
                }
                else {
                    Button("Choose Stardew Valley Folder") {
                        showDocumentPicker = true
                    }
                }
            }.onAppear {
                if !settings.hasSeenHelp {
                    showHelp = true
                }
            }
            .fileImporter(isPresented: $showDocumentPicker, allowedContentTypes: [.folder], onCompletion: { result in
                switch result {
                case .success(let url):
                    settings.stardewValleyFolderLocation = url
                case .failure(let error):
                    print("Failed to choose folder: \(error)")
                }
            })
            .navigationBarTitle(Text("Games"))
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        showDocumentPicker = true
                    }) {
                        Image(systemName: "folder.badge.plus")
                    }
                }

                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "gearshape")
                    }
                    Button(action: {
                        showHelp = true
                    }) {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(gameManager: manager, settings: settings)
            }
            .sheet(isPresented: $showHelp) {
                HelpView(settings: settings)
            }
            
        }
        .navigationViewStyle(.stack)
        
    }
}

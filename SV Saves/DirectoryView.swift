//
//  DirectoryView.swift
//  DirectoryView
//
//  Created by Carl Wieland on 8/27/21.
//

import Foundation
import SwiftUI

struct DirectoryView: View {
    
    @ObservedObject var manager: GameManager
    
    @ObservedObject var settings: Settings
    
    @State private var showDocumentPicker = false
    
    var body: some View {
        
        NavigationStack {
            VStack {
                if manager.canAccessUrl {
                    List {
                        ForEach(manager.games) { game in
                            NavigationLink(destination: GameView(game: game)) {
                                GameRowView(game: game)
                            }
                        }
                    }.refreshable {
                        manager.refresh()
                    }
                }
                else {
                    Button("Choose Stardew Valley Folder") {
                        showDocumentPicker = true
                    }
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
            }
            
        }

        //        .sheet(isPresented: $showDocumentPicker) {
        //            print("Dismissed")
        //        } content: {
        //            DocumentPicker(pickedPath: $settings.stardewValleyFolderLocation)
        //        }
        //
        
    }
}

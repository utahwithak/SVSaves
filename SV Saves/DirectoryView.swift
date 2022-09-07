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
            } .navigationBarTitle(Text("Games"))
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
        .fileImporter(isPresented: $showDocumentPicker, allowedContentTypes: [.folder], onCompletion: { result in

        })
//        .sheet(isPresented: $showDocumentPicker) {
//            print("Dismissed")
//        } content: {
//            DocumentPicker(pickedPath: $settings.stardewValleyFolderLocation)
//        }
//        
        
    }
}

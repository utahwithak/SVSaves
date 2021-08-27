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
        VStack {
            
            if manager.canAccessUrl {
                
                ForEach(manager.games) { result in
                    Text("Result: \(result.name)")
                }
            } else {
                Button("Choose Stardew Valley Folder") {
                    showDocumentPicker = true
                }
            }
            
        }.sheet(isPresented: $showDocumentPicker) {
            print("Dismissed")
        } content: {
            DocumentPicker(pickedPath: $settings.stardewValleyFolderLocation)
        }
        
    }
}

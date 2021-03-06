//
//  IntroView.swift
//  IntroView
//
//  Created by Carl Wieland on 8/26/21.
//

import Foundation
import SwiftUI

struct IntroView: View {
    
    @State private var showDocumentPicker = false
    
    @ObservedObject var settings: Settings
    
    var body: some View {
        VStack {
            if settings.stardewValleyFolderLocation != nil {
                DirectoryView(manager: GameManager(rootURL: settings.locationBinding), settings: settings)
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

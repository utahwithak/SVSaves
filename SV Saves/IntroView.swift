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
            if let location = settings.stardewValleyFolderLocation {
                DirectoryView(manager: GameManager(url: location, publisher: settings.$stardewValleyFolderLocation.eraseToAnyPublisher()), settings: settings)
            } else {
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
    }
}

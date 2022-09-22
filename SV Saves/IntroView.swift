//
//  IntroView.swift
//  IntroView
//
//  Created by Carl Wieland on 8/26/21.
//

import Foundation
import SwiftUI

struct IntroView: View {
    
    @State
    private var showDocumentPicker = false
    
    @ObservedObject
    var settings: Settings

    @State
    private var folderError: Error?

    var body: some View {
        VStack {
            Text("SV Saves allows editing of Stardew Valley 1.4.5 save games.")
                .multilineTextAlignment(.center)
                .padding()
            Text("Editing may cause unexepcted results and result in unplayable games.")
                .foregroundColor(.red)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text("In order to edit the games choose the folder on your device where your Stardew Valley games are.")
                .multilineTextAlignment(.center)
                .padding()

            Button("Choose 'Stardew Valley' Folder") {
                showDocumentPicker = true
            }
        }
        .fileImporter(isPresented: $showDocumentPicker, allowedContentTypes: [.folder], onCompletion: { result in
            switch result {
            case .success(let url):
                settings.stardewValleyFolderLocation = url
            case .failure(let error):
                Log.error("Failed to choose folder: \(error)")
            }
        })
    }
}

#if DEBUG

struct IntroPreview: PreviewProvider {

    static var previews: some View {
        IntroView(settings: Settings())
    }


}
#endif

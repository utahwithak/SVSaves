//
//  DocumentPicker.swift
//  DocumentPicker
//
//  Created by Carl Wieland on 8/26/21.
//

import Foundation
import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var pickedPath: URL?
    
    func makeCoordinator() -> DocumentPickerCoordinator {
        return DocumentPickerCoordinator(fileURL: $pickedPath)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: [.folder], asCopy: false)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}


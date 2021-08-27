//
//  DocumentPickerCoordinator.swift
//  DocumentPickerCoordinator
//
//  Created by Carl Wieland on 8/26/21.
//

import Foundation
import SwiftUI

class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    @Binding var fileURL: URL?
    
    init(fileURL: Binding<URL?>) {
        _fileURL = fileURL
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        fileURL = urls.first
    }
}

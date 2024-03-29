//
//  Filemanager+Extensions.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/9/22.
//

import Foundation
extension FileManager {
    var containerUrl: URL? {
        return url(forUbiquityContainerIdentifier: nil)
    }

    func createBackupFolderIfNeeded() {
        // check for container existence
        if let url = containerUrl, !fileExists(atPath: url.path, isDirectory: nil) {
            do {
                try createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }

    public var documentsDirectory: URL {
        try! url(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }

}


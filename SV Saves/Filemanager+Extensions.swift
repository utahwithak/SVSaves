//
//  Filemanager+Extensions.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/9/22.
//

import Foundation
extension FileManager {
    var containerUrl: URL? {
        return url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Backup Games")
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
}


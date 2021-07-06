//
//  SV_SavesApp.swift
//  SV Saves
//
//  Created by Carl Wieland on 7/6/21.
//

import SwiftUI

@main
struct SV_SavesApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: SV_SavesDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}

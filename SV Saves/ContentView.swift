//
//  ContentView.swift
//  SV Saves
//
//  Created by Carl Wieland on 7/6/21.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: SV_SavesDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(SV_SavesDocument()))
    }
}

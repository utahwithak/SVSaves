//
//  GameViewExtras.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/23/22.
//

import Foundation
import SwiftUI

struct GameViewExtras: View {

    @ObservedObject
    var game: Game

    var body: some View {

        HStack {
            Text("Game Version")
            Spacer()
            Text(game.accessor.gameVersion)
                .foregroundColor(Color(uiColor: .lightGray))
        }
    }
}

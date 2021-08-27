//
//  GameView.swift
//  GameView
//
//  Created by Carl Wieland on 8/27/21.
//

import Foundation
import SwiftUI


struct GameRowView: View {

    let game: Game
    
    var body: some View {
        Text(game.name)
    }
    
}

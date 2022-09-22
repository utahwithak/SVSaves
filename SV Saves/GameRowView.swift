//
//  GameView.swift
//  GameView
//
//  Created by Carl Wieland on 8/27/21.
//

import Foundation
import SwiftUI


struct GameRowView: View {
    
    @ObservedObject
    var game: Game
    
    var body: some View {
        VStack {
            HStack {
                Text(game.player.farmName)
                if !game.player.name.isEmpty {
                    Text(" - ")
                    Text(game.player.name)
                }
            }

        }
        
    }
}

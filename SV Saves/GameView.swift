//
//  GameView.swift
//  GameView
//
//  Created by Carl Wieland on 8/27/21.
//

import Foundation
import SwiftUI


struct GameView: View {
    @ObservedObject var game: Game
    
    
    
    var body: some View {
        VStack {
            Text(game.farmName)
        }
    }
}

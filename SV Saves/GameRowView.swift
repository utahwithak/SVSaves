//
//  GameView.swift
//  GameView
//
//  Created by Carl Wieland on 8/27/21.
//

import Foundation
import SwiftUI


struct GameRowView: View {
    
    @ObservedObject var game: Game
    
    var body: some View {
        VStack {
            if game.isLoading {
                ProgressView()
            } else {
                Text(game.farmName)
                
            }
        }.onAppear {
            Task {
                await game.loadName()
            }
        }
        
    }
}

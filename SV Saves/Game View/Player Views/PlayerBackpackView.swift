//
//  PlayerInventorySection.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/23/22.
//

import Foundation
import SwiftUI

struct PlayerBackpackView: View {
    
    @ObservedObject
    var player: Player
    
    var body: some View {
        Picker("Size", selection: $player.maxItems) {
            ForEach([12, 24, 36], id: \.self) {
                Text("\($0)")
                    .padding()
                    .tag($0)
            }
        }
        NavigationLink("Contents") {
            InventoryView(inventory: player.inventory)
        }
    }
}

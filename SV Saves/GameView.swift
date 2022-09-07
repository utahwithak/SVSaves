//
//  GameView.swift
//  GameView
//
//  Created by Carl Wieland on 8/27/21.
//

import Foundation
import SwiftUI


struct GameView: View {
    @ObservedObject
    var game: Game
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        Form {
            Section(header: Text("Farm")) {
                HStack {
                    Text("Farm Name")
                    TextField("Name", text: $game.player.farmName).multilineTextAlignment(.trailing)
                }
            }
        }
        .navigationTitle($game.player.farmName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: discardEdits){
            Text("Cancel")
        }, trailing: Button(action: saveGame){
            Text("Save")
        })
        .toolbar {
            
            ToolbarItem {
                
            }
            
        }
        
    }
    
    private func discardEdits() {
        Task {
            do {
                try await game.reload()
                presentationMode.wrappedValue.dismiss()
            } catch {
                print("Failed to reload:\(error)")
            }
        }
    }
    
    private func saveGame() {
        do {
            try game.saveGame()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Failed to save game")
        }
        
        
    }
}


//struct GameView_Previews: PreviewProvider {
//    static var previews: some View {
////        GameView(game: Game(path: URL(fileURLWithPath: <#T##String#>)))
//    }
//}

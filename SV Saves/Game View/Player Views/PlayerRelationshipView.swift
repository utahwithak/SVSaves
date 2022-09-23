//
//  PlayerRelationshipView.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/23/22.
//

import Foundation
import SwiftUI

struct PlayerRelationshipView: View {

    @ObservedObject
    var player: Player

    var body: some View {
        if !player.friendshipData.friendships.isEmpty {
            NavigationLink("Friendship Data") {
                FriendshipView(data: player.friendshipData)
            }
        }

        Toggle(isOn: $player.catPerson) {
            Text("Has Cat")
        }

        HStack {
            Text("Pet Breed")
            TextField("", value: $player.whichPetBreed, formatter: BoundFormatter(min: 0, max: 2))
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
        }
    }
}

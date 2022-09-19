//
//  PersonForm.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/16/22.
//

import Foundation
import SwiftUI

struct PlayerForm: View {

    @ObservedObject
    var player: Player
    init(player: Player) {
        self.player = player
    }

    var body: some View {
        List {
            Group {
                HStack {
                    Text("Player Name")
                    TextField("Name", text: $player.name)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Farm Name")
                    TextField("Name", text: $player.farmName)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Favorite Thing")
                    TextField("Name", text: $player.favoriteThing)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("Money")
                    TextField("", value: $player.money, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }


            }

            NavigationLink("Inventory") {
                InventoryView(inventory: player.inventory)
            }

            if !player.friendshipData.friendships.isEmpty {
                NavigationLink("Friendship Data") {
                    FriendshipView(data: player.friendshipData)
                }
            }

            Group {
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

            Group {
                Toggle(isOn: $player.isMale) {
                    Text("Male")
                }

                HStack {
                    Text("Health")
                    TextField("", value: $player.health, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("Max Health")
                    TextField("", value: $player.maxHealth, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("Max Stamina")
                    TextField("", value: $player.maxStamina, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Speed")
                    TextField("", value: $player.speed, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }

            }
        }.onTapGesture {

        }
    }
}

//
//  ExperienceView.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/16/22.
//

import Foundation
import SwiftUI

struct ExperienceView: View {
    @ObservedObject
    var player: Player

    @ObservedObject
    var experience: ExperiencePoints

    init(player: Player) {
        self.player = player
        experience = player.experiencePoints
    }

    var body: some View {
        List {
            ExperienceRowView(type: "Farming", level: $player.farmingLevel, experience: $experience.farmingExperience, addedLevel: $player.addedFarmingLevel)

            ExperienceRowView(type: "Mining", level: $player.miningLevel, experience: $experience.miningExperience, addedLevel: $player.addedMiningLevel)

            ExperienceRowView(type: "Foraging", level: $player.foragingLevel, experience: $experience.foragingExperience, addedLevel: $player.addedForagingLevel)

            ExperienceRowView(type: "Fishing", level: $player.fishingLevel, experience: $experience.fishingExperience, addedLevel: $player.addedFishingLevel)

            ExperienceRowView(type: "Combat", level: $player.combatLevel, experience: $experience.combatExperience, addedLevel: $player.addedCombatLevel)

        }.onTapGesture {
            
        }
    }
}

struct ExperienceRowView: View {

    let title: String

    var level: Binding<Int>

    var experience: Binding<Int>

    var addedLevel: Binding<Int>

    init(type: String, level: Binding<Int>, experience: Binding<Int>, addedLevel: Binding<Int> ) {
        self.title = type
        self.level = level
        self.experience = experience
        self.addedLevel = addedLevel
    }

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .frame(minWidth: 100)
            VStack {
                HStack {
                    Text("Level")
                    Spacer()
                    TextField("", value: level, formatter: BoundFormatter(min: 0, max: 10))
                        .textFieldStyle(.plain)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)

                }
                HStack {
                    Text("Experience")
                    TextField("", value: experience, formatter: BoundFormatter(min: 0, max: 15000))
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Added Levels")
                    Spacer()
                    TextField("", value: addedLevel, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)

                }
            }
        }
    }
}

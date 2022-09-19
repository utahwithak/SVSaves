//
//  ExperiencePoints.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/16/22.
//

import Combine
import Foundation
import SDGParser

class ExperiencePoints: ObservableObject {

    let experiencePoints: SDGParser.ExperiencePoints

    
    var subscriptions = Set<AnyCancellable>()

    init( experiencePoints: SDGParser.ExperiencePoints) {
        self.experiencePoints = experiencePoints
        farmingExperience = experiencePoints.farmingExperience
        miningExperience = experiencePoints.miningExperience
        foragingExperience = experiencePoints.foragingExperience
        fishingExperience = experiencePoints.fishingExperience
        combatExperience = experiencePoints.combatExperience

        $farmingExperience.assign(to: \.farmingExperience, on: experiencePoints).store(in: &subscriptions)
        $miningExperience.assign(to: \.miningExperience, on: experiencePoints).store(in: &subscriptions)
        $foragingExperience.assign(to: \.foragingExperience, on: experiencePoints).store(in: &subscriptions)
        $fishingExperience.assign(to: \.fishingExperience, on: experiencePoints).store(in: &subscriptions)
        $combatExperience.assign(to: \.combatExperience, on: experiencePoints).store(in: &subscriptions)
    }

    @Published
    var farmingExperience: Int

    @Published
    var miningExperience: Int

    @Published
    var foragingExperience: Int

    @Published
    var fishingExperience: Int

    @Published
    var combatExperience: Int


}

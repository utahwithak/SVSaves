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

    @Published
    var isDirty: Bool = false

    init(experiencePoints: SDGParser.ExperiencePoints) {
        self.experiencePoints = experiencePoints
        farmingExperience = experiencePoints.farmingExperience
        miningExperience = experiencePoints.miningExperience
        foragingExperience = experiencePoints.foragingExperience
        fishingExperience = experiencePoints.fishingExperience
        combatExperience = experiencePoints.combatExperience

        $farmingExperience.assign(to: \.farmingExperience, on: experiencePoints, markDirty: &$isDirty, storeIn: &subscriptions)
        $miningExperience.assign(to: \.miningExperience, on: experiencePoints, markDirty: &$isDirty, storeIn: &subscriptions)
        $foragingExperience.assign(to: \.foragingExperience, on: experiencePoints, markDirty: &$isDirty, storeIn: &subscriptions)
        $fishingExperience.assign(to: \.fishingExperience, on: experiencePoints, markDirty: &$isDirty, storeIn: &subscriptions)
        $combatExperience.assign(to: \.combatExperience, on: experiencePoints, markDirty: &$isDirty, storeIn: &subscriptions)
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

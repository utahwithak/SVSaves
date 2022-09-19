//
//  Player.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/7/22.
//

import Foundation
import Combine
import SDGParser

class Player: ObservableObject {
    let accessor: SDGParser.Player

    let experiencePoints: ExperiencePoints

    @Published
    var name: String

    @Published
    var farmName: String

    @Published
    var favoriteThing: String

    @Published
    var money: Int

    @Published
    var catPerson: Bool

    @Published
    var whichPetBreed: Int

    @Published
    var isMale: Bool

    @Published
    var speed: Int

    @Published
    var stamina: Int

    @Published
    var maxStamina: Int

    @Published
    var maxItems: Int

    @Published
    var attack: Int

    @Published
    var immunity: Int

    @Published
    var attackIncreaseModifier: Double

    @Published
    var knockbackModifier: Double

    @Published
    var weaponSpeedModifier: Double

    @Published
    var critChanceModifier: Double

    @Published
    var critPowerModifier: Double

    @Published
    var trashCanLevel: Int

    @Published
    var houseUpgradeLevel: Int

    @Published
    var daysUntilHouseUpgrade: Int

    @Published
    var daysLeftForToolUpgrade: Int

    @Published
    var magneticRadius: Int

    @Published
    var health: Int

    @Published
    var maxHealth: Int
    @Published
    public var farmingLevel: Int
    @Published
    public var miningLevel: Int
    @Published
    public var combatLevel: Int
    @Published
    public var foragingLevel: Int
    @Published
    public var fishingLevel: Int
    @Published
    public var luckLevel: Int
    @Published
    public var addedFarmingLevel: Int
    @Published
    public var addedMiningLevel: Int
    @Published
    public var addedCombatLevel: Int
    @Published
    public var addedForagingLevel: Int
    @Published
    public var addedFishingLevel: Int
    @Published
    public var addedLuckLevel: Int

    @Published
    public var newSkillPointsToSpend: Int

    let friendshipData: FriendshipData

    private var subscriptions = Set<AnyCancellable>()

    init(player: SDGParser.Player) {
        self.accessor = player

        friendshipData = FriendshipData(accessor: player.friendshipData)
        experiencePoints = ExperiencePoints(experiencePoints: player.experiencePoints)
        
        name = accessor.name
        farmName = accessor.farmName
        money = accessor.money
        favoriteThing = accessor.favoriteThing
        catPerson = accessor.catPerson
        whichPetBreed = accessor.whichPetBreed
        isMale = accessor.isMale
        speed = accessor.speed
        maxItems = accessor.maxItems
        attack = accessor.attack
        immunity = accessor.immunity
        attackIncreaseModifier = accessor.attackIncreaseModifier
        knockbackModifier = accessor.knockbackModifier
        weaponSpeedModifier = accessor.weaponSpeedModifier
        critChanceModifier = accessor.critChanceModifier
        critPowerModifier = accessor.critPowerModifier
        trashCanLevel = accessor.trashCanLevel
        houseUpgradeLevel = accessor.houseUpgradeLevel
        daysUntilHouseUpgrade = accessor.daysUntilHouseUpgrade
        magneticRadius = accessor.magneticRadius
        health = accessor.health
        maxHealth = accessor.maxHealth
        stamina = accessor.stamina
        maxStamina = accessor.maxStamina
        daysLeftForToolUpgrade = accessor.daysLeftForToolUpgrade

        newSkillPointsToSpend = accessor.newSkillPointsToSpend

        farmingLevel = accessor.farmingLevel
        miningLevel = accessor.miningLevel
        combatLevel = accessor.combatLevel
        foragingLevel = accessor.foragingLevel
        fishingLevel = accessor.fishingLevel
        luckLevel = accessor.luckLevel
        addedFarmingLevel = accessor.addedFarmingLevel
        addedMiningLevel = accessor.addedMiningLevel
        addedCombatLevel = accessor.addedCombatLevel
        addedForagingLevel = accessor.addedForagingLevel
        addedFishingLevel = accessor.addedFishingLevel
        addedLuckLevel = accessor.addedLuckLevel

        $name.assign(to: \.name, on: accessor).store(in: &subscriptions)
        $farmName.assign(to: \.farmName, on: accessor).store(in: &subscriptions)
        $money.assign(to: \.money, on: accessor).store(in: &subscriptions)
        $favoriteThing.assign(to: \.favoriteThing, on: accessor).store(in: &subscriptions)
        $catPerson.assign(to: \.catPerson, on: accessor).store(in: &subscriptions)
        $whichPetBreed.assign(to: \.whichPetBreed, on: accessor).store(in: &subscriptions)
        $isMale.assign(to: \.isMale, on: accessor).store(in: &subscriptions)
        $speed.assign(to: \.speed, on: accessor).store(in: &subscriptions)
        $maxItems.assign(to: \.maxItems, on: accessor).store(in: &subscriptions)
        $attack.assign(to: \.attack, on: accessor).store(in: &subscriptions)
        $immunity.assign(to: \.immunity, on: accessor).store(in: &subscriptions)
        $attackIncreaseModifier.assign(to: \.attackIncreaseModifier, on: accessor).store(in: &subscriptions)
        $knockbackModifier.assign(to: \.knockbackModifier, on: accessor).store(in: &subscriptions)
        $weaponSpeedModifier.assign(to: \.weaponSpeedModifier, on: accessor).store(in: &subscriptions)
        $critChanceModifier.assign(to: \.critChanceModifier, on: accessor).store(in: &subscriptions)
        $critPowerModifier.assign(to: \.critPowerModifier, on: accessor).store(in: &subscriptions)
        $trashCanLevel.assign(to: \.trashCanLevel, on: accessor).store(in: &subscriptions)
        $houseUpgradeLevel.assign(to: \.houseUpgradeLevel, on: accessor).store(in: &subscriptions)
        $daysUntilHouseUpgrade.assign(to: \.daysUntilHouseUpgrade, on: accessor).store(in: &subscriptions)
        $magneticRadius.assign(to: \.magneticRadius, on: accessor).store(in: &subscriptions)
        $stamina.assign(to: \.stamina, on: accessor).store(in: &subscriptions)
        $maxStamina.assign(to: \.maxStamina, on: accessor).store(in: &subscriptions)
        $maxHealth.assign(to: \.maxHealth, on: accessor).store(in: &subscriptions)
        $health.assign(to: \.health, on: accessor).store(in: &subscriptions)
        $daysLeftForToolUpgrade.assign(to: \.daysLeftForToolUpgrade, on: accessor).store(in: &subscriptions)
        $farmingLevel.assign(to: \.farmingLevel, on: accessor).store(in: &subscriptions)
        $miningLevel.assign(to: \.miningLevel, on: accessor).store(in: &subscriptions)
        $combatLevel.assign(to: \.combatLevel, on: accessor).store(in: &subscriptions)
        $foragingLevel.assign(to: \.foragingLevel, on: accessor).store(in: &subscriptions)
        $fishingLevel.assign(to: \.fishingLevel, on: accessor).store(in: &subscriptions)
        $luckLevel.assign(to: \.luckLevel, on: accessor).store(in: &subscriptions)
        $addedFarmingLevel.assign(to: \.addedFarmingLevel, on: accessor).store(in: &subscriptions)
        $addedMiningLevel.assign(to: \.addedMiningLevel, on: accessor).store(in: &subscriptions)
        $addedCombatLevel.assign(to: \.addedCombatLevel, on: accessor).store(in: &subscriptions)
        $addedForagingLevel.assign(to: \.addedForagingLevel, on: accessor).store(in: &subscriptions)
        $addedFishingLevel.assign(to: \.addedFishingLevel, on: accessor).store(in: &subscriptions)
        $addedLuckLevel.assign(to: \.addedLuckLevel, on: accessor).store(in: &subscriptions)
        $newSkillPointsToSpend.assign(to: \.newSkillPointsToSpend, on: accessor).store(in: &subscriptions)

        experiencePoints.$farmingExperience.sink {[weak self] newFarmingExperience in
            let newLevel = newFarmingExperience.toSVLevel()
            if newLevel != self?.farmingLevel {
                self?.farmingLevel = newLevel
            }
        }.store(in: &subscriptions)

        experiencePoints.$miningExperience.removeDuplicates().sink {[weak self] newMiningExperience in
            let newLevel = newMiningExperience.toSVLevel()
            if newLevel != self?.miningLevel {
                self?.miningLevel = newLevel
            }

        }.store(in: &subscriptions)

        experiencePoints.$combatExperience.removeDuplicates().sink {[weak self] newCombatExperience in
            let newLevel = newCombatExperience.toSVLevel()
            if newLevel != self?.combatLevel {
                self?.combatLevel = newLevel
            }

        }.store(in: &subscriptions)

        experiencePoints.$foragingExperience.removeDuplicates().sink {[weak self] newForagingExperience in
            let newLevel = newForagingExperience.toSVLevel()
            if self?.foragingLevel != newLevel {
                self?.foragingLevel = newLevel
            }

        }.store(in: &subscriptions)

        experiencePoints.$fishingExperience.removeDuplicates().sink {[weak self] newFishingExperience in
            let newLevel = newFishingExperience.toSVLevel()
            if newLevel != self?.fishingLevel {
                self?.fishingLevel = newLevel
            }

        }.store(in: &subscriptions)

        $farmingLevel.removeDuplicates().sink {[weak self] newLevel in
            self?.experiencePoints.farmingExperience = newLevel.toMinExperience()
        }.store(in: &subscriptions)

        $miningLevel.removeDuplicates().sink {[weak self] newLevel in
            self?.experiencePoints.miningExperience = newLevel.toMinExperience()
        }.store(in: &subscriptions)

        $combatLevel.removeDuplicates().sink {[weak self] newLevel in
            self?.experiencePoints.combatExperience = newLevel.toMinExperience()
        }.store(in: &subscriptions)

        $foragingLevel.removeDuplicates().sink {[weak self] newLevel in
            self?.experiencePoints.foragingExperience = newLevel.toMinExperience()
        }.store(in: &subscriptions)

        $fishingLevel.removeDuplicates().sink {[weak self] newLevel in
            self?.experiencePoints.fishingExperience = newLevel.toMinExperience()
        }.store(in: &subscriptions)
    }


}

extension Int {
    func toSVLevel() -> Int {
        switch self {
        case 0...100: return 0
        case 101...380: return 1
        case 381...770: return 2
        case 771...1300: return 3
        case 1301...2150: return 4
        case 2151...3300: return 5
        case 3301...4800: return 6
        case 4801...6900: return 7
        case 6901...10000: return 8
        case 10001...15000: return 9
        default:
            return 10
        }
    }

    func toMinExperience() -> Int {
        switch self {
        case 0: return 0
        case 1: return 100
        case 2: return 380
        case 3: return 770
        case 4: return 1300
        case 5: return 2150
        case 6: return 3300
        case 7: return 4800
        case 8: return 6900
        case 9: return 10000
        case 10: return 15000
        default:
            return 11
        }

    }
}

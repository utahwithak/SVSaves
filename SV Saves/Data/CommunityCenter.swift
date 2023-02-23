//
// COPYRIGHT 2023 Free Bits
// Created by Carl Wieland on 1/19/23
// 

import Foundation
import SDGParser

@MainActor
class CommunityCenter : ObservableObject, Identifiable {
    let accessor: SDGParser.CommunityCenter

    let game: SDGParser.Game

    @Published
    var isDirty: Bool = false

    init(accessor: SDGParser.CommunityCenter, game: SDGParser.Game) {
        self.accessor = accessor
        self.game = game
    }

    func markBundleComplete(with id: Int, in room: BundleData.Room) {
        accessor.markBundleComplete(with: id)

        if hasFinishedRoom(room) {
            accessor.markRoomComplete(room)
            let roomName = room.name.replacingOccurrences(of: " ", with: "")
            game.player.mailForTomorrow.append("cc\(roomName)%&NL&%")
        }

        isDirty = true
    }

    func hasCompletedBundleRequirement(id: Int, index: Int) -> Bool {
        return accessor.hasFinished(bundle: id, at: index)
    }

    func markBundleRequirementComplete(with id: Int, at index: Int, in room: BundleData.Room) {
        accessor.markBundleComplete(with: id, at: index)
        isDirty = true
    }

    func hasFinishedRoom(_ room: BundleData.Room) -> Bool {
        room.bundles.allSatisfy { bundle in
           hasFinishedBundle(bundle)
        }
    }

    func hasFinishedBundle(_ bundle: BundleData.Bundle) -> Bool {

        let finishedRequirements = bundle.requirements.enumerated().filter({ (offset, _) in
            hasCompletedBundleRequirement(id: bundle.id, index: offset)
        })

        if finishedRequirements.count == bundle.requirements.count {
            return true
        }
        if let requiredCount = bundle.required {
            return finishedRequirements.count >= requiredCount
        }
        return false
    }
}

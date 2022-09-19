//
//  FriendshipData.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/16/22.
//

import Combine
import Foundation
import SDGParser

class FriendshipData: ObservableObject {
    let accessor: SDGParser.FriendshipData

    init(accessor: SDGParser.FriendshipData) {
        self.accessor = accessor
        friendships = accessor.friendshipItems.map { Friendship(item: $0)}
    }

    let friendships: [Friendship]

}

class Friendship: ObservableObject, Identifiable {

    var id: String {
        item.friendName
    }

    let item: FriendshipItem

    let friendName: String

    @Published
    var points: Int

    @Published
    var giftsThisWeek: Int

    private var subscriptions = Set<AnyCancellable>()

    init(item: FriendshipItem) {
        self.item = item
        friendName = item.friendName
        points = item.points
        giftsThisWeek = item.giftsThisWeek

        $points.assign(to: \.points, on: item).store(in: &subscriptions)
        $giftsThisWeek.assign(to: \.giftsThisWeek, on: item).store(in: &subscriptions)

    }


}


//
//  Inventory.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/19/22.
//

import Foundation
import SDGParser
import Combine


class Inventory: ObservableObject {
    private let inventory: SDGParser.Inventory

    init(inventory: SDGParser.Inventory) {
        self.inventory = inventory
        items = inventory.items.map { Item(item: $0) }

        items.forEach({ $0.$isDirty.assign(to: &$isDirty )})
    }

    @Published
    var isDirty: Bool = false

    @Published
    var items: [Item]
}


class Item: ObservableObject, Identifiable {

    let isEmpty: Bool

    let name: String

    let isStackable: Bool

    @Published
    var isDirty: Bool = false

    @Published
    var stack: Int

    private let item: SDGParser.Item

    var subscriptions = Set<AnyCancellable>()

    init(item: SDGParser.Item) {
        self.item = item
        isEmpty = item.isEmtpy
        name = item.name
        stack = item.stack
        isStackable = item.isStackable

        $stack.assign(to: \.stack, on: item, markDirty: &$isDirty, storeIn: &subscriptions)

    }

}

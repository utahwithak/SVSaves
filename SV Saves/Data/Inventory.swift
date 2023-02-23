//
//  Inventory.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/19/22.
//

import Foundation
import SDGParser
import Combine

@MainActor
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

@MainActor
class Item: ObservableObject, Identifiable {

    var isEmpty: Bool

    var name: String

    @Published
    var isStackable: Bool

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

    func makeItem(from itemID: ItemID, count: Int, quality: Quality, type: ItemType) {
        isEmpty = false
        name = itemID.description
        item.makeItem(from: itemID, count: count, quality: quality, type: type)
        stack = count
        isStackable = true
        isDirty = true
    }

}

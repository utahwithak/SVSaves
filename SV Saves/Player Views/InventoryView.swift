//
//  InventoryView.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/19/22.
//

import Foundation
import SwiftUI

struct InventoryView: View {

    let inventory: Inventory
    init(inventory: Inventory) {
        self.inventory = inventory
    }

    var body: some View {
        Form {
            ForEach(inventory.items) { item in
                ItemRow(item: item)
            }

        }
    }
}

struct ItemRow: View {
    @ObservedObject
    var item: Item
    
    init(item: Item) {
        self.item = item
    }

    var body: some View {
        HStack {
            if item.isEmpty {
                Text("<empty slot>")
            } else {
                Text(item.name)
                Spacer()
                if item.isStackable {
                    TextField("", value: $item.stack, formatter: BoundFormatter(min: 0, max: 999))
                        .textFieldStyle(.plain)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }

            }


        }
    }
}

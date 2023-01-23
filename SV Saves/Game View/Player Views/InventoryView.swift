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
        VStack {
            Text("Rows with numbers allows editing the stack count")
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .padding([.leading, .trailing, .top])
            List {
                ForEach(inventory.items) { item in
                    if item.isEmpty {

                    } else {
                        ItemRow(item: item)
                    }
                }

            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()

                Button("Done") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                    to: nil, from: nil, for: nil)
                }
            }
        }
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Inventory")
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

struct SpawnRow: View {

    let item: Item

    @State
    var showSpawnItemSheet = false

    var body: some View {
        Button {
            showSpawnItemSheet = true
        } label: {
            Text("Create Item")
        }
        .sheet(isPresented: showSpawnItemSheet) {
            SpawnItemSheet()
        }

    }
}

struct SpawnItemSheet: View {

    var body: some View {
        Text("Hello world")
    }
}

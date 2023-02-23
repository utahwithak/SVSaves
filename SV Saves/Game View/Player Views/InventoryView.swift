//
//  InventoryView.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/19/22.
//

import Foundation
import SwiftUI
import SDGParser

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
                    ItemRow(item: item)
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
        if item.isEmpty {
            SpawnRow(item: item)
        } else {
            HStack {
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
        .sheet(isPresented: $showSpawnItemSheet) {
            SpawnItemSheet(item: item)
        }

    }
}

struct SpawnItemSheet: View {
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>

    let item: Item

    @State
    var itemID: SDGParser.ItemID = .prismaticShard

    @State
    var stackSize: Int = 1

    @State
    var quality: Quality = .none

    @State
    var itemType: ItemType = .none

    var body: some View {
        NavigationView {
            Form {
                Picker("Item Type", selection: $itemID) {
                    ForEach(ItemID.sortedValues.filter({ $0 != .unknown })) { item in
                        Text(item.description).tag(item)
                    }
                }
                HStack {
                    Text("Count")
                    TextField("", value: $stackSize, formatter: BoundFormatter(min: 1, max:  999))
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
                Picker("Quality", selection: $quality) {
                    ForEach(Quality.allCases) { item in
                        HStack {
                            Text(item.description)
                        }.tag(item)
                    }
                }
                Picker("Item Type", selection: $itemType) {
                    ForEach(ItemType.sortedValues) { item in
                        HStack {
                            Text(item.description)
                        }.tag(item)
                    }
                }


            }.toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        item.makeItem(from: itemID, count: stackSize, quality: quality, type: itemType)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Save")
                    }
                }
            }

        }
    }
}

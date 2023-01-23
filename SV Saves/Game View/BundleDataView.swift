//
// COPYRIGHT 2023 Free Bits
// Created by Carl Wieland on 1/19/23
// 

import Foundation
import SwiftUI
import SDGParser

struct BundleDataView: View {
    let bundleData: BundleData
    @ObservedObject
    var communityCenter: CommunityCenter

    var body: some View {
        List(bundleData.roomData, id: \.id) { room in
            Section {
                ForEach(room.bundles, id: \.id) { bundle in
                    NavigationLink {
                        BundleView(room: room, bundle: bundle, communityCenter: communityCenter)
                    } label: {

                        if communityCenter.hasFinishedBundle(bundle) {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "circle")
                                .foregroundColor(.gray)
                        }
                        Text(bundle.name)
                    }

                }
            } header: {
                HStack {
                    if communityCenter.hasFinishedRoom(room) {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "circle")
                            .foregroundColor(.gray)
                    }
                    Text(room.name)
                }
            }
        }
        .navigationTitle("Bundle Data")

    }
}

struct BundleView: View {

    let room: BundleData.Room

    let bundle: BundleData.Bundle

    @ObservedObject
    var communityCenter: CommunityCenter

    var body: some View {
        VStack(alignment: .leading) {
            if let required = bundle.required {
                Text("Requires: \(required)")
                    .padding()

            }
            Button {
                communityCenter.markBundleComplete(with: bundle.id, in: room)
            } label: {
                Text("Mark bundle complete")
            }
            .padding()

            List(Array(bundle.requirements.enumerated()), id: \.element.id) { (index, requirement) in

                Button {
                    communityCenter.markBundleRequirementComplete(with: bundle.id, at: index, in: room)
                } label: {
                    HStack {

                        if communityCenter.hasCompletedBundleRequirement(id: bundle.id, index: index) == true{
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "circle")
                                .foregroundColor(.gray)
                        }

                        switch requirement.itemID {
                        case .unknown:
                            Text("Money")
                        default:
                            Text(requirement.itemID.description)
                        }
                        Spacer()
                        Text("\(requirement.requiredCount)")
                        switch requirement.minimumQuality {
                        case .none:
                            EmptyView()
                        case .silver:
                            Image(systemName: "star.fill")
                                .foregroundColor(.gray)
                        case .gold:
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        case .iriduum:
                            Image(systemName: "star.fill")
                                .foregroundColor(.purple)
                        }
                    }
                    .contentShape(Rectangle())

                }
                .buttonStyle(.plain)

            }
        }
        .navigationTitle(bundle.name)
    }
}

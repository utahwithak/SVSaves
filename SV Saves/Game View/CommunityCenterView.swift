//
// COPYRIGHT 2023 Free Bits
// Created by Carl Wieland on 2/24/23
// 

import Foundation
import SwiftUI

struct CommunityCenterView: View {

    @ObservedObject
    var game: Game

    var body: some View {




        if let communityCenter = game.communityCenter {
            Button {
                communityCenter.markCommunityCenterUnlocked()
            } label: {
                if communityCenter.isUnlocked {
                    Text("Unlocked")
                } else {
                    Text("Unlock")
                }
            }
            .disabled(communityCenter.isUnlocked)

            Button {
                communityCenter.markCanReadJunimoText()
            } label: {
                if communityCenter.canReadJunimo {
                    Text("Junimo Text Readable")
                } else {
                    Text("Allow Reading Junimo Text")
                }
            }
            .disabled(communityCenter.canReadJunimo)


            NavigationLink {
                BundleDataView(bundleData: game.bundleData, communityCenter: communityCenter)
            } label: {
                Text("Bundle Data")
            }
        } else {
            Text("Unable to find Community Center")
        }
    }

}

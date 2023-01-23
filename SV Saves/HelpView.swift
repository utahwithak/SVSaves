//
//  HelpView.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/22/22.
//

import Foundation
import SwiftUI

struct HelpView: View {

    var settings: Settings

    var body: some View {

        NavigationView {
            VStack {
                List {
                    Section("For Best Results") {
                        HStack {
                            Text("1.")
                            Text("In Stardew Valley, end the day and let it save")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        HStack {
                            Text("2.")
                            Text("In Stardew Valley, exit to title screen")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        HStack {
                            Text("3.")
                            Text("Open SV Saves")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        HStack {
                            Text("4.")
                            Text("Make minor modifications")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        HStack {
                            Text("5.")
                            Text("Open Stardew Valley and verify game still loads correctly")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        HStack {
                            Text("6.")
                            Text("Repeat")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }


                    Section("Notes") {
                        Text("The loading page may not match edits until sleeping once")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Skipping time can cause events not to happen!")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Some modifiers only last one day.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("If you upgrade your level past when a profession would be picked, it will prompt the following night")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                }
            }.onAppear {
                settings.hasSeenHelp = true
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("How to")

        }
        .navigationViewStyle(.stack)

    }

}

#if DEBUG
struct HelpView_Preivew: PreviewProvider {

    static var previews: some View {
        HelpView(settings: Settings())
    }
}
#endif

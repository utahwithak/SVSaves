//
//  FriendshipView.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/16/22.
//

import Foundation
import SwiftUI

struct FriendshipView: View {

    let data: FriendshipData

    var body: some View {

        NavigationStack {
            List(data.friendships) { item in
                Section(item.friendName) {
                    PointsRow(friendship: item)
                    GiftsRow(friendship: item)
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
            .navigationTitle("Friendship")

        }

    }
}

struct PointsRow: View {
    @ObservedObject
    var friendship: Friendship

    init(friendship: Friendship) {
        self.friendship = friendship
    }

    var body: some View {
        HStack {
            Text("Points")
            TextField("", value: $friendship.points, formatter: BoundFormatter(min: 0, max: 14 * 250))
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct GiftsRow: View {
    @ObservedObject
    var friendship: Friendship

    init(friendship: Friendship) {
        self.friendship = friendship
    }

    var body: some View {
        HStack {
            Text("Gifts this Week")
            TextField("", value: $friendship.giftsThisWeek, formatter: BoundFormatter(min: 0, max: 2))
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
        }
    }
}


class BoundFormatter: Formatter {

    let max: Int
    let min: Int
    init(min: Int, max: Int) {
        self.max = max
        self.min = min
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func clamp(with value: Int, min: Int, max: Int) -> Int{
        guard value <= max else {
            return max
        }

        guard value >= min else {
            return min
        }

        return value
    }

    override func string(for obj: Any?) -> String? {
        guard let number = obj as? Int else {
            return nil
        }
        return String(number)

    }

    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {

        guard let number = Int(string) else {
            return false
        }

        obj?.pointee = clamp(with: number, min: self.min, max: self.max) as AnyObject

        return true
    }

}

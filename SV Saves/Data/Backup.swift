//
//  Backup.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/20/22.
//

import Foundation

struct Backup: Identifiable {

    static let readableDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .long
        return formatter
    }()

    var id: String {
        return url.path
    }

    let date: Date

    let url: URL

    init?(url: URL) {
        self.url = url
        let dateString = url.lastPathComponent
        guard let date = GameManager.dateFormatter.date(from: dateString) else {
            return nil
        }
        self.date = date
    }


    var name: String {
        return Self.readableDate.string(from: date)
    }
}

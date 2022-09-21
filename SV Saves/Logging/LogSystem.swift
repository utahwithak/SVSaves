//
//  LogSystem.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/20/22.
//

import Foundation
import OSLog

public protocol LogSystem {

    init(identifier: String, category: String)

    func logInfo(_ message: String, category: String)

    func logDebug(_ message: String, category: String)

    func logError(_ message: String, category: String)

    static func loadEntries() async -> [LogItem]
}

public protocol LogItem {
    var messageCategory: String { get }
    var composedMessage: String { get }
}

extension Logger: LogSystem {
    public func logInfo(_ message: String, category: String) {
        info("\(message)")
    }

    public func logDebug(_ message: String, category: String) {
        debug("\(message)")
    }

    public func logError(_ message: String, category: String) {
        error("\(message)")
    }

    public init(identifier: String, category: String) {
        self.init(subsystem: identifier, category: category)
    }

    public static func loadEntries() -> [LogItem] {
        let logStore = try? OSLogStore(scope: .currentProcessIdentifier)
        if let entries = try? logStore?.getEntries(with: [.reverse]) {
            return entries
                .compactMap { $0 as? OSLogEntryLog }
                .filter { logEntry in
                    logEntry.subsystem == Bundle.main.bundleIdentifier
                }
        } else {
            return []
        }
    }
}

extension OSLogEntryLog: LogItem {
    public var messageCategory: String {
        category
    }
}

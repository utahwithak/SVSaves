//
//  Category.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/20/22.
//

import Foundation

import Foundation
import OSLog

public struct Category: Equatable {
    public static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.category == rhs.category && lhs.subsystem == rhs.subsystem
    }

    let logger: LogSystem
    let category: String
    let subsystem: String

    public init<T: LogSystem>(category: String, subsystem: String = Bundle.main.bundleIdentifier!, logger: T.Type) {
        self.init(category: category, subsystem: subsystem, logger: logger.init(identifier: subsystem, category: category))
    }

    public init(category: String, subsystem: String = Bundle.main.bundleIdentifier!, logger: LogSystem) {
        self.subsystem = subsystem
        self.category = category
        self.logger = logger
    }

    func debug(_ message: String) {
        logger.logDebug(message, category: category)
    }

    func info(_ message: String) {
        logger.logInfo(message, category: category)
    }

    func error(_ message: String) {
        logger.logError(message, category: category)
    }

    private static let defaultLogger = Logger.self

    public static let `default` = Category(category: "DEFAULT", logger: defaultLogger)
    public static let debug = Category(category: "DEBUG", logger: defaultLogger)
}

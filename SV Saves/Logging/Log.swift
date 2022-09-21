//
//  Log.swift
//  SV Saves
//
//  Created by Carl Wieland on 9/20/22.
//

import Foundation

public class Log {
    private init() {}

    public static var entries: [LogItem] {
        get async {
            await type(of: Category.default.logger).loadEntries()
        }
    }

    public static var excludedCategories: [Category] = []

    public static var includedCategories: [Category]?

    private static func shouldLog(category: Category) -> Bool {
        if excludedCategories.contains(where: { $0 == category }) {
            return false
        }
        if let included = includedCategories {
            return included.contains(where: { $0 == category })
        }
        return true
    }

    public static func debug(_ message: String, category: Category = .default) {
        guard shouldLog(category: category) else {
#if DEBUG
            print("d:\(message)")
#endif
            return
        }
        category.debug(message)
    }

    public static func info(_ message: String, category: Category = .default) {
        guard shouldLog(category: category) else {
#if DEBUG
            print("i:\(message)")
#endif
            return
        }
        category.info(message)
    }

    public static func error(_ message: String, category: Category = .default) {
        guard shouldLog(category: category) else {
#if DEBUG
            print("e:\(message)")
#endif
            return
        }
        category.error(message)
    }

}


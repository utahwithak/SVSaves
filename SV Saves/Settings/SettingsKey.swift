//
//  SettingsKey.swift
//  SettingsKey
//
//  Created by Carl Wieland on 8/26/21.
//

import Foundation
import SwiftUI

private struct SettingsEnvironmentKey: EnvironmentKey {
    static let defaultValue: Settings = Settings()
}


extension EnvironmentValues {
var settings: Settings {
    get { self[SettingsEnvironmentKey.self] }
    set { self[SettingsEnvironmentKey.self] = newValue }
  }
}


extension View {
  func settings(_ settings: Settings) -> some View {
    environment(\.settings, settings)
  }
}

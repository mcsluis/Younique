//
//  AppearancePreference.swift
//  Younique
//
//  Created by Codex on 25/06/2026.
//

import SwiftUI

enum AppearancePreference: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system:
            return Bundle.appLocalizedString("Systeem")
        case .light:
            return Bundle.appLocalizedString("Licht")
        case .dark:
            return Bundle.appLocalizedString("Donker")
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

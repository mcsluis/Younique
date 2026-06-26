//
//  AppLanguagePreference.swift
//  Younique
//
//  Created by Codex on 26/06/2026.
//

import Foundation

enum AppLanguagePreference: String, CaseIterable, Identifiable {
    case system
    case dutch
    case english

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system:
            return Bundle.appLocalizedString("Systeem")
        case .dutch:
            return Bundle.appLocalizedString("Nederlands")
        case .english:
            return "English"
        }
    }

    var locale: Locale {
        switch self {
        case .system:
            return .autoupdatingCurrent
        case .dutch:
            return Locale(identifier: "nl")
        case .english:
            return Locale(identifier: "en")
        }
    }

    var languageCode: String? {
        switch self {
        case .system:
            return nil
        case .dutch:
            return "nl"
        case .english:
            return "en"
        }
    }
}

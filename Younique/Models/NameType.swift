//
//  NameType.swift
//  Younique
//
//  Created by Marc van der Sluis on 22/06/2026.
//

import Foundation

enum NameType: String, CaseIterable, Identifiable {
    case girl
    case boy
    case neutral

    var id: String { rawValue }

    var title: String {
        switch self {
        case .girl:
            return String(localized: "Meisjesnaam")
        case .boy:
            return String(localized: "Jongensnaam")
        case .neutral:
            return String(localized: "Neutraal")
        }
    }

    var detail: String {
        switch self {
        case .girl:
            return String(localized: "Zachtere openers en meer open, vloeiende eindklanken.")
        case .boy:
            return String(localized: "Stevigere starts en meer gesloten of harde eindklanken.")
        case .neutral:
            return String(localized: "Een gemengde pool zonder specifieke klankaanpassingen.")
        }
    }
}

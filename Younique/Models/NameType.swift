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
            return "Meisjesnaam"
        case .boy:
            return "Jongensnaam"
        case .neutral:
            return "Neutraal"
        }
    }

    var detail: String {
        switch self {
        case .girl:
            return "Zachtere openers en meer open, vloeiende eindklanken."
        case .boy:
            return "Stevigere starts en meer gesloten of harde eindklanken."
        case .neutral:
            return "Een gemengde pool zonder specifieke klankaanpassingen."
        }
    }
}

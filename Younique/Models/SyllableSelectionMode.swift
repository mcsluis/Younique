//
//  SyllableSelectionMode.swift
//  Younique
//
//  Created by Marc van der Sluis on 21/06/2026.
//

import Foundation

enum SyllableSelectionMode: String, CaseIterable, Identifiable {
    case automatic
    case automaticShared
    case sharedManual
    case distributedManual
    case perReelManual

    var id: String { rawValue }

    var title: String {
        switch self {
        case .automatic:
            return String(localized: "Geoptimaliseerd")
        case .automaticShared:
            return String(localized: "Iedere positie, elke lettergreep")
        case .sharedManual:
            return String(localized: "Elke gekozen lettergreep op alle posities")
        case .distributedManual:
            return String(localized: "Gekozen lettergrepen beschikbaar volgens de positiestructuur")
        case .perReelManual:
            return String(localized: "Zelf de lettergrepen per positie kiezen")
        }
    }

    var detail: String {
        switch self {
        case .automatic:
            return String(localized: "De app kiest uit de pools en filters.")
        case .automaticShared:
            return String(localized: "Elke positie gebruikt dezelfde volledige lettergreeppool.")
        case .sharedManual:
            return String(localized: "Alle posities gebruiken dezelfde gekozen lettergrepen.")
        case .distributedManual:
            return String(localized: "De gekozen lettergrepen worden verdeeld volgens de positiestructuur.")
        case .perReelManual:
            return String(localized: "Je kiest per positie apart welke lettergrepen beschikbaar zijn.")
        }
    }
}

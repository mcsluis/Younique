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
            return "Geoptimaliseerd"
        case .automaticShared:
            return "Iedere positie, elke lettergreep"
        case .sharedManual:
            return "Elke gekozen lettergreep op alle posities"
        case .distributedManual:
            return "Gekozen lettergrepen beschikbaar volgens de positiestructuur"
        case .perReelManual:
            return "Zelf de lettergrepen per positie kiezen"
        }
    }

    var detail: String {
        switch self {
        case .automatic:
            return "De app kiest uit de pools en filters."
        case .automaticShared:
            return "Elke positie gebruikt dezelfde volledige lettergreeppool."
        case .sharedManual:
            return "Alle posities gebruiken dezelfde gekozen lettergrepen."
        case .distributedManual:
            return "De gekozen lettergrepen worden verdeeld volgens de positiestructuur."
        case .perReelManual:
            return "Je kiest per positie apart welke lettergrepen beschikbaar zijn."
        }
    }
}

//
//  SyllableSelectionMode.swift
//  Kampert
//
//  Created by Marc van der Sluis on 21/06/2026.
//

import Foundation

enum SyllableSelectionMode: String, CaseIterable, Identifiable {
    case automatic
    case sharedManual
    case distributedManual
    case perReelManual

    var id: String { rawValue }

    var title: String {
        switch self {
        case .automatic:
            return "Automatisch"
        case .sharedManual:
            return "Zelf kiezen"
        case .distributedManual:
            return "Zelf kiezen + rolverdeling"
        case .perReelManual:
            return "Per rol kiezen"
        }
    }

    var detail: String {
        switch self {
        case .automatic:
            return "De app kiest uit de pools en filters."
        case .sharedManual:
            return "Alle rollen gebruiken dezelfde gekozen lettergrepen."
        case .distributedManual:
            return "De gekozen lettergrepen worden verdeeld volgens de rolstructuur."
        case .perReelManual:
            return "Je kiest per rol apart welke lettergrepen beschikbaar zijn."
        }
    }
}

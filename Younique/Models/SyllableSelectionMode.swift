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
            return Bundle.appLocalizedString("Geoptimaliseerd")
        case .automaticShared:
            return Bundle.appLocalizedString("Iedere positie, elke lettergreep")
        case .sharedManual:
            return Bundle.appLocalizedString("Elke gekozen lettergreep op alle posities")
        case .distributedManual:
            return Bundle.appLocalizedString("Gekozen lettergrepen beschikbaar volgens de positiestructuur")
        case .perReelManual:
            return Bundle.appLocalizedString("Zelf de lettergrepen per positie kiezen")
        }
    }

    var detail: String {
        switch self {
        case .automatic:
            return Bundle.appLocalizedString("De app kiest uit de pools en filters.")
        case .automaticShared:
            return Bundle.appLocalizedString("Elke positie gebruikt dezelfde volledige lettergreeppool.")
        case .sharedManual:
            return Bundle.appLocalizedString("Alle posities gebruiken dezelfde gekozen lettergrepen.")
        case .distributedManual:
            return Bundle.appLocalizedString("De gekozen lettergrepen worden verdeeld volgens de positiestructuur.")
        case .perReelManual:
            return Bundle.appLocalizedString("Je kiest per positie apart welke lettergrepen beschikbaar zijn.")
        }
    }
}

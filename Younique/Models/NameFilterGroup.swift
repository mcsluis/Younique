//
//  NameFilterGroup.swift
//  Younique
//
//  Created by Marc van der Sluis on 21/06/2026.
//

import Foundation

enum NameFilterGroup: String, CaseIterable, Identifiable, Hashable {
    case sharpStarts
    case flowStarts
    case urbanAccents
    case englishTails
    case softFillers

    var id: String { rawValue }

    var title: String {
        switch self {
        case .sharpStarts:
            return String(localized: "Harde starts")
        case .flowStarts:
            return String(localized: "Zachte starts")
        case .urbanAccents:
            return String(localized: "Dj/Sh/Y-klanken")
        case .englishTails:
            return String(localized: "Engelse eindes")
        case .softFillers:
            return String(localized: "Zachte vulklanken")
        }
    }

    var detail: String {
        switch self {
        case .sharpStarts:
            return String(localized: "Ka, Ke, Ta, Ste, Pri")
        case .flowStarts:
            return String(localized: "La, Le, Li, Ma, Na")
        case .urbanAccents:
            return String(localized: "Dja, Dje, Sha, Jay, ya")
        case .englishTails:
            return String(localized: "ley, lyn, lynn, ney, son")
        case .softFillers:
            return String(localized: "a, an, el, en, na, ra")
        }
    }
}

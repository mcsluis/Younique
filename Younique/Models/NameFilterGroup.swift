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
            return "Harde starts"
        case .flowStarts:
            return "Zachte starts"
        case .urbanAccents:
            return "Dj/Sh/Y-klanken"
        case .englishTails:
            return "Engelse eindes"
        case .softFillers:
            return "Zachte vulklanken"
        }
    }

    var detail: String {
        switch self {
        case .sharpStarts:
            return "Ka, Ke, Ta, Ste, Pri"
        case .flowStarts:
            return "La, Le, Li, Ma, Na"
        case .urbanAccents:
            return "Dja, Dje, Sha, Jay, ya"
        case .englishTails:
            return "ley, lyn, lynn, ney, son"
        case .softFillers:
            return "a, an, el, en, na, ra"
        }
    }
}

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
            return Bundle.appLocalizedString("Harde starts")
        case .flowStarts:
            return Bundle.appLocalizedString("Zachte starts")
        case .urbanAccents:
            return Bundle.appLocalizedString("Dj/Sh/Y-klanken")
        case .englishTails:
            return Bundle.appLocalizedString("Engelse eindes")
        case .softFillers:
            return Bundle.appLocalizedString("Zachte vulklanken")
        }
    }

    var detail: String {
        switch self {
        case .sharpStarts:
            return Bundle.appLocalizedString("Ka, Ke, Ta, Ste, Pri")
        case .flowStarts:
            return Bundle.appLocalizedString("La, Le, Li, Ma, Na")
        case .urbanAccents:
            return Bundle.appLocalizedString("Dja, Dje, Sha, Jay, ya")
        case .englishTails:
            return Bundle.appLocalizedString("ley, lyn, lynn, ney, son")
        case .softFillers:
            return Bundle.appLocalizedString("a, an, el, en, na, ra")
        }
    }
}

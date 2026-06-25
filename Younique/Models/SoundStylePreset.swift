//
//  SoundStylePreset.swift
//  Younique
//
//  Created by Marc van der Sluis on 25/06/2026.
//

import Foundation

enum SoundStylePreset: String, CaseIterable, Identifiable {
    case softLatin
    case stoerKort
    case freshModern
    case warmSpanish
    case dreamySoft
    case powerfulBold
    case romantic
    case classicEnglish

    var id: String { rawValue }

    var isPremium: Bool {
        switch self {
        case .softLatin, .stoerKort, .freshModern, .romantic:
            return false
        case .warmSpanish, .dreamySoft, .powerfulBold, .classicEnglish:
            return true
        }
    }

    var title: String {
        switch self {
        case .softLatin:
            return "Zacht & Latijn"
        case .stoerKort:
            return "Stoer & kort"
        case .freshModern:
            return "Fris & modern"
        case .warmSpanish:
            return "Warm & Spaans"
        case .dreamySoft:
            return "Dromerig & zacht"
        case .powerfulBold:
            return "Krachtig & uitgesproken"
        case .romantic:
            return "Romantisch"
        case .classicEnglish:
            return "Klassiek Engels"
        }
    }

    var detail: String {
        switch self {
        case .softLatin:
            return "Vloeiende openers, zachte bruggen en open eindklanken."
        case .stoerKort:
            return "Compacte combinaties met stevigere starts en directe eindes."
        case .freshModern:
            return "Helder, fris en geschikt voor moderne, korte naamcombinaties."
        case .warmSpanish:
            return "Warme, ritmische klanken met open eindes en zonnige overgangen."
        case .dreamySoft:
            return "Luchtige en vloeiende klanken voor een zachte, dromerige sfeer."
        case .powerfulBold:
            return "Meer pit, hardere starts en uitgesproken stukken in het midden."
        case .romantic:
            return "Zachter, melodischer en iets sierlijker in de afwerking."
        case .classicEnglish:
            return "Meer Engelse staarten en een sierlijke, herkenbare klank."
        }
    }

    var accentLine: String {
        switch self {
        case .softLatin:
            return "la, mi, na, ra, el, en"
        case .stoerKort:
            return "ka, ke, no, ro, ash, von"
        case .freshModern:
            return "ka, li, mi, no, vi, ya"
        case .warmSpanish:
            return "cha, la, lo, ra, ro, sa"
        case .dreamySoft:
            return "ah, lu, mel, na, sha, ya"
        case .powerfulBold:
            return "ash, ber, dev, kel, ro, von"
        case .romantic:
            return "ah, el, la, na, ri, ya"
        case .classicEnglish:
            return "ash, ley, lyn, son, tay, que"
        }
    }

    var includedSyllables: [Syllable] {
        switch self {
        case .softLatin:
            return [
                .a, .ah, .el, .en, .i, .la, .le, .li, .lu, .ma, .mel,
                .mi, .na, .ni, .o, .ra, .ri, .sa, .sha, .ta, .ya
            ]
        case .stoerKort:
            return [
                .ash, .bo, .da, .de, .di, .do, .ka, .ke, .ki, .no,
                .on, .ra, .ro, .ta, .ty, .va, .vi, .von
            ]
        case .freshModern:
            return [
                .a, .ce, .el, .ka, .ki, .la, .li, .mi, .na, .no,
                .ra, .ri, .sha, .ta, .va, .vi, .ya, .you
            ]
        case .warmSpanish:
            return [
                .a, .ce, .cha, .da, .de, .di, .el, .en, .la, .lo,
                .ma, .na, .o, .ra, .ri, .ro, .sa, .ta, .ya
            ]
        case .dreamySoft:
            return [
                .a, .ah, .el, .en, .ey, .i, .la, .le, .lu, .mel,
                .mi, .na, .ney, .ni, .ra, .ri, .sha, .ya
            ]
        case .powerfulBold:
            return [
                .ash, .ber, .bo, .dev, .fan, .ka, .kel, .no, .on, .ra,
                .rell, .ris, .ro, .ste, .ta, .ty, .va, .von, .za
            ]
        case .romantic:
            return [
                .a, .ah, .ce, .el, .en, .ey, .la, .le, .li, .na,
                .ra, .ri, .sa, .sha, .ta, .ya
            ]
        case .classicEnglish:
            return [
                .ash, .ber, .brit, .ce, .cha, .el, .en, .ey, .jay, .kel,
                .ley, .lin, .lyn, .lynn, .ney, .que, .sha, .son, .tay
            ]
        }
    }

    func availableSyllables(for nameType: NameType, allowedSyllables: Set<String>) -> Set<String> {
        let preferred = Set(includedSyllables.map(\.rawValue))
        let available = preferred.intersection(allowedSyllables)

        if !available.isEmpty {
            return available
        }

        switch nameType {
        case .girl:
            return ["la", "mi", "na", "ra"]
        case .boy:
            return ["de", "ka", "no", "ro"]
        case .neutral:
            return ["ka", "lo", "mi", "ra"]
        }
    }
}

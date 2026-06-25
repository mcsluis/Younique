//
//  DisplayFont.swift
//  Younique
//
//  Created by Marc van der Sluis on 23/06/2026.
//

import SwiftUI

enum DisplayFont: String, CaseIterable, Identifiable {
    case snellBold
    case snellRegular
    case zapfino
    case appleChancery
    case hoeflerItalic
    case systemSerif

    static let `default`: DisplayFont = .snellBold

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .snellBold: return "Snell Roundhand — Vet"
        case .snellRegular: return "Snell Roundhand"
        case .zapfino: return "Zapfino"
        case .appleChancery: return "Apple Chancery"
        case .hoeflerItalic: return "Hoefler Text — Cursief"
        case .systemSerif: return "Standaard serif"
        }
    }

    private var postscriptName: String? {
        switch self {
        case .snellBold: return "SnellRoundhand-Bold"
        case .snellRegular: return "SnellRoundhand"
        case .zapfino: return "Zapfino"
        case .appleChancery: return "Apple-Chancery"
        case .hoeflerItalic: return "HoeflerText-Italic"
        case .systemSerif: return nil
        }
    }

    // Calligrafische fonts hebben kleinere x-hoogte; Zapfino is juist groot. Compenseren zodat
    // alle opties visueel ongeveer dezelfde "gewicht" hebben in dezelfde ruimte.
    private var sizeFactor: CGFloat {
        switch self {
        case .snellBold, .snellRegular, .appleChancery: return 1.27
        case .zapfino: return 0.7
        case .hoeflerItalic, .systemSerif: return 1.0
        }
    }

    func font(baseSize: CGFloat) -> Font {
        let size = baseSize * sizeFactor
        if let postscriptName {
            return .custom(postscriptName, size: size)
        } else {
            return .system(size: size, weight: .semibold, design: .serif)
        }
    }
}

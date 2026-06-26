//
//  ReelCount.swift
//  Younique
//
//  Created by Marc van der Sluis on 21/06/2026.
//

import Foundation

enum ReelCount: Int, CaseIterable, Identifiable {
    case two = 2
    case three = 3
    case four = 4
    case five = 5

    var id: Int { rawValue }

    var subtitle: String {
        switch self {
        case .two:
            return String(localized: "Een snelle combinatie van start en einde voor ultrakorte namen.")
        case .three:
            return String(localized: "Start, kern en einde voor korte namen zoals Delano of Keano.")
        case .four:
            return String(localized: "Een extra verbindingspositie maakt langere en vloeiendere namen mogelijk.")
        case .five:
            return String(localized: "Twee tussenposities geven de meest uitgesponnen combinaties in deze stijl.")
        }
    }
}

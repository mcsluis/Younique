//
//  FavoriteName.swift
//  Kampert
//
//  Created by Marc van der Sluis on 22/06/2026.
//

import Foundation
import SwiftData

@Model
final class FavoriteName {
    @Attribute(.unique) var name: String
    var syllables: [String]
    var savedAt: Date

    init(name: String, syllables: [String], savedAt: Date = .now) {
        self.name = name
        self.syllables = syllables
        self.savedAt = savedAt
    }
}

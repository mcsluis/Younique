//
//  FavoriteName.swift
//  Younique
//
//  Created by Marc van der Sluis on 22/06/2026.
//

import Foundation
import SwiftData

// CloudKit-compatible: geen @Attribute(.unique), alle properties hebben defaults.
// Uniciteit van naam wordt afgedwongen in ContentView.toggleFavorite via een
// duplicate-check.
@Model
final class FavoriteName {
    var name: String = ""
    var syllables: [String] = []
    var savedAt: Date = Date.now
    var note: String = ""

    init(name: String, syllables: [String], savedAt: Date = .now, note: String = "") {
        self.name = name
        self.syllables = syllables
        self.savedAt = savedAt
        self.note = note
    }
}

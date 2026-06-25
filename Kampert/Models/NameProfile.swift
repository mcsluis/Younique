//
//  NameProfile.swift
//  Kampert
//
//  Created by Marc van der Sluis on 22/06/2026.
//

import Foundation

struct NameProfile {
    enum Mood {
        case soft
        case firm
        case mixed

        var label: String {
            switch self {
            case .soft: return "zacht"
            case .firm: return "stevig"
            case .mixed: return "gemengd"
            }
        }
    }

    let syllableCount: Int
    let mood: Mood

    init(syllables: [String]) {
        self.syllableCount = syllables.count
        self.mood = Self.mood(for: syllables)
    }

    var summary: String {
        let unit = syllableCount == 1 ? "lettergreep" : "lettergrepen"
        return "\(syllableCount) \(unit) · \(mood.label)"
    }

    private static let firmStarts: Set<Character> = ["k", "t", "p", "b", "d", "x"]
    private static let softStarts: Set<Character> = ["l", "m", "n", "s", "h", "y", "j",
                                                     "a", "e", "i", "o", "u"]

    private static func mood(for syllables: [String]) -> Mood {
        var firm = 0
        var soft = 0

        for syllable in syllables {
            let lower = syllable.lowercased()
            if lower.hasPrefix("st") || lower.hasPrefix("br") || lower.hasPrefix("fr") || lower.hasPrefix("pr") {
                firm += 1
                continue
            }
            guard let first = lower.first else { continue }
            if firmStarts.contains(first) {
                firm += 1
            } else if softStarts.contains(first) {
                soft += 1
            }
        }

        if firm > soft * 2 { return .firm }
        if soft > firm * 2 { return .soft }
        return .mixed
    }
}

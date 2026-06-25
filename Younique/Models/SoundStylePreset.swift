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
        case .softLatin, .stoerKort, .freshModern, .warmSpanish, .romantic:
            return false
        case .dreamySoft, .powerfulBold, .classicEnglish:
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

    var baseDetail: String {
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
            return "Luchtig en sierlijk: ijle openers en elegante eindes voor een dromerige sfeer."
        case .powerfulBold:
            return "Klassieke kracht: stevige starts en gedragen middenstukken, niet kort of edgy."
        case .romantic:
            return "Melodisch en mediterraan: zoete, vloeiende klanken met een sierlijke afwerking."
        case .classicEnglish:
            return "Meer Engelse staarten en een sierlijke, herkenbare klank."
        }
    }

    var primaryTags: Set<SoundStyleTag> {
        switch self {
        case .softLatin:
            return [.latin, .soft]
        case .stoerKort:
            return [.bold, .modern]
        case .freshModern:
            return [.modern, .unisex]
        case .warmSpanish:
            return [.spanish, .latin]
        case .dreamySoft:
            return [.soft, .elegant]
        case .powerfulBold:
            return [.bold]
        case .romantic:
            return [.romantic, .latin]
        case .classicEnglish:
            return [.english, .elegant]
        }
    }

    var secondaryTags: Set<SoundStyleTag> {
        switch self {
        case .softLatin:
            return [.romantic, .elegant]
        case .stoerKort:
            return [.unisex]
        case .freshModern:
            return [.soft]
        case .warmSpanish:
            return [.romantic, .soft]
        case .dreamySoft:
            return [.romantic]
        case .powerfulBold:
            return [.unisex]
        case .romantic:
            return [.soft, .elegant]
        case .classicEnglish:
            return [.romantic]
        }
    }

    var excludedTags: Set<SoundStyleTag> {
        switch self {
        case .softLatin:
            return [.english, .bold]
        case .stoerKort:
            return [.romantic, .english]
        case .freshModern:
            return [.english, .spanish]
        case .warmSpanish:
            return [.english]
        case .dreamySoft:
            return [.bold, .latin]
        case .powerfulBold:
            return [.soft, .romantic, .modern]
        case .romantic:
            return [.bold, .modern]
        case .classicEnglish:
            return [.spanish]
        }
    }

    func availableSyllables(for nameType: NameType, allowedSyllables: Set<String>) -> Set<String> {
        let eligible = Syllable.all.filter { syllable in
            allowedSyllables.contains(syllable.text)
            && syllable.nameTypes.contains(nameType)
            && syllable.styles.isDisjoint(with: excludedTags)
        }

        let ranked = eligible.compactMap { syllable -> (String, Int)? in
            let primaryMatches = syllable.styles.intersection(primaryTags).count
            let secondaryMatches = syllable.styles.intersection(secondaryTags).count
            let score = (primaryMatches * 3) + secondaryMatches

            guard score > 0 else { return nil }
            return (syllable.text, score)
        }

        let preferred = Set(ranked.filter { $0.1 >= 4 }.map(\.0))
        if !preferred.isEmpty {
            return preferred
        }

        let fallback = Set(ranked.map(\.0))
        if !fallback.isEmpty {
            return fallback
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

    @MainActor
    func detailText(for nameType: NameType, allowedSyllables: Set<String>) -> String {
        let samples = sampleSyllables(for: nameType, allowedSyllables: allowedSyllables)
        guard !samples.isEmpty else { return baseDetail }
        return "\(baseDetail) Bijvoorbeeld: \(samples.joined(separator: ", "))."
    }

    @MainActor
    func accentLine(for nameType: NameType, allowedSyllables: Set<String>) -> String {
        sampleSyllables(for: nameType, allowedSyllables: allowedSyllables).joined(separator: ", ")
    }

    @MainActor
    private func sampleSyllables(for nameType: NameType, allowedSyllables: Set<String>) -> [String] {
        let selected = availableSyllables(for: nameType, allowedSyllables: allowedSyllables)
        let models = selected.compactMap(Syllable.withID)

        let sorted = models.sorted { lhs, rhs in
            if lhs.weight == rhs.weight {
                return lhs.text.localizedCaseInsensitiveCompare(rhs.text) == .orderedAscending
            }
            return lhs.weight > rhs.weight
        }

        return Array(sorted.prefix(6).map(\.text))
    }
}

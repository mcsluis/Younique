//
//  NameGenerator.swift
//  Younique
//
//  Created by Marc van der Sluis on 21/06/2026.
//

import Foundation

struct NameGenerator {
    private let leadPool: [Syllable] = [
        Syllable.ash, .bo, .brit, .cha, .cy, .de, .dja, .dje, .ja, .jef, .jo, .ju,
        .ka, .kai, .ke, .ki, .kim, .la, .le, .li, .lo, .lu, .ma, .mel,
        .mi, .mo, .na, .ni, .no, .pri, .ra, .ro, .sa, .sha, .ste,
        .von,
        .ta, .ty, .vi, .you, .za
    ]

    private let bridgePool: [Syllable] = [
        .a, .an, .ce, .ci, .da, .de, .di, .el, .ey, .i,
        .im, .`is`, .it, .la, .le, .li, .lin, .lo, .ly, .na,
        .ney, .ni, .o, .on, .ra, .re, .ri, .ro, .ta, .ti, .va
    ]

    private let corePool: [Syllable] = [
        .ash, .ber, .del, .dev, .ev, .fan, .fre, .jay, .kel, .ley,
        .lon, .man, .mel, .pha, .quel, .rell, .ris, .sha, .shan, .son, .tay, .von
    ]

    private let accentPool: [Syllable] = [
        .a, .ah, .ce, .da, .el, .en, .ey, .ley, .lyn, .lynn,
        .na, .nay, .ney, .ni, .o, .on, .ra, .ri, .ro, .sha,
        .shan, .ta, .tin, .ya
    ]

    private let endingPool: [Syllable] = [
        .a, .ah, .des, .`do`, .el, .en, .ey, .lyn, .lynn, .na, .no,
        .ny, .o, .on, .que, .ra, .ro, .son, .ta, .x, .ya
    ]

    private let neutralFallbackPool = ["ka", "lo", "mi", "ra", "zo"]
    private let girlFallbackPool = ["la", "mi", "na", "ra", "ya"]
    private let boyFallbackPool = ["de", "ka", "no", "ro", "ty"]

    private var combinedPool: [String] {
        rawValues(for: leadPool + bridgePool + corePool + accentPool + endingPool)
    }

    var allSyllables: [String] {
        allSyllables(for: .neutral)
    }

    func allSyllables(for nameType: NameType) -> [String] {
        let filtered = combinedPool.filter { matchesNameType($0, nameType: nameType) }
        return Array(NSOrderedSet(array: filtered)) as? [String] ?? filtered
    }

    func reelOptions(
        for reelCount: ReelCount,
        useSharedPool: Bool,
        excludedGroups: Set<NameFilterGroup>,
        nameType: NameType = .neutral,
        includedSyllables: Set<String>? = nil,
        distributeSelectedAcrossRoles: Bool = false,
        includedSyllablesByReel: [Set<String>]? = nil
    ) -> [[String]] {
        if let includedSyllablesByReel, includedSyllablesByReel.count == reelCount.rawValue {
            return includedSyllablesByReel.map { syllables in
                strictFilteredPool(
                    combinedPool,
                    excludedGroups: excludedGroups,
                    nameType: nameType,
                    includedSyllables: syllables
                )
            }
        }

        if let includedSyllables, !includedSyllables.isEmpty, !distributeSelectedAcrossRoles {
            let selectedPool = strictFilteredPool(
                combinedPool,
                excludedGroups: excludedGroups,
                nameType: nameType,
                includedSyllables: includedSyllables
            )
            return Array(repeating: selectedPool, count: reelCount.rawValue)
        }

        if useSharedPool {
            let sharedPool = strictFilteredPool(
                combinedPool,
                excludedGroups: excludedGroups,
                nameType: nameType,
                includedSyllables: includedSyllables
            )
            return Array(repeating: sharedPool, count: reelCount.rawValue)
        }

        switch reelCount {
        case .two:
            return [
                filteredPool(rawValues(for: leadPool), excludedGroups: excludedGroups, fallback: rawValues(for: leadPool), nameType: nameType, includedSyllables: includedSyllables),
                filteredPool(rawValues(for: endingPool), excludedGroups: excludedGroups, fallback: rawValues(for: endingPool), nameType: nameType, includedSyllables: includedSyllables)
            ]
        case .three:
            return [
                filteredPool(rawValues(for: leadPool), excludedGroups: excludedGroups, fallback: rawValues(for: leadPool), nameType: nameType, includedSyllables: includedSyllables),
                filteredPool(rawValues(for: corePool + bridgePool), excludedGroups: excludedGroups, fallback: rawValues(for: corePool + bridgePool), nameType: nameType, includedSyllables: includedSyllables),
                filteredPool(rawValues(for: endingPool), excludedGroups: excludedGroups, fallback: rawValues(for: endingPool), nameType: nameType, includedSyllables: includedSyllables)
            ]
        case .four:
            return [
                filteredPool(rawValues(for: leadPool), excludedGroups: excludedGroups, fallback: rawValues(for: leadPool), nameType: nameType, includedSyllables: includedSyllables),
                filteredPool(rawValues(for: bridgePool), excludedGroups: excludedGroups, fallback: rawValues(for: bridgePool), nameType: nameType, includedSyllables: includedSyllables),
                filteredPool(rawValues(for: corePool + accentPool), excludedGroups: excludedGroups, fallback: rawValues(for: corePool + accentPool), nameType: nameType, includedSyllables: includedSyllables),
                filteredPool(rawValues(for: endingPool), excludedGroups: excludedGroups, fallback: rawValues(for: endingPool), nameType: nameType, includedSyllables: includedSyllables)
            ]
        case .five:
            return [
                filteredPool(rawValues(for: leadPool), excludedGroups: excludedGroups, fallback: rawValues(for: leadPool), nameType: nameType, includedSyllables: includedSyllables),
                filteredPool(rawValues(for: bridgePool), excludedGroups: excludedGroups, fallback: rawValues(for: bridgePool), nameType: nameType, includedSyllables: includedSyllables),
                filteredPool(rawValues(for: corePool), excludedGroups: excludedGroups, fallback: rawValues(for: corePool), nameType: nameType, includedSyllables: includedSyllables),
                filteredPool(rawValues(for: accentPool), excludedGroups: excludedGroups, fallback: rawValues(for: accentPool), nameType: nameType, includedSyllables: includedSyllables),
                filteredPool(rawValues(for: endingPool), excludedGroups: excludedGroups, fallback: rawValues(for: endingPool), nameType: nameType, includedSyllables: includedSyllables)
            ]
        }
    }

    func randomName(
        reelCount: ReelCount,
        useSharedPool: Bool,
        excludedGroups: Set<NameFilterGroup>,
        nameType: NameType = .neutral,
        includedSyllables: Set<String>? = nil,
        distributeSelectedAcrossRoles: Bool = false,
        includedSyllablesByReel: [Set<String>]? = nil
    ) -> GeneratedName {
        let pools = reelOptions(
            for: reelCount,
            useSharedPool: useSharedPool,
            excludedGroups: excludedGroups,
            nameType: nameType,
            includedSyllables: includedSyllables,
            distributeSelectedAcrossRoles: distributeSelectedAcrossRoles,
            includedSyllablesByReel: includedSyllablesByReel
        )

        var selectedSyllables: [String] = []
        var usedSyllables: Set<String> = []
        selectedSyllables.reserveCapacity(pools.count)
        for pool in pools {
            var candidates = pool.filter { !usedSyllables.contains($0.lowercased()) }
            if candidates.isEmpty { candidates = pool }
            if let previous = selectedSyllables.last {
                let compatible = candidates.filter { Self.flowsWell(after: previous, next: $0) }
                if !compatible.isEmpty { candidates = compatible }
            }
            let pick = candidates.randomElement() ?? "na"
            usedSyllables.insert(pick.lowercased())
            selectedSyllables.append(pick)
        }

        return GeneratedName(
            syllables: selectedSyllables,
            fullName: selectedSyllables.joined()
        )
    }

    // Vowel-consonant alternation prevents V+V vowel collisions ("ka"+"an" → "kaan")
    // and C+C consonant clusters ("brit"+"ste" → "britste"). 'y' counts as vowel at end
    // of a syllable (ny, ly) but as consonant at start (ya, you).
    private static func flowsWell(after previous: String, next: String) -> Bool {
        endsWithVowel(previous) != startsWithVowel(next)
    }

    private static func startsWithVowel(_ syllable: String) -> Bool {
        guard let first = syllable.first else { return false }
        return "aeiou".contains(first)
    }

    private static func endsWithVowel(_ syllable: String) -> Bool {
        guard let last = syllable.last else { return false }
        // "ah", "oh", "eh" eindigen fonetisch op een klinker — de h is een 'breath'.
        if last == "h", syllable.count >= 2 {
            let secondLast = syllable[syllable.index(syllable.endIndex, offsetBy: -2)]
            if "aeiou".contains(secondLast) {
                return true
            }
        }
        return "aeiouy".contains(last)
    }

    private func filteredPool(
        _ pool: [String],
        excludedGroups: Set<NameFilterGroup>,
        fallback: [String],
        nameType: NameType,
        includedSyllables: Set<String>?
    ) -> [String] {
        let selectedFallback = fallback.filter { syllable in
            excludedGroups.isDisjoint(with: groups(for: syllable))
            && matchesNameType(syllable, nameType: nameType)
            && matchesIncludedSyllables(syllable, includedSyllables: includedSyllables)
        }
        let filtered = pool.filter { syllable in
            excludedGroups.isDisjoint(with: groups(for: syllable))
            && matchesNameType(syllable, nameType: nameType)
            && matchesIncludedSyllables(syllable, includedSyllables: includedSyllables)
        }

        if !filtered.isEmpty {
            return filtered
        }

        if let includedSyllables, !includedSyllables.isEmpty {
            return selectedFallback
        }

        return fallback
    }

    private func strictFilteredPool(
        _ pool: [String],
        excludedGroups: Set<NameFilterGroup>,
        nameType: NameType,
        includedSyllables: Set<String>?
    ) -> [String] {
        let filtered = pool.filter { syllable in
            excludedGroups.isDisjoint(with: groups(for: syllable))
            && matchesNameType(syllable, nameType: nameType)
            && matchesIncludedSyllables(syllable, includedSyllables: includedSyllables)
        }

        return filtered.isEmpty ? fallbackPool(for: nameType) : filtered
    }

    private func matchesIncludedSyllables(_ syllable: String, includedSyllables: Set<String>?) -> Bool {
        guard let includedSyllables, !includedSyllables.isEmpty else {
            return true
        }

        let normalizedIncluded = Set(includedSyllables.map { $0.lowercased() })
        return normalizedIncluded.contains(syllable.lowercased())
    }

    private func groups(for syllable: String) -> Set<NameFilterGroup> {
        let value = syllable.lowercased()
        var groups = Set<NameFilterGroup>()

        if ["ka", "ke", "ta", "ste", "pri", "brit"].contains(value) {
            groups.insert(.sharpStarts)
        }
        if ["la", "le", "li", "lu", "ma", "mel", "mi", "na", "ni"].contains(value) {
            groups.insert(.flowStarts)
        }
        if value.contains("dj") || value.contains("sh") || value.contains("jay") || value == "ya" || value == "ty" || value == "you" {
            groups.insert(.urbanAccents)
        }
        if ["ley", "lyn", "lynn", "ney", "son", "ey"].contains(value) {
            groups.insert(.englishTails)
        }
        if ["a", "an", "el", "en", "na", "ra", "de", "di", "i", "o", "on"].contains(value) {
            groups.insert(.softFillers)
        }

        return groups
    }

    private func matchesNameType(_ syllable: String, nameType: NameType) -> Bool {
        let value = syllable.lowercased()

        switch nameType {
        case .girl:
            return !girlDisallowedSyllables.contains(value)
        case .boy:
            return !boyDisallowedSyllables.contains(value)
        case .neutral:
            return !neutralDisallowedSyllables.contains(value)
        }
    }

    private func fallbackPool(for nameType: NameType) -> [String] {
        switch nameType {
        case .girl:
            return girlFallbackPool
        case .boy:
            return boyFallbackPool
        case .neutral:
            return neutralFallbackPool
        }
    }

    private func rawValues(for pool: [Syllable]) -> [String] {
        pool.map(\.rawValue)
    }

    private var girlDisallowedSyllables: Set<String> {
        [
            "jef", "cy", "son", "x", "do", "des", "dev", "del", "kel", "lon",
            "man", "no", "on", "ro", "ty"
        ]
    }

    private var boyDisallowedSyllables: Set<String> {
        [
            "brit", "cha", "dja", "dje", "pri", "sha", "mel", "lyn", "lynn",
            "que", "ya"
        ]
    }

    private var neutralDisallowedSyllables: Set<String> {
        [
            "dja", "dje", "jef", "pri", "brit", "son", "x", "des"
        ]
    }
}

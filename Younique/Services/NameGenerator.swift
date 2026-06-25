//
//  NameGenerator.swift
//  Younique
//
//  Created by Marc van der Sluis on 21/06/2026.
//

import Foundation

struct NameGenerator {
    private let neutralFallbackPool = ["ka", "lo", "mi", "ra", "sol"]
    private let girlFallbackPool = ["la", "mi", "na", "ra", "ya"]
    private let boyFallbackPool = ["de", "ka", "no", "ro", "tor"]

    private var allModels: [Syllable] {
        Syllable.all
    }

    private var modelByText: [String: Syllable] {
        Dictionary(uniqueKeysWithValues: allModels.map { ($0.text.lowercased(), $0) })
    }

    var allSyllables: [String] {
        allSyllables(for: .neutral)
    }

    func allSyllables(for nameType: NameType) -> [String] {
        orderedTexts(
            from: allModels.filter { $0.nameTypes.contains(nameType) }
        )
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
                    allModels,
                    excludedGroups: excludedGroups,
                    nameType: nameType,
                    includedSyllables: syllables
                )
            }
        }

        if let includedSyllables, !includedSyllables.isEmpty, !distributeSelectedAcrossRoles {
            let selectedPool = strictFilteredPool(
                allModels,
                excludedGroups: excludedGroups,
                nameType: nameType,
                includedSyllables: includedSyllables
            )
            return Array(repeating: selectedPool, count: reelCount.rawValue)
        }

        if useSharedPool {
            let sharedPool = strictFilteredPool(
                allModels,
                excludedGroups: excludedGroups,
                nameType: nameType,
                includedSyllables: includedSyllables
            )
            return Array(repeating: sharedPool, count: reelCount.rawValue)
        }

        switch reelCount {
        case .two:
            return [
                filteredPool(
                    rolePool([.lead]),
                    excludedGroups: excludedGroups,
                    fallback: rolePool([.lead]),
                    nameType: nameType,
                    includedSyllables: includedSyllables
                ),
                filteredPool(
                    rolePool([.ending]),
                    excludedGroups: excludedGroups,
                    fallback: rolePool([.ending]),
                    nameType: nameType,
                    includedSyllables: includedSyllables
                )
            ]
        case .three:
            return [
                filteredPool(
                    rolePool([.lead]),
                    excludedGroups: excludedGroups,
                    fallback: rolePool([.lead]),
                    nameType: nameType,
                    includedSyllables: includedSyllables
                ),
                filteredPool(
                    rolePool([.core, .bridge]),
                    excludedGroups: excludedGroups,
                    fallback: rolePool([.core, .bridge]),
                    nameType: nameType,
                    includedSyllables: includedSyllables
                ),
                filteredPool(
                    rolePool([.ending]),
                    excludedGroups: excludedGroups,
                    fallback: rolePool([.ending]),
                    nameType: nameType,
                    includedSyllables: includedSyllables
                )
            ]
        case .four:
            return [
                filteredPool(
                    rolePool([.lead]),
                    excludedGroups: excludedGroups,
                    fallback: rolePool([.lead]),
                    nameType: nameType,
                    includedSyllables: includedSyllables
                ),
                filteredPool(
                    rolePool([.bridge]),
                    excludedGroups: excludedGroups,
                    fallback: rolePool([.bridge]),
                    nameType: nameType,
                    includedSyllables: includedSyllables
                ),
                filteredPool(
                    rolePool([.core, .accent]),
                    excludedGroups: excludedGroups,
                    fallback: rolePool([.core, .accent]),
                    nameType: nameType,
                    includedSyllables: includedSyllables
                ),
                filteredPool(
                    rolePool([.ending]),
                    excludedGroups: excludedGroups,
                    fallback: rolePool([.ending]),
                    nameType: nameType,
                    includedSyllables: includedSyllables
                )
            ]
        case .five:
            return [
                filteredPool(
                    rolePool([.lead]),
                    excludedGroups: excludedGroups,
                    fallback: rolePool([.lead]),
                    nameType: nameType,
                    includedSyllables: includedSyllables
                ),
                filteredPool(
                    rolePool([.bridge]),
                    excludedGroups: excludedGroups,
                    fallback: rolePool([.bridge]),
                    nameType: nameType,
                    includedSyllables: includedSyllables
                ),
                filteredPool(
                    rolePool([.core]),
                    excludedGroups: excludedGroups,
                    fallback: rolePool([.core]),
                    nameType: nameType,
                    includedSyllables: includedSyllables
                ),
                filteredPool(
                    rolePool([.accent]),
                    excludedGroups: excludedGroups,
                    fallback: rolePool([.accent]),
                    nameType: nameType,
                    includedSyllables: includedSyllables
                ),
                filteredPool(
                    rolePool([.ending]),
                    excludedGroups: excludedGroups,
                    fallback: rolePool([.ending]),
                    nameType: nameType,
                    includedSyllables: includedSyllables
                )
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
            let pick = weightedChoice(from: candidates) ?? "na"
            usedSyllables.insert(pick.lowercased())
            selectedSyllables.append(pick)
        }

        return GeneratedName(
            syllables: selectedSyllables,
            fullName: selectedSyllables.joined()
        )
    }

    // Vowel-consonant alternation prevents V+V vowel collisions (\"ka\"+\"an\" → \"kaan\")
    // and C+C consonant clusters (\"brit\"+\"ste\" → \"britste\"). 'y' counts as vowel at end
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
        if last == "h", syllable.count >= 2 {
            let secondLast = syllable[syllable.index(syllable.endIndex, offsetBy: -2)]
            if "aeiou".contains(secondLast) {
                return true
            }
        }
        return "aeiouy".contains(last)
    }

    private func filteredPool(
        _ pool: [Syllable],
        excludedGroups: Set<NameFilterGroup>,
        fallback: [Syllable],
        nameType: NameType,
        includedSyllables: Set<String>?
    ) -> [String] {
        let selectedFallback = filteredModels(
            fallback,
            excludedGroups: excludedGroups,
            nameType: nameType,
            includedSyllables: includedSyllables
        )
        let filtered = filteredModels(
            pool,
            excludedGroups: excludedGroups,
            nameType: nameType,
            includedSyllables: includedSyllables
        )

        if !filtered.isEmpty {
            return orderedTexts(from: filtered)
        }

        if let includedSyllables, !includedSyllables.isEmpty {
            return orderedTexts(from: selectedFallback)
        }

        return orderedTexts(from: fallback)
    }

    private func strictFilteredPool(
        _ pool: [Syllable],
        excludedGroups: Set<NameFilterGroup>,
        nameType: NameType,
        includedSyllables: Set<String>?
    ) -> [String] {
        let filtered = filteredModels(
            pool,
            excludedGroups: excludedGroups,
            nameType: nameType,
            includedSyllables: includedSyllables
        )

        if !filtered.isEmpty {
            return orderedTexts(from: filtered)
        }

        return fallbackPool(for: nameType)
    }

    private func filteredModels(
        _ models: [Syllable],
        excludedGroups: Set<NameFilterGroup>,
        nameType: NameType,
        includedSyllables: Set<String>?
    ) -> [Syllable] {
        let normalizedIncluded = includedSyllables.map { Set($0.map { value in value.lowercased() }) }
        return models.filter { syllable in
            syllable.groups.isDisjoint(with: excludedGroups)
            && syllable.nameTypes.contains(nameType)
            && (normalizedIncluded == nil || normalizedIncluded!.contains(syllable.text.lowercased()))
        }
    }

    private func rolePool(_ roles: Set<SyllableRole>) -> [Syllable] {
        allModels.filter { !$0.preferredRoles.isDisjoint(with: roles) }
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

    private func orderedTexts(from models: [Syllable]) -> [String] {
        let filtered = models.map(\.text)
        return Array(NSOrderedSet(array: filtered)) as? [String] ?? filtered
    }

    private func weightedChoice(from candidates: [String]) -> String? {
        guard !candidates.isEmpty else { return nil }

        let weightedCandidates = candidates.map { candidate in
            let weight = modelByText[candidate.lowercased()]?.weight ?? 1.0
            return (candidate, max(weight, 0.1))
        }

        let totalWeight = weightedCandidates.reduce(0.0) { $0 + $1.1 }
        guard totalWeight > 0 else { return candidates.randomElement() }

        var threshold = Double.random(in: 0..<totalWeight)
        for (candidate, weight) in weightedCandidates {
            threshold -= weight
            if threshold <= 0 {
                return candidate
            }
        }

        return weightedCandidates.last?.0
    }
}

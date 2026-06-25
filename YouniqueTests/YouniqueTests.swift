//
//  YouniqueTests.swift
//  YouniqueTests
//
//  Created by Marc van der Sluis on 21/06/2026.
//

import Testing
@testable import Younique

struct YouniqueTests {

    @Test(arguments: ReelCount.allCases)
    @MainActor
    func randomNameUsesRequestedReelCount(reelCount: ReelCount) async throws {
        let generator = NameGenerator()
        let name = generator.randomName(
            reelCount: reelCount,
            useSharedPool: false,
            excludedGroups: [],
            includedSyllables: nil,
            distributeSelectedAcrossRoles: false,
            includedSyllablesByReel: nil
        )

        #expect(name.syllables.count == reelCount.rawValue)
        #expect(name.fullName == name.syllables.joined())
    }

    @Test(arguments: ReelCount.allCases)
    @MainActor
    func reelOptionsMatchRequestedReelCount(reelCount: ReelCount) async throws {
        let generator = NameGenerator()
        let options = generator.reelOptions(
            for: reelCount,
            useSharedPool: false,
            excludedGroups: [],
            includedSyllables: nil,
            distributeSelectedAcrossRoles: false,
            includedSyllablesByReel: nil
        )

        #expect(options.count == reelCount.rawValue)
        #expect(options.allSatisfy { !$0.isEmpty })
    }

    @Test(arguments: ReelCount.allCases)
    @MainActor
    func sharedPoolUsesSameOptionsForEachReel(reelCount: ReelCount) async throws {
        let generator = NameGenerator()
        let options = generator.reelOptions(
            for: reelCount,
            useSharedPool: true,
            excludedGroups: [],
            includedSyllables: nil,
            distributeSelectedAcrossRoles: false,
            includedSyllablesByReel: nil
        )

        #expect(options.count == reelCount.rawValue)
        #expect(options.allSatisfy { !$0.isEmpty })
        #expect(options.dropFirst().allSatisfy { $0 == options.first })
    }

    @Test
    @MainActor
    func excludedGroupsStillReturnUsablePools() async throws {
        let generator = NameGenerator()
        let options = generator.reelOptions(
            for: .five,
            useSharedPool: false,
            excludedGroups: Set(NameFilterGroup.allCases),
            includedSyllables: nil,
            distributeSelectedAcrossRoles: false,
            includedSyllablesByReel: nil
        )

        #expect(options.count == ReelCount.five.rawValue)
        #expect(options.allSatisfy { !$0.isEmpty })
    }

    @Test
    @MainActor
    func sharedPoolDoesNotFallBackToExcludedGroups() async throws {
        let generator = NameGenerator()
        let options = generator.reelOptions(
            for: .three,
            useSharedPool: true,
            excludedGroups: Set(NameFilterGroup.allCases),
            includedSyllables: nil,
            distributeSelectedAcrossRoles: false,
            includedSyllablesByReel: nil
        )

        let flattened = Set(options.flatMap { $0.map { $0.lowercased() } })

        #expect(options.count == ReelCount.three.rawValue)
        #expect(!flattened.isEmpty)
        // Voorbeelden uit elke uitgesloten groep mogen niet voorkomen
        #expect(!flattened.contains("ka"), "ka (sharpStarts) zou uitgesloten moeten zijn")
        #expect(!flattened.contains("la"), "la (flowStarts) zou uitgesloten moeten zijn")
        #expect(!flattened.contains("a"), "a (softFillers) zou uitgesloten moeten zijn")
        #expect(!flattened.contains("ley"), "ley (englishTails) zou uitgesloten moeten zijn")
        #expect(!flattened.contains("dja"), "dja (urbanAccents) zou uitgesloten moeten zijn")
    }

    @Test
    @MainActor
    func includedSyllablesRestrictGeneratedPools() async throws {
        let generator = NameGenerator()
        let included = Set(["De", "no", "ra"])
        let options = generator.reelOptions(
            for: .three,
            useSharedPool: true,
            excludedGroups: [],
            includedSyllables: included,
            distributeSelectedAcrossRoles: false,
            includedSyllablesByReel: nil
        )

        let flattened = Set(options.flatMap { $0 })

        #expect(flattened == Set(included.map { $0.lowercased() }))
    }

    @Test
    @MainActor
    func roleBasedSelectionNeverReintroducesUnselectedSyllables() async throws {
        let generator = NameGenerator()
        let included = Set(["De", "ra"])
        let options = generator.reelOptions(
            for: .three,
            useSharedPool: false,
            excludedGroups: [],
            includedSyllables: included,
            distributeSelectedAcrossRoles: true,
            includedSyllablesByReel: nil
        )

        let flattened = Set(options.flatMap { $0 })

        #expect(flattened.isSubset(of: Set(included.map { $0.lowercased() })))
    }

    @Test
    @MainActor
    func selectedSyllablesAreAvailableOnEveryReel() async throws {
        let generator = NameGenerator()
        let included = Set(["Ash", "no", "ra", "ley", "mi"])
        let options = generator.reelOptions(
            for: .five,
            useSharedPool: false,
            excludedGroups: [],
            includedSyllables: included,
            distributeSelectedAcrossRoles: false,
            includedSyllablesByReel: nil
        )

        #expect(options.count == ReelCount.five.rawValue)
        #expect(options.allSatisfy { Set($0) == Set(included.map { $0.lowercased() }) })
    }

    @Test
    @MainActor
    func perReelManualSelectionKeepsOwnPoolPerReel() async throws {
        let generator = NameGenerator()
        let byReel = [
            Set(["Ash", "De"]),
            Set(["no", "ra"]),
            Set(["ley", "mi"])
        ]
        let options = generator.reelOptions(
            for: .three,
            useSharedPool: false,
            excludedGroups: [],
            includedSyllables: nil,
            distributeSelectedAcrossRoles: false,
            includedSyllablesByReel: byReel
        )

        #expect(options.count == ReelCount.three.rawValue)
        #expect(Set(options[0]) == Set(byReel[0].map { $0.lowercased() }))
        #expect(Set(options[1]) == Set(byReel[1].map { $0.lowercased() }))
        #expect(Set(options[2]) == Set(byReel[2].map { $0.lowercased() }))
    }

    @Test
    @MainActor
    func girlNameTypeFiltersMasculineSyllables() async throws {
        let generator = NameGenerator()
        let options = generator.reelOptions(
            for: .three,
            useSharedPool: true,
            excludedGroups: [],
            nameType: .girl,
            includedSyllables: nil,
            distributeSelectedAcrossRoles: false,
            includedSyllablesByReel: nil
        )

        let flattened = Set(options.flatMap { $0.map { $0.lowercased() } })

        #expect(!flattened.contains("son"))
        #expect(!flattened.contains("x"))
        #expect(flattened.contains("lyn"))
    }

    @Test
    @MainActor
    func boyNameTypeFiltersFeminineSyllables() async throws {
        let generator = NameGenerator()
        let options = generator.reelOptions(
            for: .three,
            useSharedPool: true,
            excludedGroups: [],
            nameType: .boy,
            includedSyllables: nil,
            distributeSelectedAcrossRoles: false,
            includedSyllablesByReel: nil
        )

        let flattened = Set(options.flatMap { $0.map { $0.lowercased() } })

        #expect(!flattened.contains("lyn"))
        #expect(!flattened.contains("ya"))
        #expect(flattened.contains("son"))
    }

    @Test
    @MainActor
    func warmSpanishPresetAvoidsEnglishTaggedSyllables() {
        let allowed = Set(NameGenerator().allSyllables(for: .neutral))
        let selected = SoundStylePreset.warmSpanish.availableSyllables(
            for: .neutral,
            allowedSyllables: allowed
        )

        let selectedModels = selected.compactMap(Syllable.withID)

        #expect(!selectedModels.isEmpty)
        #expect(selectedModels.allSatisfy { $0.styles.contains(.spanish) || $0.styles.contains(.latin) })
        #expect(selectedModels.allSatisfy { !$0.styles.contains(.english) })
    }

    @Test
    @MainActor
    func classicEnglishPresetAvoidsSpanishTaggedSyllables() {
        let allowed = Set(NameGenerator().allSyllables(for: .neutral))
        let selected = SoundStylePreset.classicEnglish.availableSyllables(
            for: .neutral,
            allowedSyllables: allowed
        )

        let selectedModels = selected.compactMap(Syllable.withID)

        #expect(!selectedModels.isEmpty)
        #expect(selectedModels.allSatisfy { $0.styles.contains(.english) || $0.styles.contains(.elegant) })
        #expect(selectedModels.allSatisfy { !$0.styles.contains(.spanish) })
    }

    // MARK: - V/C-alternation regel

    @Test(arguments: ReelCount.allCases)
    @MainActor
    func generatedNamesAlternateVowelAndConsonant(reelCount: ReelCount) async throws {
        let generator = NameGenerator()
        // 50 iteraties om random variatie te dekken, met grote default pool.
        for _ in 0..<50 {
            let name = generator.randomName(
                reelCount: reelCount,
                useSharedPool: false,
                excludedGroups: [],
                includedSyllables: nil,
                distributeSelectedAcrossRoles: false,
                includedSyllablesByReel: nil
            )
            let syllables = name.syllables
            guard syllables.count > 1 else { continue }
            for i in 0..<(syllables.count - 1) {
                let current = syllables[i]
                let next = syllables[i + 1]
                let currentEndsVowel = TestHelpers.endsWithVowel(current)
                let nextStartsVowel = TestHelpers.startsWithVowel(next)
                #expect(
                    currentEndsVowel != nextStartsVowel,
                    "V/C-regel geschonden tussen '\(current)' en '\(next)' in \(name.fullName)"
                )
            }
        }
    }

    // MARK: - Dedup binnen één gegenereerde naam

    @Test(arguments: ReelCount.allCases)
    @MainActor
    func generatedNamesHaveNoDuplicateSyllables(reelCount: ReelCount) async throws {
        let generator = NameGenerator()
        for _ in 0..<50 {
            let name = generator.randomName(
                reelCount: reelCount,
                useSharedPool: false,
                excludedGroups: [],
                includedSyllables: nil,
                distributeSelectedAcrossRoles: false,
                includedSyllablesByReel: nil
            )
            let lowered = name.syllables.map { $0.lowercased() }
            #expect(
                Set(lowered).count == lowered.count,
                "Dubbele syllable gevonden in '\(name.fullName)' — \(name.syllables)"
            )
        }
    }

    // MARK: - FavoriteName model

    @Test
    func favoriteNameInitializesWithDefaults() {
        let favorite = FavoriteName(name: "Anna", syllables: ["an", "na"])
        #expect(favorite.name == "Anna")
        #expect(favorite.syllables == ["an", "na"])
        #expect(favorite.note == "")
    }

    @Test
    func favoriteNameAcceptsNote() {
        let favorite = FavoriteName(
            name: "Karina",
            syllables: ["ka", "ri", "na"],
            note: "favo van mama"
        )
        #expect(favorite.note == "favo van mama")
    }

    @Test
    func favoriteNameNoteIsMutable() {
        let favorite = FavoriteName(name: "Mira", syllables: ["mi", "ra"])
        favorite.note = "klinkt zacht"
        #expect(favorite.note == "klinkt zacht")
    }
}

// MARK: - Test helpers (mirror van private logica in NameGenerator)

private enum TestHelpers {
    static func startsWithVowel(_ syllable: String) -> Bool {
        guard let first = syllable.lowercased().first else { return false }
        return "aeiou".contains(first)
    }

    static func endsWithVowel(_ syllable: String) -> Bool {
        let lower = syllable.lowercased()
        guard let last = lower.last else { return false }
        // Vh-uitzondering: "ah", "oh", "eh" tellen als klinker-eind.
        if last == "h", lower.count >= 2 {
            let secondLast = lower[lower.index(lower.endIndex, offsetBy: -2)]
            if "aeiou".contains(secondLast) {
                return true
            }
        }
        return "aeiouy".contains(last)
    }
}

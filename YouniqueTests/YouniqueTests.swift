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
        #expect(flattened == Set(["ka", "lo", "mi", "ra", "zo"]))
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
}

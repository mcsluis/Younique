//
//  NameGeneratorViewModel.swift
//  Younique
//
//  Created by Marc van der Sluis on 21/06/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class NameGeneratorViewModel {
    var reelCount: ReelCount = .two {
        didSet {
            guard !isCreating else { return }
            activeReelSelectionIndex = min(activeReelSelectionIndex, reelCount.rawValue - 1)
            resetGeneratedState()
        }
    }

    var selectionMode: SyllableSelectionMode = .automatic {
        didSet {
            guard !isCreating else { return }
            syncActiveSoundStylePreset()
            resetGeneratedState()
        }
    }

    var nameType: NameType = .neutral {
        didSet {
            guard !isCreating else { return }
            sanitizeSelectionsForCurrentNameType()
            syncActiveSoundStylePreset()
            resetGeneratedState()
        }
    }

    var excludedGroups = Set<NameFilterGroup>() {
        didSet {
            guard !isCreating else { return }
            syncActiveSoundStylePreset()
            resetGeneratedState()
        }
    }

    var selectedSyllables = Set<String>() {
        didSet {
            guard !isCreating else { return }
            syncActiveSoundStylePreset()
            resetGeneratedState()
        }
    }

    var perReelSelectedSyllables: [Int: Set<String>] = [:] {
        didSet {
            guard !isCreating else { return }
            syncActiveSoundStylePreset()
            resetGeneratedState()
        }
    }

    var activeReelSelectionIndex = 0
    var activeSoundStylePreset: SoundStylePreset?

    var displayedName: String?
    var reels: [String] = []
    var spinningReels: [Bool] = []
    var isCreating = false
    var isOverlayPresented = false

    private let generator = NameGenerator()
    private var recentNames: [String] = []
    private let recentNamesLimit = 30
    private let dedupRetryLimit = 5
    private var isApplyingSoundStylePreset = false

    var allSyllables: [String] {
        generator.allSyllables(for: nameType)
    }

    var includedSyllables: Set<String>? {
        switch selectionMode {
        case .sharedManual, .distributedManual:
            return selectedSyllables
        case .automatic, .automaticShared, .perReelManual:
            return nil
        }
    }

    var includedSyllablesByReel: [Set<String>]? {
        guard selectionMode == .perReelManual else { return nil }
        return (0..<reelCount.rawValue).map { perReelSelectedSyllables[$0] ?? [] }
    }

    var distributeSelectedAcrossRoles: Bool {
        selectionMode == .distributedManual
    }

    var canGenerate: Bool {
        switch selectionMode {
        case .automatic, .automaticShared:
            return true
        case .sharedManual, .distributedManual:
            return !selectedSyllables.isEmpty
        case .perReelManual:
            return (0..<reelCount.rawValue).allSatisfy { !(perReelSelectedSyllables[$0] ?? []).isEmpty }
        }
    }

    var roleExplanation: String {
        if selectionMode == .distributedManual {
            return "Handmatige selectie met positieverdeling: alleen jouw gekozen lettergrepen worden gebruikt, verdeeld per positie."
        }

        if selectionMode == .sharedManual {
            return "Handmatige selectie zonder positieverdeling: elke positie gebruikt dezelfde gekozen lettergrepen."
        }

        if selectionMode == .perReelManual {
            return "Volledig handmatig: per positie bepaal je zelf welke lettergrepen beschikbaar zijn."
        }

        if selectionMode == .automaticShared {
            return "Vrije stand: elke positie gebruikt dezelfde volledige lettergreep-pool, dus herhaling mag."
        }

        if !excludedGroups.isEmpty {
            return "Gefilterd op hoofdgroepen: de positieverdeling blijft actief, maar uitgesloten klankfamilies worden overgeslagen."
        }

        switch reelCount {
        case .two:
            return "Verdeling: een beginpositie en een eindpositie voor korte, directe namen."
        case .three:
            return "Verdeling: een beginpositie, een volle middenpositie en een duidelijke eindpositie."
        case .four:
            return "Verdeling: begin, verbinding, kern en eindklank voor langere maar nog vloeiende namen."
        case .five:
            return "Verdeling: begin, brug, kern, extra kleur en een sterke afsluiter."
        }
    }

    func toggleGroup(_ group: NameFilterGroup) {
        if excludedGroups.contains(group) {
            excludedGroups.remove(group)
        } else {
            excludedGroups.insert(group)
        }
    }

    func toggleSyllable(_ syllable: String) {
        switch selectionMode {
        case .sharedManual, .distributedManual:
            if selectedSyllables.contains(syllable) {
                selectedSyllables.remove(syllable)
            } else {
                selectedSyllables.insert(syllable)
            }
        case .perReelManual:
            var current = perReelSelectedSyllables[activeReelSelectionIndex] ?? []
            if current.contains(syllable) {
                current.remove(syllable)
            } else {
                current.insert(syllable)
            }
            perReelSelectedSyllables[activeReelSelectionIndex] = current
        case .automatic, .automaticShared:
            break
        }
    }

    func applySoundStylePreset(_ preset: SoundStylePreset) {
        let allowedSyllables = Set(allSyllables)
        let presetSelection = preset.availableSyllables(for: nameType, allowedSyllables: allowedSyllables)

        isApplyingSoundStylePreset = true
        excludedGroups.removeAll()
        perReelSelectedSyllables.removeAll()
        activeReelSelectionIndex = 0
        selectionMode = .sharedManual
        selectedSyllables = presetSelection
        activeSoundStylePreset = preset
        isApplyingSoundStylePreset = false
        resetGeneratedState()
    }

    func isSyllableSelected(_ syllable: String) -> Bool {
        switch selectionMode {
        case .sharedManual, .distributedManual:
            return selectedSyllables.contains(syllable)
        case .perReelManual:
            return (perReelSelectedSyllables[activeReelSelectionIndex] ?? []).contains(syllable)
        case .automatic, .automaticShared:
            return false
        }
    }

    func selectedCountText() -> String {
        switch selectionMode {
        case .sharedManual, .distributedManual:
            return "Geselecteerd: \(selectedSyllables.count)"
        case .perReelManual:
            let count = (perReelSelectedSyllables[activeReelSelectionIndex] ?? []).count
            return "Positie \(activeReelSelectionIndex + 1): \(count) geselecteerd"
        case .automatic, .automaticShared:
            return ""
        }
    }

    func resetCurrentSyllableSelection() {
        switch selectionMode {
        case .sharedManual, .distributedManual:
            selectedSyllables.removeAll()
        case .perReelManual:
            perReelSelectedSyllables[activeReelSelectionIndex] = []
        case .automatic, .automaticShared:
            break
        }
    }

    func dismissOverlay() {
        guard !isCreating else { return }
        resetGeneratedState()
    }

    func presentOverlay() {
        guard !isCreating else { return }
        displayedName = nil
        reels = []
        spinningReels = []
        isOverlayPresented = true
    }

    func spinReels() async {
        guard !isCreating else { return }

        let options = generator.reelOptions(
            for: reelCount,
            useSharedPool: selectionMode == .automaticShared,
            excludedGroups: (selectionMode == .automatic || selectionMode == .automaticShared) ? excludedGroups : [],
            nameType: nameType,
            includedSyllables: includedSyllables,
            distributeSelectedAcrossRoles: distributeSelectedAcrossRoles,
            includedSyllablesByReel: includedSyllablesByReel
        )
        var result = generator.randomName(
            reelCount: reelCount,
            useSharedPool: selectionMode == .automaticShared,
            excludedGroups: (selectionMode == .automatic || selectionMode == .automaticShared) ? excludedGroups : [],
            nameType: nameType,
            includedSyllables: includedSyllables,
            distributeSelectedAcrossRoles: distributeSelectedAcrossRoles,
            includedSyllablesByReel: includedSyllablesByReel
        )
        var retries = 0
        while retries < dedupRetryLimit && recentNames.contains(result.fullName.capitalizedName) {
            result = generator.randomName(
                reelCount: reelCount,
                useSharedPool: selectionMode == .automaticShared,
                excludedGroups: (selectionMode == .automatic || selectionMode == .automaticShared) ? excludedGroups : [],
                nameType: nameType,
                includedSyllables: includedSyllables,
                distributeSelectedAcrossRoles: distributeSelectedAcrossRoles,
                includedSyllablesByReel: includedSyllablesByReel
            )
            retries += 1
        }
        recentNames.append(result.fullName.capitalizedName)
        if recentNames.count > recentNamesLimit {
            recentNames.removeFirst(recentNames.count - recentNamesLimit)
        }

        reels = options.map { $0.randomElement() ?? "na" }
        isCreating = true
        displayedName = nil
        isOverlayPresented = true
        spinningReels = Array(repeating: true, count: options.count)

        await withTaskGroup(of: Void.self) { group in
            for (index, reelOptions) in options.enumerated() {
                let cycles = 14 + (index * 4)
                let finalValue = result.syllables[index]

                group.addTask { [self] in
                    await spinSingleReel(
                        index: index,
                        options: reelOptions,
                        finalValue: finalValue,
                        cycles: cycles
                    )
                }
            }
        }

        displayedName = result.fullName.capitalizedName
        isCreating = false
    }

    private func resetGeneratedState() {
        displayedName = nil
        reels = []
        spinningReels = []
        isOverlayPresented = false
    }

    private func sanitizeSelectionsForCurrentNameType() {
        let allowed = Set(allSyllables)

        selectedSyllables = selectedSyllables.intersection(allowed)
        perReelSelectedSyllables = perReelSelectedSyllables.mapValues { $0.intersection(allowed) }
    }

    private func syncActiveSoundStylePreset() {
        guard !isApplyingSoundStylePreset else { return }

        guard excludedGroups.isEmpty else {
            activeSoundStylePreset = nil
            return
        }

        if selectionMode == .perReelManual {
            return
        }

        guard selectionMode == .sharedManual || selectionMode == .distributedManual else {
            activeSoundStylePreset = nil
            return
        }

        let allowedSyllables = Set(allSyllables)
        activeSoundStylePreset = SoundStylePreset.allCases.first { preset in
            preset.availableSyllables(for: nameType, allowedSyllables: allowedSyllables) == selectedSyllables
        }
    }

    private func spinSingleReel(index: Int, options: [String], finalValue: String, cycles: Int) async {
        for _ in 0..<cycles {
            let next = options.randomElement() ?? finalValue
            reels[index] = next
            try? await Task.sleep(for: .milliseconds(85))
        }

        reels[index] = finalValue
        spinningReels[index] = false
    }
}

private extension String {
    var capitalizedName: String {
        prefix(1).uppercased() + dropFirst()
    }
}

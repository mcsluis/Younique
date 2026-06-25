//
//  NameGeneratorViewModel.swift
//  Kampert
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
            applyPreviewName()
        }
    }

    var useSharedPool = false {
        didSet {
            guard !isCreating else { return }
            applyPreviewName()
        }
    }

    var excludedGroups = Set<NameFilterGroup>() {
        didSet {
            guard !isCreating else { return }
            applyPreviewName()
        }
    }

    var displayedName = "Dano"
    var reels = ["Da", "no"]
    var spinningReels = [false, false]
    var isCreating = false

    private let generator = NameGenerator()

    init() {
        applyPreviewName()
    }

    var roleExplanation: String {
        if useSharedPool {
            return "Vrije stand: elke rol gebruikt dezelfde volledige lettergreep-pool, dus herhaling mag."
        }

        if !excludedGroups.isEmpty {
            return "Gefilterd op hoofdgroepen: de rolverdeling blijft actief, maar uitgesloten klankfamilies worden overgeslagen."
        }

        switch reelCount {
        case .two:
            return "Verdeling: een beginrol en een eindrol voor korte, directe namen."
        case .three:
            return "Verdeling: een beginrol, een volle middenrol en een duidelijke eindrol."
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

    func spinReels() async {
        guard !isCreating else { return }

        let options = generator.reelOptions(
            for: reelCount,
            useSharedPool: useSharedPool,
            excludedGroups: excludedGroups
        )
        let result = generator.randomName(
            reelCount: reelCount,
            useSharedPool: useSharedPool,
            excludedGroups: excludedGroups
        )

        isCreating = true
        displayedName = "..."
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

    private func applyPreviewName() {
        let preview = generator.randomName(
            reelCount: reelCount,
            useSharedPool: useSharedPool,
            excludedGroups: excludedGroups
        )
        displayedName = preview.fullName.capitalizedName
        reels = preview.syllables
        spinningReels = Array(repeating: false, count: preview.syllables.count)
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

//
//  SyllableChip.swift
//  Younique
//
//  Created by Marc van der Sluis on 21/06/2026.
//

import SwiftUI

struct SyllableChip: View {
    let syllable: String
    let isSelected: Bool
    let isLocked: Bool
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(syllable)
                    .font(.system(size: 14, weight: .bold, design: .rounded))

                if isLocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 10, weight: .bold))
                }
            }
                .foregroundStyle(isSelected ? .white : (isLocked ? Theme.inkSoft : Theme.ink))
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Theme.ink : (isLocked ? Theme.surfaceSoft : Theme.surface))
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .stroke(isSelected ? Color.clear : Theme.borderStrong, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .accessibilityLabel("Lettergreep \(syllable)")
        .accessibilityValue(isLocked ? "Vergrendeld" : (isSelected ? "Geselecteerd" : "Niet geselecteerd"))
        .accessibilityHint(isDisabled ? "Nu niet beschikbaar." : (isLocked ? "Dubbeltik om Premium te bekijken." : "Dubbeltik om de selectie te wijzigen."))
    }
}

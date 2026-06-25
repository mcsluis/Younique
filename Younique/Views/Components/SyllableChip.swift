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
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(syllable)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(isSelected ? .white : Theme.ink)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Theme.ink : Theme.surface)
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .stroke(isSelected ? Color.clear : Theme.borderStrong, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .accessibilityLabel("Lettergreep \(syllable)")
        .accessibilityValue(isSelected ? "Geselecteerd" : "Niet geselecteerd")
        .accessibilityHint(isDisabled ? "Nu niet beschikbaar." : "Dubbeltik om de selectie te wijzigen.")
    }
}

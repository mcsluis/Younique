//
//  ReelCard.swift
//  Younique
//
//  Created by Marc van der Sluis on 21/06/2026.
//

import SwiftUI

struct ReelCard: View {
    let syllable: String
    let isSpinning: Bool
    let reelCount: ReelCount

    @ScaledMetric(relativeTo: .title2) private var scaledHeight: CGFloat = 124
    @ScaledMetric(relativeTo: .title2) private var scaledFontSize: CGFloat = 36

    private var height: CGFloat {
        switch reelCount {
        case .two:
            return scaledHeight
        case .three:
            return scaledHeight - 4
        case .four:
            return scaledHeight - 12
        case .five:
            return scaledHeight - 22
        }
    }

    private var fontSize: CGFloat {
        switch reelCount {
        case .two:
            return scaledFontSize
        case .three:
            return scaledFontSize - 2
        case .four:
            return scaledFontSize - 6
        case .five:
            return scaledFontSize - 11
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Theme.cardTop,
                            Theme.card
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(isSpinning ? Theme.accent.opacity(0.10) : Theme.accent.opacity(0.22), lineWidth: 1)

            Text(syllable)
                .font(.system(size: fontSize, weight: .semibold, design: .serif))
                .foregroundStyle(Theme.ink.opacity(isSpinning ? 0.45 : 1))
                .tracking(0.5)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
                .contentTransition(.numericText())
                .padding(.horizontal, 4)
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .scaleEffect(isSpinning ? 0.94 : 1)
        .shadow(color: Theme.ink.opacity(isSpinning ? 0.04 : 0.12), radius: isSpinning ? 8 : 16, y: isSpinning ? 4 : 10)
        .animation(.spring(response: 0.45, dampingFraction: 0.62), value: isSpinning)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Positie")
        .accessibilityValue(isSpinning ? String(localized: "Draait") : syllable)
    }
}

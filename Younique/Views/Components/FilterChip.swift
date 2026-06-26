//
//  FilterChip.swift
//  Younique
//
//  Created by Marc van der Sluis on 21/06/2026.
//

import SwiftUI

struct FilterChip: View {
    let group: NameFilterGroup
    let isExcluded: Bool
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                Text(group.title)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                Text(group.detail)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(isExcluded ? .white.opacity(0.85) : Theme.inkSoft)
                    .lineLimit(2)
            }
            .foregroundStyle(isExcluded ? .white : Theme.ink)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(isExcluded ? Theme.accent : Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isExcluded ? Color.clear : Theme.border, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .accessibilityLabel(group.title)
        .accessibilityValue(isExcluded ? String(localized: "Verborgen") : String(localized: "Zichtbaar"))
        .accessibilityHint(isDisabled
            ? String(localized: "Nu niet beschikbaar.")
            : String(localized: "Dubbeltik om deze klankgroep te verbergen of weer toe te laten."))
    }
}

//
//  SettingsView.swift
//  Younique
//
//  Created by Marc van der Sluis on 23/06/2026.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("displayFont") private var displayFontRaw: String = DisplayFont.default.rawValue
    @Environment(\.dismiss) private var dismiss

    private let previewName = "Younique"

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(DisplayFont.allCases) { option in
                        Button {
                            displayFontRaw = option.rawValue
                        } label: {
                            HStack(alignment: .center, spacing: 12) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(option.displayName)
                                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                                        .foregroundStyle(Theme.ink)

                                    Text(previewName)
                                        .font(option.font(baseSize: 34))
                                        .foregroundStyle(Theme.ink)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                }

                                Spacer(minLength: 8)

                                if option.rawValue == displayFontRaw {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 22, weight: .semibold))
                                        .foregroundStyle(Theme.accent)
                                }
                            }
                            .padding(.vertical, 6)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                } header: {
                    Text("Lettertype gegenereerde naam")
                } footer: {
                    Text("Tik een lettertype om het te kiezen. Het voorbeeld toont hoe een naam eruitziet.")
                }
            }
            .navigationTitle("Instellingen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Klaar") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}

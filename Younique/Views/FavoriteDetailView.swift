//
//  FavoriteDetailView.swift
//  Younique
//
//  Created by Marc van der Sluis on 25/06/2026.
//

import SwiftUI
import SwiftData

struct FavoriteDetailView: View {
    @Bindable var favorite: FavoriteName
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.locale) private var locale
    @FocusState private var isNoteFocused: Bool

    @AppStorage("displayFont") private var displayFontRaw: String = DisplayFont.default.rawValue

    private var displayFont: DisplayFont {
        DisplayFont(rawValue: displayFontRaw) ?? .default
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Theme.creamTop, Theme.creamMid, Theme.sageBottom],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(spacing: 8) {
                            Text(favorite.name)
                                .font(displayFont.font(baseSize: 48))
                                .foregroundStyle(Theme.ink)
                                .multilineTextAlignment(.center)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)

                            Text(NameProfile(syllables: favorite.syllables).summary)
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundStyle(Theme.inkSoft)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 5)
                                .background(Theme.surfaceSoft)
                                .clipShape(Capsule())
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notitie")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundStyle(Theme.ink)

                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $favorite.note)
                                    .focused($isNoteFocused)
                                    .font(.system(size: 15, weight: .regular, design: .rounded))
                                    .foregroundStyle(Theme.ink)
                                    .scrollContentBackground(.hidden)
                                    .padding(12)
                                    .frame(minHeight: 140)
                                    .background(Theme.surfaceStrong)
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .stroke(Theme.border, lineWidth: 1)
                                    }
                                    .accessibilityLabel(Text("Notitie voor \(favorite.name)"))
                                    .accessibilityHint("Voeg een persoonlijke notitie toe of pas die aan.")

                                if favorite.note.isEmpty && !isNoteFocused {
                                    Text("Bv. 'favo van mama', 'klinkt te zacht', of 'past mooi bij Vermeer'.")
                                        .font(.system(size: 15, weight: .regular, design: .rounded))
                                        .foregroundStyle(Theme.inkMuted)
                                        .padding(.horizontal, 17)
                                        .padding(.vertical, 20)
                                        .allowsHitTesting(false)
                                }
                            }
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Bewaard op")
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundStyle(Theme.inkMuted)

                            Text(favorite.savedAt.formatted(.dateTime.day().month(.wide).year().hour().minute().locale(locale)))
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundStyle(Theme.inkSoft)
                        }

                        Spacer(minLength: 12)
                    }
                    .padding(20)
                }
            }
            .navigationTitle(favorite.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Klaar") { dismiss() }
                        .tint(Theme.accent)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(
                        item: shareText,
                        subject: Text("Babynaam-idee uit Younique")
                    ) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(Theme.accent)
                    }
                    .accessibilityLabel(Text("Deel \(favorite.name)"))
                    .accessibilityHint("Opent het deelmenu voor deze naam.")
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(role: .destructive) {
                        modelContext.delete(favorite)
                        dismiss()
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                    .accessibilityLabel(Text("Verwijder \(favorite.name)"))
                }

                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Klaar") { isNoteFocused = false }
                        .tint(Theme.accent)
                }
            }
        }
    }

    private var shareText: String {
        String(format: Bundle.appLocalizedString("Wat vind je van de naam %@?"), favorite.name)
    }
}

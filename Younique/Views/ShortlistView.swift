//
//  ShortlistView.swift
//  Younique
//
//  Created by Marc van der Sluis on 22/06/2026.
//

import SwiftUI
import SwiftData

struct ShortlistView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FavoriteName.savedAt, order: .reverse) private var favorites: [FavoriteName]
    @State private var selectedFavorite: FavoriteName?

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Theme.creamTop, Theme.creamMid, Theme.sageBottom],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                if favorites.isEmpty {
                    emptyState
                } else {
                    list
                }
            }
            .navigationTitle("Youniquelist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sluit") {
                        dismiss()
                    }
                    .tint(Theme.accent)
                }
            }
            .sheet(item: $selectedFavorite) { favorite in
                FavoriteDetailView(favorite: favorite)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "heart")
                .font(.system(size: 44, weight: .light))
                .foregroundStyle(Theme.accent.opacity(0.55))

            Text("Nog geen favorieten")
                .font(.system(size: 22, weight: .semibold, design: .serif))
                .foregroundStyle(Theme.ink)

            Text("Tik op het hartje bij een naam die je mooi vindt om hem hier te bewaren.")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.inkSoft)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }

    private var list: some View {
        List {
            Section {
                ForEach(favorites) { favorite in
                    row(for: favorite)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                }
                .onDelete(perform: delete)
            } header: {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Tik op een naam voor details")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.ink)

                    Text("In het detailscherm vind je notities, delen en extra opties.")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(Theme.inkSoft)
                }
                .textCase(nil)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private func row(for favorite: FavoriteName) -> some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(favorite.name)
                    .font(.system(size: 26, weight: .semibold, design: .serif))
                    .foregroundStyle(Theme.ink)

                Text(NameProfile(syllables: favorite.syllables).summary)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(Theme.inkSoft)

                if !favorite.note.isEmpty {
                    HStack(alignment: .top, spacing: 4) {
                        Image(systemName: "text.quote")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(Theme.accent)
                        Text(favorite.note)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(Theme.ink.opacity(0.78))
                            .lineLimit(2)
                            .italic()
                    }
                    .padding(.top, 2)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Theme.inkSoft)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Theme.border, lineWidth: 1)
        }
        .contentShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .onTapGesture {
            selectedFavorite = favorite
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Opent de details met notitie, delen en extra opties voor deze favoriet.")
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(favorites[index])
        }
    }
}

#Preview {
    ShortlistView()
        .modelContainer(for: FavoriteName.self, inMemory: true)
}

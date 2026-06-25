//
//  ShortlistView.swift
//  Kampert
//
//  Created by Marc van der Sluis on 22/06/2026.
//

import SwiftUI
import SwiftData

struct ShortlistView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FavoriteName.savedAt, order: .reverse) private var favorites: [FavoriteName]

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
            .navigationTitle("Jullie shortlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sluit") {
                        dismiss()
                    }
                    .tint(Theme.accent)
                }
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
            ForEach(favorites) { favorite in
                row(for: favorite)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
            }
            .onDelete(perform: delete)
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

                Text(favorite.savedAt.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(Theme.inkSoft)
            }

            Spacer()

            ShareLink(item: shareText(for: favorite)) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Theme.accent)
                    .frame(width: 38, height: 38)
                    .background(.white.opacity(0.7))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
        }
    }

    private func shareText(for favorite: FavoriteName) -> String {
        "Wat vind je van de naam \(favorite.name)?"
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

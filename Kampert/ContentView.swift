//
//  ContentView.swift
//  Kampert
//
//  Created by Marc van der Sluis on 21/06/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = NameGeneratorViewModel()
    @State private var isInfoPresented = false
    @State private var isFilterSectionExpanded = false

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    backgroundGradient

                    VStack(spacing: 20) {
                        controlsSection
                        Spacer(minLength: 0)
                        createButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 20)
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)

                    if viewModel.isOverlayPresented {
                        resultOverlay
                            .transition(.opacity.combined(with: .scale(scale: 0.96)))
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isInfoPresented = true
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundStyle(Theme.accent)
                    }
                }
            }
            .sheet(isPresented: $isInfoPresented) {
                InfoView()
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.86), value: viewModel.isOverlayPresented)
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Theme.creamTop,
                Theme.creamMid,
                Theme.sageBottom
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var controlsSection: some View {
        VStack(spacing: 14) {
            Text("Vind jullie naam")
                .font(.system(size: 22, weight: .semibold, design: .serif))
                .italic()
                .foregroundStyle(Theme.ink)

            VStack(alignment: .leading, spacing: 6) {
                Text("Naamtype")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.ink)

                Picker("Naamtype", selection: $viewModel.nameType) {
                    ForEach(NameType.allCases) { nameType in
                        Text(nameType.title).tag(nameType)
                    }
                }
                .pickerStyle(.segmented)
                .disabled(viewModel.isCreating)

                Text(viewModel.nameType.detail)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(Theme.inkSoft)

                Text("Deze keuze filtert direct welke lettergrepen en klanken overal in de app zichtbaar en beschikbaar zijn.")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(Theme.inkMuted)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Aantal gewenste lettergrepen")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.ink)

                Picker("Aantal gewenste lettergrepen", selection: $viewModel.reelCount) {
                    ForEach(ReelCount.allCases) { count in
                        Text("\(count.rawValue)").tag(count)
                    }
                }
                .pickerStyle(.segmented)
                .disabled(viewModel.isCreating)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Selectiemodus")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.ink)

                Menu {
                    Picker("Selectiemodus", selection: $viewModel.selectionMode) {
                        ForEach(SyllableSelectionMode.allCases) { mode in
                            Text(mode.title).tag(mode)
                        }
                    }
                } label: {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(viewModel.selectionMode.title)
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundStyle(Theme.ink)

                            Text("Kies hoe de delen hun lettergrepen krijgen")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundStyle(Theme.inkSoft)
                        }

                        Spacer()

                        Image(systemName: "chevron.up.chevron.down")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Theme.accent)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Theme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.white.opacity(0.6), lineWidth: 1)
                    }
                }
                .disabled(viewModel.isCreating)
                .buttonStyle(.plain)

                Text(viewModel.selectionMode.detail)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(Theme.inkSoft)
            }

            if viewModel.selectionMode == .automatic || viewModel.selectionMode == .automaticShared {
                filterSection
            } else {
                syllableSelectionSection
            }

            Text(viewModel.reelCount.subtitle)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.inkSoft)
                .multilineTextAlignment(.center)
        }
    }

    private var filterSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                    isFilterSectionExpanded.toggle()
                }
            } label: {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Verfijn stijl")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(Theme.ink)

                        Text(filterSummaryText)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(Theme.inkSoft)
                    }

                    Spacer()

                    Image(systemName: isFilterSectionExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Theme.accent)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.6), lineWidth: 1)
                }
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isCreating)

            if isFilterSectionExpanded {
                Text("Kies alleen de klankgroepen die je liever niet terugziet. Dit is optioneel en werkt alleen in de automatische modi.")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(Theme.inkSoft)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(NameFilterGroup.allCases) { group in
                        FilterChip(
                            group: group,
                            isExcluded: viewModel.excludedGroups.contains(group),
                            isDisabled: viewModel.isCreating
                        ) {
                            viewModel.toggleGroup(group)
                        }
                    }
                }
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.85), value: isFilterSectionExpanded)
    }

    private var syllableSelectionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            if viewModel.selectionMode == .perReelManual {
                Picker("Actief deel", selection: $viewModel.activeReelSelectionIndex) {
                    ForEach(0..<viewModel.reelCount.rawValue, id: \.self) { index in
                        Text("Deel \(index + 1)").tag(index)
                    }
                }
                .pickerStyle(.segmented)
                .disabled(viewModel.isCreating)
            }

            Text(viewModel.selectedCountText())
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.inkSoft)

            ScrollView(.vertical, showsIndicators: true) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 68), spacing: 10)], spacing: 10) {
                    ForEach(sortedSyllables, id: \.self) { syllable in
                        SyllableChip(
                            syllable: syllable,
                            isSelected: viewModel.isSyllableSelected(syllable),
                            isDisabled: viewModel.isCreating
                        ) {
                            viewModel.toggleSyllable(syllable)
                        }
                    }
                }
                .padding(.trailing, 4)
            }
            .frame(minHeight: 180, maxHeight: 250)
        }
    }

    private var createButton: some View {
        Button {
            Task {
                viewModel.presentOverlay()
                await viewModel.spinReels()
            }
        } label: {
            Text("Ontdek een naam")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    LinearGradient(
                        colors: [
                            Theme.accentSoft,
                            Theme.accent
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: Theme.accent.opacity(0.28), radius: 18, y: 10)
        }
        .disabled(viewModel.isCreating || !viewModel.canGenerate)
        .opacity((viewModel.isCreating || !viewModel.canGenerate) ? 0.7 : 1)
    }

    private var filterSummaryText: String {
        if viewModel.excludedGroups.isEmpty {
            return "Optioneel: verberg klankgroepen die je niet wilt horen"
        }

        return "\(viewModel.excludedGroups.count) klankgroepen verborgen"
    }

    private var sortedSyllables: [String] {
        viewModel.allSyllables.sorted {
            $0.localizedCaseInsensitiveCompare($1) == .orderedAscending
        }
    }

    private var resultOverlay: some View {
        ZStack {
            Color.black.opacity(0.24)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                HStack {
                    Button {
                        viewModel.dismissOverlay()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Theme.ink.opacity(0.7))
                            .frame(width: 32, height: 32)
                            .background(.white.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.isCreating)
                    .opacity(viewModel.isCreating ? 0.35 : 1)

                    Spacer()
                }

                if let name = viewModel.displayedName {
                    Text(name)
                        .font(.system(size: 44, weight: .semibold, design: .serif))
                        .foregroundStyle(Theme.ink)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.55)
                } else if !viewModel.isCreating {
                    Text("Tik op Ontdek om een naam te onthullen.")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Theme.inkSoft)
                }

                if !viewModel.reels.isEmpty {
                    HStack(spacing: viewModel.reelCount == .five ? 8 : 12) {
                        ForEach(Array(viewModel.reels.enumerated()), id: \.offset) { index, syllable in
                            ReelCard(
                                syllable: syllable,
                                isSpinning: index < viewModel.spinningReels.count ? viewModel.spinningReels[index] : false,
                                reelCount: viewModel.reelCount
                            )
                        }
                    }
                }

                Button {
                    Task {
                        await viewModel.spinReels()
                    }
                } label: {
                    Text(viewModel.isCreating ? "Even geduld..." : "Opnieuw")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [
                                    Theme.inkSoft,
                                    Theme.ink
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                }
                .disabled(viewModel.isCreating || !viewModel.canGenerate)
                .opacity((viewModel.isCreating || !viewModel.canGenerate) ? 0.7 : 1)
            }
            .padding(22)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(Color.white.opacity(0.45), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.18), radius: 26, y: 14)
            .padding(.horizontal, 20)
        }
    }
}

enum Theme {
    static let creamTop = Color(red: 0.98, green: 0.94, blue: 0.87)
    static let creamMid = Color(red: 0.95, green: 0.86, blue: 0.81)
    static let sageBottom = Color(red: 0.88, green: 0.91, blue: 0.85)

    static let surface = Color.white.opacity(0.72)
    static let card = Color(red: 0.99, green: 0.96, blue: 0.91)

    static let ink = Color(red: 0.20, green: 0.16, blue: 0.13)
    static let inkSoft = Color(red: 0.20, green: 0.16, blue: 0.13).opacity(0.62)
    static let inkMuted = Color(red: 0.20, green: 0.16, blue: 0.13).opacity(0.46)

    static let accent = Color(red: 0.79, green: 0.48, blue: 0.39)
    static let accentSoft = Color(red: 0.87, green: 0.65, blue: 0.55)
}

#Preview {
    ContentView()
}

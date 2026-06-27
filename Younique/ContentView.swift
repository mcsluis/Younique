//
//  ContentView.swift
//  Younique
//
//  Created by Marc van der Sluis on 21/06/2026.
//

import SwiftUI
import SwiftData
import UIKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Query private var favorites: [FavoriteName]

    @State private var viewModel = NameGeneratorViewModel()
    @State private var isInfoPresented = false
    @State private var isShortlistPresented = false
    @State private var isSettingsPresented = false
    @State private var isPaywallPresented = false
    @State private var isFilterSectionExpanded = false
    @State private var isAdvancedSheetPresented = false
    @State private var isSyllablePickerPresented = false

    @Environment(PurchaseManager.self) private var purchaseManager

    @AppStorage("displayFont") private var displayFontRaw: String = DisplayFont.default.rawValue

    private var displayFont: DisplayFont {
        DisplayFont(rawValue: displayFontRaw) ?? .default
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    backgroundGradient
                        .blur(radius: viewModel.isOverlayPresented ? 10 : 0)

                    homeContent
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
                    .blur(radius: viewModel.isOverlayPresented ? 12 : 0)
                    .allowsHitTesting(!viewModel.isOverlayPresented)

                    if viewModel.isOverlayPresented {
                        resultOverlay
                            .transition(.opacity.combined(with: .scale(scale: 0.96)))
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isShortlistPresented = true
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: favorites.isEmpty ? "heart" : "heart.fill")
                                .foregroundStyle(Theme.accent)

                            if !favorites.isEmpty {
                                Text("\(favorites.count)")
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Theme.selectionFill)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .accessibilityLabel("Open Youniquelist")
                    .accessibilityHint("Toont je bewaarde favorieten.")
                }

                ToolbarItem(placement: .principal) {
                    Text("Younique")
                        .font(.system(size: 24, weight: .semibold, design: .serif))
                        .foregroundStyle(Theme.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .accessibilityAddTraits(.isHeader)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isSettingsPresented = true
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundStyle(Theme.accent)
                    }
                    .accessibilityLabel("Open instellingen")
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isInfoPresented = true
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundStyle(Theme.accent)
                    }
                    .accessibilityLabel("Open uitleg")
                }
            }
            .sheet(isPresented: $isInfoPresented) {
                InfoView()
            }
            .sheet(isPresented: $isShortlistPresented) {
                ShortlistView()
            }
            .sheet(isPresented: $isSettingsPresented) {
                SettingsView()
            }
            .sheet(isPresented: $isPaywallPresented) {
                PaywallView()
            }
            .sheet(isPresented: $isAdvancedSheetPresented) {
                AdvancedSettingsSheetView(
                    viewModel: viewModel,
                    isPaywallPresented: $isPaywallPresented,
                    isSyllablePickerPresented: $isSyllablePickerPresented
                )
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
            .fullScreenCover(isPresented: $isSyllablePickerPresented) {
                FullScreenSyllablePickerView(
                    viewModel: viewModel,
                    sortedSyllables: sortedSyllables
                )
            }
            .onChange(of: purchaseManager.isUnlocked) { _, isUnlocked in
                if !isUnlocked {
                    if viewModel.reelCount.rawValue > 2 {
                        viewModel.reelCount = .two
                    }
                    if viewModel.selectionMode != .automatic {
                        viewModel.selectionMode = .automatic
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                actionSection
                    .padding(.top, 8)
                    .background(Color.clear)
                    .blur(radius: viewModel.isOverlayPresented ? 12 : 0)
                    .allowsHitTesting(!viewModel.isOverlayPresented)
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

    @ViewBuilder
    private var homeContent: some View {
        if dynamicTypeSize.isAccessibilitySize {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 20) {
                    controlsSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 0)
                .padding(.bottom, 180)
            }
        } else {
            VStack(spacing: 0) {
                controlsSection
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 0)
            .padding(.bottom, 180)
        }
    }

    private var controlsSection: some View {
        VStack(spacing: 18) {
            baseSettingsSection
            soundStyleSection
            advancedSection
        }
        .layoutPriority(1)
    }

    private var actionSection: some View {
        VStack(spacing: 10) {
            createButton

            Text("Vind jullie unieke naam")
                .font(.system(size: 13, weight: .medium, design: .serif))
                .italic()
                .foregroundStyle(Theme.inkSoft)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
    }

    private var baseSettingsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Kies naamtype en aantal posities")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.ink)

                Picker("Naamtype", selection: $viewModel.nameType) {
                    ForEach(NameType.allCases) { nameType in
                        Text(nameType.title).tag(nameType)
                    }
                }
                .pickerStyle(.segmented)
                .disabled(viewModel.isCreating)
            }

            reelCountPicker

            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "sparkles")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Theme.accent)
                    .padding(.top, 2)

                Text(baseSettingsSummaryText)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(Theme.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, 8)
        }
        .padding(18)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Theme.borderStrong, lineWidth: 1)
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    private var reelCountPicker: some View {
        HStack(spacing: 6) {
            ForEach(ReelCount.allCases) { count in
                let isLocked = !purchaseManager.isUnlocked && count.rawValue > 2
                let isSelected = viewModel.reelCount == count
                Button {
                    if isLocked {
                        isPaywallPresented = true
                    } else {
                        viewModel.reelCount = count
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text("\(count.rawValue)")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                        if isLocked {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 10, weight: .bold))
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .foregroundStyle(isSelected ? .white : (isLocked ? Theme.inkMuted : Theme.ink))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        isSelected ? AnyShapeStyle(Theme.accent) : AnyShapeStyle(Theme.surfaceSoft)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(isSelected ? Color.clear : Theme.border, lineWidth: 1)
                    }
                }
                .buttonStyle(.plain)
                .disabled(viewModel.isCreating)
            }
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.78), value: purchaseManager.isUnlocked)
        .sensoryFeedback(.success, trigger: purchaseManager.isUnlocked) { _, new in new }
    }

    private var filterSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Verfijn stijl")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(Theme.ink)

            Text("Verberg alleen de klankgroepen die je liever niet hoort. Dit werkt in de automatische modi.")
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

    private var soundStyleSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Kies optioneel je klankstijl")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.ink)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(SoundStylePreset.allCases) { preset in
                            soundStyleChip(for: preset)
                        }
                    }
                    .padding(.vertical, 1)
                }
            }

            HStack(alignment: .top, spacing: 10) {
                Image(systemName: viewModel.activeSoundStylePreset == nil ? "wand.and.stars" : "waveform.path")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Theme.accent)
                    .padding(.top, 2)

                VStack(alignment: .leading, spacing: 0) {
                    Text(soundStyleDetailText)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(Theme.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)

                    if let accentLine = soundStyleAccentLine {
                        Text(accentLine)
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundStyle(Theme.ink)
                            .padding(.top, 10)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, 8)
        }
        .padding(18)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Theme.borderStrong, lineWidth: 1)
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    private func soundStyleChip(for preset: SoundStylePreset) -> some View {
        let isSelected = viewModel.activeSoundStylePreset == preset
        let isLocked = preset.isPremium && !purchaseManager.isUnlocked

        return Button {
            if isLocked {
                isPaywallPresented = true
            } else {
                viewModel.applySoundStylePreset(preset)
            }
        } label: {
            HStack(spacing: 8) {
                Text(preset.title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .lineLimit(1)

                if isLocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 10, weight: .bold))
                } else if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                }
            }
            .foregroundStyle(isSelected ? .white : (isLocked ? Theme.inkSoft : Theme.ink))
            .padding(.horizontal, 14)
            .padding(.vertical, 11)
            .background(isSelected ? Theme.accent : (isLocked ? Theme.surfaceSoft : Theme.surface))
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .stroke(isSelected ? Color.clear : Theme.borderStrong, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isCreating)
        .accessibilityLabel(preset.title)
        .accessibilityValue(isLocked
            ? String(localized: "Vergrendeld")
            : (isSelected ? String(localized: "Geselecteerd") : String(localized: "Niet geselecteerd")))
        .accessibilityHint(isLocked
            ? String(localized: "Dubbeltik om Premium te bekijken.")
            : String(localized: "Dubbeltik om deze klankstijl toe te passen."))
    }

    private var advancedSection: some View {
        Button {
            isAdvancedSheetPresented = true
        } label: {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Geavanceerd aanpassen")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.ink)

                    Text(advancedSummaryText)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(Theme.inkSoft)
                        .lineLimit(2)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 8) {
                    Text(advancedModeBadgeText)
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.accent)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 5)
                        .background(Theme.surfaceSoft)
                        .clipShape(Capsule())

                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(Theme.accent)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Theme.borderStrong, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isCreating)
        .accessibilityLabel("Geavanceerd aanpassen")
        .accessibilityHint("Opent extra instellingen in een apart paneel.")
    }

    private var advancedModeSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Lettergreepmodus")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(Theme.ink)

            Menu {
                ForEach(SyllableSelectionMode.allCases.reversed()) { mode in
                    let isLocked = !purchaseManager.isUnlocked && mode != .automatic
                    Button {
                        if isLocked {
                            isPaywallPresented = true
                        } else {
                            viewModel.selectionMode = mode
                        }
                    } label: {
                        if mode == viewModel.selectionMode {
                            Label(mode.title, systemImage: "checkmark")
                        } else if isLocked {
                            Label(mode.title, systemImage: "lock.fill")
                        } else {
                            Text(mode.title)
                        }
                    }
                }
            } label: {
                HStack(spacing: 12) {
                    Text(viewModel.selectionMode.title)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.ink)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Spacer()

                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Theme.accent)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.surfaceStrong)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Theme.borderStrong, lineWidth: 1)
                }
            }
            .disabled(viewModel.isCreating)
            .buttonStyle(.plain)
            .accessibilityLabel("Kies lettergreepmodus")
            .accessibilityValue(viewModel.selectionMode.title)

            Text(viewModel.selectionMode.detail)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.inkSoft)
        }
    }

    private var syllableSelectionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                isSyllablePickerPresented = true
            } label: {
                HStack(spacing: 14) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(manualSelectionHeadline)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(Theme.ink)
                    }

                    Spacer()

                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Theme.accent)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Theme.borderStrong, lineWidth: 1)
                }
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isCreating)
            .accessibilityLabel("Open handmatige lettergreepselectie")
        }
    }

    private var createButton: some View {
        Button {
            Task {
                viewModel.presentOverlay()
                await viewModel.spinReels()
            }
        } label: {
            Image(systemName: "wand.and.stars")
                .font(.system(size: 24, weight: .bold))
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
        .accessibilityHint("Genereert een nieuwe naam op basis van je huidige keuzes.")
        .accessibilityIdentifier("discoverButton")
    }

    private var filterSummaryText: String {
        if viewModel.excludedGroups.isEmpty {
            return Bundle.appLocalizedString("Geen klankgroepen verborgen")
        }

        let count = viewModel.excludedGroups.count
        return String(
            format: Bundle.appLocalizedString("%lld klankgroepen verborgen"),
            count
        )
    }

    private var manualSelectionHeadline: String {
        if viewModel.selectionMode == .perReelManual {
            return Bundle.appLocalizedString("Kies per positie je lettergrepen")
        }

        return Bundle.appLocalizedString("Open de lettergreep-selector")
    }

    private var soundStyleDetailText: String {
        if let preset = viewModel.activeSoundStylePreset {
            return preset.baseDetail
        }

        return Bundle.appLocalizedString("Kies een stijl om de generator meer richting te geven.")
    }

    private var soundStyleAccentLine: String? {
        guard let preset = viewModel.activeSoundStylePreset else {
            return nil
        }

        let accentLine = preset.accentLine(
            for: viewModel.nameType,
            allowedSyllables: Set(sortedSyllables)
        )

        return accentLine.isEmpty ? nil : accentLine
    }

    private var baseSettingsSummaryText: String {
        "\(viewModel.nameType.detail) \(viewModel.reelCount.subtitle)"
    }

    private var advancedSummaryText: String {
        var parts = [viewModel.selectionMode.title]

        if viewModel.selectionMode == .automatic || viewModel.selectionMode == .automaticShared {
            parts.append(filterSummaryText)
        } else if viewModel.selectionMode == .perReelManual {
            parts.append(Bundle.appLocalizedString("Selectie per positie"))
        } else {
            parts.append(Bundle.appLocalizedString("Handmatige selectie"))
        }

        return parts.joined(separator: " • ")
    }

    private var advancedModeBadgeText: String {
        switch viewModel.selectionMode {
        case .automatic, .automaticShared:
            return Bundle.appLocalizedString("Auto")
        case .sharedManual, .distributedManual, .perReelManual:
            return Bundle.appLocalizedString("Handmatig")
        }
    }

    private var sortedSyllables: [String] {
        viewModel.allSyllables.sorted {
            $0.localizedCaseInsensitiveCompare($1) == .orderedAscending
        }
    }

    private func isFavorite(_ name: String) -> Bool {
        favorites.contains { $0.name == name }
    }

    private func toggleFavorite(name: String, syllables: [String]) {
        if let existing = favorites.first(where: { $0.name == name }) {
            modelContext.delete(existing)
        } else {
            modelContext.insert(FavoriteName(name: name, syllables: syllables))
        }
    }

    private var resultOverlay: some View {
        ZStack {
            Theme.overlayScrim
                .ignoresSafeArea()

            VStack(spacing: 18) {
                HStack(spacing: 10) {
                    Button {
                        viewModel.dismissOverlay()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Theme.ink.opacity(0.7))
                            .frame(width: 32, height: 32)
                            .background(Theme.surfaceStrong)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.isCreating)
                    .opacity(viewModel.isCreating ? 0 : 1)
                    .animation(.easeInOut(duration: 0.2), value: viewModel.isCreating)
                    .accessibilityLabel("Sluit naamoverlay")

                    Spacer()

                    if let name = viewModel.displayedName, !viewModel.isCreating {
                        ShareLink(
                            item: String(localized: "Wat vind je van de naam \(name)?"),
                            subject: Text("Babynaam-idee uit Younique"),
                            message: Text("Wat vind je van de naam \(name)?")
                        ) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Theme.ink.opacity(0.7))
                                .frame(width: 32, height: 32)
                                .background(Theme.surfaceStrong)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                        .transition(.opacity.combined(with: .scale(scale: 0.7)))
                        .accessibilityLabel("Deel \(name)")

                        Button {
                            toggleFavorite(name: name, syllables: viewModel.reels)
                        } label: {
                            Image(systemName: isFavorite(name) ? "heart.fill" : "heart")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(isFavorite(name) ? Theme.accent : Theme.ink.opacity(0.7))
                                .frame(width: 32, height: 32)
                                .background(Theme.surfaceStrong)
                                .clipShape(Circle())
                                .contentTransition(.symbolEffect(.replace))
                        }
                        .buttonStyle(.plain)
                        .transition(.opacity.combined(with: .scale(scale: 0.7)))
                        .accessibilityLabel(isFavorite(name)
                            ? String(localized: "Verwijder \(name) uit favorieten")
                            : String(localized: "Bewaar \(name) als favoriet"))
                    }
                }

                if let name = viewModel.displayedName {
                    VStack(spacing: 8) {
                        Text(name)
                            .font(displayFont.font(baseSize: 44))
                            .foregroundStyle(Theme.ink)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)

                        Text(NameProfile(syllables: viewModel.reels).summary)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(Theme.inkSoft)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 5)
                            .background(Theme.surfaceSoft)
                            .clipShape(Capsule())
                    }
                    .transition(.opacity.combined(with: .offset(y: 8)))
                    .id(name)
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
                    Image(systemName: "wand.and.stars")
                        .font(.system(size: 22, weight: .bold))
                        .accessibilityLabel("Nog een keer genereren")
                        .accessibilityIdentifier("spinAgainButton")
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
                .opacity(viewModel.isCreating ? 0 : (!viewModel.canGenerate ? 0.7 : 1))
                .animation(.easeInOut(duration: 0.2), value: viewModel.isCreating)
            }
            .padding(22)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(Theme.border, lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.18), radius: 26, y: 14)
            .padding(.horizontal, 20)
            .animation(.smooth(duration: 0.55), value: viewModel.displayedName)
            .sensoryFeedback(trigger: viewModel.spinningReels) { old, new in
                let landed = zip(old, new).contains { $0 && !$1 }
                return landed ? .impact(weight: .light) : nil
            }
            .sensoryFeedback(trigger: viewModel.displayedName) { old, new in
                (old == nil && new != nil) ? .success : nil
            }
        }
    }
}

private struct AdvancedSettingsSheetView: View {
    @Bindable var viewModel: NameGeneratorViewModel
    @Binding var isPaywallPresented: Bool
    @Binding var isSyllablePickerPresented: Bool

    @Environment(\.dismiss) private var dismiss
    @Environment(PurchaseManager.self) private var purchaseManager

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 18) {
                    advancedModeSection

                    if viewModel.selectionMode == .automatic || viewModel.selectionMode == .automaticShared {
                        filterSection
                    } else {
                        syllableSelectionSection
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 32)
            }
            .background(
                LinearGradient(
                    colors: [Theme.creamTop, Theme.creamMid, Theme.sageBottom],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationTitle(Bundle.appLocalizedString("Geavanceerd"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text(Bundle.appLocalizedString("Klaar"))
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(Theme.ink)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(.ultraThinMaterial, in: Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var advancedModeSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(Bundle.appLocalizedString("Lettergreepmodus"))
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(Theme.ink)

            Menu {
                ForEach(SyllableSelectionMode.allCases.reversed()) { mode in
                    let isLocked = !purchaseManager.isUnlocked && mode != .automatic
                    Button {
                        if isLocked {
                            dismiss()
                            isPaywallPresented = true
                        } else {
                            viewModel.selectionMode = mode
                        }
                    } label: {
                        if mode == viewModel.selectionMode {
                            Label(mode.title, systemImage: "checkmark")
                        } else if isLocked {
                            Label(mode.title, systemImage: "lock.fill")
                        } else {
                            Text(mode.title)
                        }
                    }
                }
            } label: {
                HStack(spacing: 12) {
                    Text(viewModel.selectionMode.title)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.ink)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

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
                        .stroke(Theme.borderStrong, lineWidth: 1)
                }
            }
            .disabled(viewModel.isCreating)
            .buttonStyle(.plain)
            .accessibilityLabel(Bundle.appLocalizedString("Kies lettergreepmodus"))
            .accessibilityValue(viewModel.selectionMode.title)

            Text(viewModel.selectionMode.detail)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.inkSoft)
        }
    }

    private var filterSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(Bundle.appLocalizedString("Verfijn stijl"))
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(Theme.ink)

            Text(Bundle.appLocalizedString("Verberg alleen de klankgroepen die je liever niet hoort. Dit werkt in de automatische modi."))
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

    private var syllableSelectionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                dismiss()
                isSyllablePickerPresented = true
            } label: {
                HStack(spacing: 14) {
                    Text(manualSelectionHeadline)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.ink)

                    Spacer()

                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Theme.accent)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Theme.borderStrong, lineWidth: 1)
                }
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isCreating)
            .accessibilityLabel(Bundle.appLocalizedString("Open handmatige lettergreepselectie"))
        }
    }

    private var manualSelectionHeadline: String {
        if viewModel.selectionMode == .perReelManual {
            return Bundle.appLocalizedString("Kies voor iedere positie de gewenste lettergrepen")
        }

        return Bundle.appLocalizedString("Kies hier je lettergrepen")
    }
}

private struct FullScreenSyllablePickerView: View {
    @Bindable var viewModel: NameGeneratorViewModel
    let sortedSyllables: [String]

    @Environment(\.dismiss) private var dismiss
    @Environment(PurchaseManager.self) private var purchaseManager
    @State private var isPaywallPresented = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Theme.creamTop, Theme.creamMid, Theme.sageBottom],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .leading, spacing: 18) {
                        Text(introText)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundStyle(Theme.inkSoft)

                        if viewModel.selectionMode == .perReelManual {
                            Picker("Actieve positie", selection: $viewModel.activeReelSelectionIndex) {
                                ForEach(0..<viewModel.reelCount.rawValue, id: \.self) { index in
                                    Text("\(index + 1)").tag(index)
                                }
                            }
                            .pickerStyle(.segmented)
                            .disabled(viewModel.isCreating)
                        }

                        Text(viewModel.selectedCountText())
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(Theme.inkSoft)

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 88), spacing: 12)], spacing: 12) {
                            ForEach(sortedSyllables, id: \.self) { syllable in
                                SyllableChip(
                                    syllable: syllable,
                                    isSelected: viewModel.isSyllableSelected(syllable),
                                    isLocked: isLockedSyllable(syllable),
                                    isDisabled: viewModel.isCreating
                                ) {
                                    if isLockedSyllable(syllable) {
                                        isPaywallPresented = true
                                    } else {
                                        viewModel.toggleSyllable(syllable)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 32)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(Bundle.appLocalizedString("Reset")) {
                        viewModel.resetCurrentSyllableSelection()
                    }
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.accent)
                    .disabled(viewModel.isCreating || !canResetCurrentSelection)
                    .opacity(canResetCurrentSelection ? 1 : 0.45)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(Bundle.appLocalizedString("Klaar")) {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                }
            }
            .sheet(isPresented: $isPaywallPresented) {
                PaywallView()
            }
        }
    }

    private var introText: String {
        if viewModel.selectionMode == .perReelManual {
            return Bundle.appLocalizedString("Kies hier je lettergrepen")
        }

        return Bundle.appLocalizedString("Kies fullscreen welke lettergrepen in de generator mogen terugkomen.")
    }

    private var canResetCurrentSelection: Bool {
        switch viewModel.selectionMode {
        case .sharedManual, .distributedManual:
            return !viewModel.selectedSyllables.isEmpty
        case .perReelManual:
            return !(viewModel.perReelSelectedSyllables[viewModel.activeReelSelectionIndex] ?? []).isEmpty
        case .automatic, .automaticShared:
            return false
        }
    }

    private var restrictedSyllables: Set<String>? {
        guard !purchaseManager.isUnlocked, let preset = viewModel.activeSoundStylePreset else {
            return nil
        }

        return preset.availableSyllables(
            for: viewModel.nameType,
            allowedSyllables: Set(sortedSyllables)
        )
    }

    private func isLockedSyllable(_ syllable: String) -> Bool {
        guard let restrictedSyllables else { return false }
        return !restrictedSyllables.contains(syllable)
    }
}

enum Theme {
    static let creamTop = Color(
        light: UIColor(red: 0.98, green: 0.94, blue: 0.87, alpha: 1),
        dark: UIColor(red: 0.12, green: 0.10, blue: 0.09, alpha: 1)
    )
    static let creamMid = Color(
        light: UIColor(red: 0.95, green: 0.86, blue: 0.81, alpha: 1),
        dark: UIColor(red: 0.16, green: 0.13, blue: 0.12, alpha: 1)
    )
    static let sageBottom = Color(
        light: UIColor(red: 0.88, green: 0.91, blue: 0.85, alpha: 1),
        dark: UIColor(red: 0.13, green: 0.17, blue: 0.15, alpha: 1)
    )

    static let surface = Color(
        light: UIColor(white: 1.0, alpha: 0.72),
        dark: UIColor(red: 0.18, green: 0.16, blue: 0.15, alpha: 0.84)
    )
    static let surfaceStrong = Color(
        light: UIColor(white: 1.0, alpha: 0.88),
        dark: UIColor(red: 0.23, green: 0.21, blue: 0.20, alpha: 0.94)
    )
    static let surfaceSoft = Color(
        light: UIColor(white: 1.0, alpha: 0.55),
        dark: UIColor(red: 0.18, green: 0.16, blue: 0.15, alpha: 0.70)
    )
    static let surfaceMuted = Color(
        light: UIColor(white: 1.0, alpha: 0.50),
        dark: UIColor(red: 0.16, green: 0.14, blue: 0.13, alpha: 0.60)
    )
    static let card = Color(
        light: UIColor(red: 0.99, green: 0.96, blue: 0.91, alpha: 1),
        dark: UIColor(red: 0.24, green: 0.21, blue: 0.19, alpha: 1)
    )
    static let cardTop = Color(
        light: UIColor(red: 1.00, green: 0.98, blue: 0.94, alpha: 1),
        dark: UIColor(red: 0.28, green: 0.25, blue: 0.23, alpha: 1)
    )

    static let ink = Color(
        light: UIColor(red: 0.20, green: 0.16, blue: 0.13, alpha: 1),
        dark: UIColor(red: 0.95, green: 0.92, blue: 0.88, alpha: 1)
    )
    static let inkSoft = Color(
        light: UIColor(red: 0.20, green: 0.16, blue: 0.13, alpha: 0.62),
        dark: UIColor(red: 0.95, green: 0.92, blue: 0.88, alpha: 0.68)
    )
    static let inkMuted = Color(
        light: UIColor(red: 0.20, green: 0.16, blue: 0.13, alpha: 0.46),
        dark: UIColor(red: 0.95, green: 0.92, blue: 0.88, alpha: 0.48)
    )

    static let accent = Color(
        light: UIColor(red: 0.79, green: 0.48, blue: 0.39, alpha: 1),
        dark: UIColor(red: 0.89, green: 0.63, blue: 0.53, alpha: 1)
    )
    static let accentSoft = Color(
        light: UIColor(red: 0.87, green: 0.65, blue: 0.55, alpha: 1),
        dark: UIColor(red: 0.72, green: 0.51, blue: 0.43, alpha: 1)
    )
    static let selectionFill = Color(
        light: UIColor(red: 0.20, green: 0.16, blue: 0.13, alpha: 1),
        dark: UIColor(red: 0.24, green: 0.19, blue: 0.17, alpha: 0.98)
    )

    static let border = Color(
        light: UIColor(white: 1.0, alpha: 0.50),
        dark: UIColor(white: 1.0, alpha: 0.10)
    )
    static let borderStrong = Color(
        light: UIColor(white: 1.0, alpha: 0.60),
        dark: UIColor(white: 1.0, alpha: 0.14)
    )
    static let overlayScrim = Color(
        light: UIColor(white: 0.0, alpha: 0.24),
        dark: UIColor(white: 0.0, alpha: 0.46)
    )
}

private extension Color {
    init(light: UIColor, dark: UIColor) {
        self.init(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? dark : light
        })
    }
}

#Preview {
    ContentView()
        .environment(PurchaseManager())
}

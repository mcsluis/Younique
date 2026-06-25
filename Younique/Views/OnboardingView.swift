//
//  OnboardingView.swift
//  Younique
//
//  Created by Codex on 25/06/2026.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(PurchaseManager.self) private var purchaseManager
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    @State private var currentPage = 0
    @State private var isPaywallPresented = false
    @State private var animateHero = false

    @ScaledMetric(relativeTo: .title) private var heroSymbolSize: CGFloat = 42
    @ScaledMetric(relativeTo: .title2) private var heroSymbolPadding: CGFloat = 18
    @ScaledMetric(relativeTo: .title2) private var onboardingReelWidth: CGFloat = 92

    let onFinish: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    colors: [Theme.creamTop, Theme.creamMid, Theme.sageBottom],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    header
                        .padding(.horizontal, 20)
                        .padding(.top, 14)

                    TabView(selection: $currentPage) {
                        welcomePage
                            .tag(0)

                        howItWorksPage
                            .tag(1)

                        premiumPage
                            .tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.spring(response: 0.35, dampingFraction: 0.86), value: currentPage)

                    footer
                        .padding(.horizontal, 20)
                        .padding(.top, 14)
                        .padding(.bottom, max(geometry.safeAreaInsets.bottom, 14))
                }
            }
        }
        .interactiveDismissDisabled()
        .sheet(isPresented: $isPaywallPresented) {
            PaywallView()
        }
        .onAppear {
            animateHero = true
        }
        .dynamicTypeSize(.xSmall ... .xxxLarge)
    }

    private var header: some View {
        HStack {
            pageDots

            Spacer()

            Button("Skip") {
                onFinish()
            }
            .font(.system(size: 15, weight: .semibold, design: .rounded))
            .foregroundStyle(Theme.accent)
        }
        .frame(height: 44)
    }

    private var footer: some View {
        VStack(spacing: 12) {
            if currentPage < 2 {
                Button {
                    withAnimation {
                        currentPage += 1
                    }
                } label: {
                    Text(currentPage == 1 ? "Verder naar Premium" : "Volgende")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Theme.accentSoft, Theme.accent],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            } else {
                Button {
                    onFinish()
                } label: {
                    Text("Beginnen")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Theme.accentSoft, Theme.accent],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var pageDots: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? Theme.accent : Theme.ink.opacity(0.14))
                    .frame(width: index == currentPage ? 24 : 8, height: 8)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: currentPage)
    }

    private var welcomePage: some View {
        pageLayout(
            eyebrow: "Welkom bij",
            title: "Younique",
            bodyText: "Genereer unieke babynamen door zorgvuldig gekozen lettergrepen als een speelse slotmachine te combineren."
        ) {
            VStack(spacing: 22) {
                Image(systemName: "wand.and.stars.inverse")
                    .font(.system(size: heroSymbolSize, weight: .bold))
                    .foregroundStyle(Theme.accent)
                    .symbolEffect(.bounce, value: animateHero)
                    .padding(heroSymbolPadding)
                    .background(Theme.surfaceMuted)
                    .clipShape(Circle())
                    .shadow(color: Theme.accent.opacity(0.18), radius: 18, y: 8)

                if dynamicTypeSize.isAccessibilitySize {
                    HStack(spacing: 8) {
                        onboardingReel("lu", delay: 0.0)
                        onboardingReel("na", delay: 0.08)
                        onboardingReel("vi", delay: 0.16)
                    }
                } else {
                    HStack(spacing: 12) {
                        onboardingReel("lu", delay: 0.0)
                        onboardingReel("na", delay: 0.08)
                        onboardingReel("vi", delay: 0.16)
                    }
                }
            }
        }
    }

    private var howItWorksPage: some View {
        pageLayout(
            eyebrow: "Hoe het werkt",
            title: "Stuur de klank",
            bodyText: "Kies eerst het naamtype en het aantal posities. Daarna laat je Younique automatisch combineren, of selecteer je zelf per positie je favoriete lettergrepen."
        ) {
            VStack(spacing: 14) {
                ViewThatFits(in: .vertical) {
                    VStack(spacing: 14) {
                        HStack(spacing: 10) {
                            infoPill(title: "Naamtype", value: "Neutraal")
                            infoPill(title: "Posities", value: "3")
                        }

                        HStack(spacing: 10) {
                            positionCard(number: "1", label: "Start")
                            positionCard(number: "2", label: "Kern")
                            positionCard(number: "3", label: "Einde")
                        }

                        HStack(spacing: 8) {
                            syllablePreview("ma")
                            syllablePreview("lin")
                            syllablePreview("no")
                        }
                    }

                    VStack(spacing: 10) {
                        HStack(spacing: 10) {
                            infoPill(title: "Naamtype", value: "Neutraal")
                            infoPill(title: "Posities", value: "3")
                        }

                        HStack(spacing: 8) {
                            positionCard(number: "1", label: "Start")
                            positionCard(number: "2", label: "Kern")
                            positionCard(number: "3", label: "Einde")
                        }

                        VStack(spacing: 8) {
                            HStack(spacing: 8) {
                                syllablePreview("ma")
                                syllablePreview("lin")
                            }

                            syllablePreview("no")
                        }
                    }
                }
            }
        }
    }

    private var premiumPage: some View {
        pageLayout(
            eyebrow: "Premium",
            title: "Meer ruimte voor jullie stijl",
            bodyText: "Ontgrendel 3, 4 en 5 posities, alle handmatige selectiemodi en iCloud-sync voor je favorieten."
        ) {
            VStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 10) {
                    premiumRow(icon: "sparkles", text: "Meer posities voor langere namen")
                    premiumRow(icon: "slider.horizontal.3", text: "Alle selectiemodi vrijspelen")
                    premiumRow(icon: "icloud.fill", text: "Favorieten op al je apparaten")
                    premiumRow(icon: "person.2.fill", text: "Family Sharing inbegrepen")
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.surfaceStrong)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Theme.borderStrong, lineWidth: 1)
                }

                if dynamicTypeSize.isAccessibilitySize {
                    VStack(spacing: 10) {
                        secondaryPremiumButton
                        primaryPremiumButton
                    }
                } else {
                    HStack(spacing: 12) {
                        secondaryPremiumButton
                        primaryPremiumButton
                    }
                }
            }
        }
    }

    private func pageLayout<Content: View>(
        eyebrow: String,
        title: String,
        bodyText: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(spacing: 0) {
            Spacer(minLength: 10)

            VStack(spacing: 16) {
                VStack(spacing: 6) {
                    Text(eyebrow)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(Theme.inkSoft)

                    Text(title)
                        .font(title == "Younique" ? titleDisplayFont : .system(size: 31, weight: .bold, design: .serif))
                        .foregroundStyle(Theme.ink)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .minimumScaleFactor(0.35)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Text(bodyText)
                    .font(.body.weight(.medium))
                    .foregroundStyle(Theme.inkSoft)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 8)

                content()
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)

            Spacer(minLength: 10)
        }
    }

    private func onboardingReel(_ syllable: String, delay: Double) -> some View {
        ReelCard(syllable: syllable, isSpinning: false, reelCount: .three)
            .frame(width: dynamicTypeSize.isAccessibilitySize ? onboardingReelWidth * 0.72 : onboardingReelWidth)
            .offset(y: animateHero ? 0 : 10)
            .scaleEffect(animateHero ? 1 : 0.95)
            .opacity(animateHero ? 1 : 0.75)
            .animation(
                .spring(response: 0.5, dampingFraction: 0.72)
                    .delay(delay),
                value: animateHero
            )
    }

    private func infoPill(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption.weight(.bold))
                .foregroundStyle(Theme.inkSoft)

            Text(value)
                .font(.title3.weight(.bold))
                .foregroundStyle(Theme.ink)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(.white.opacity(0.58))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func positionCard(number: String, label: String) -> some View {
        VStack(spacing: 6) {
            Text(number)
                .font(.title.weight(.bold))
                .foregroundStyle(Theme.accent)

            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Theme.inkSoft)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.55), lineWidth: 1)
        }
    }

    private func syllablePreview(_ syllable: String) -> some View {
        Text(syllable)
            .font(.headline.weight(.bold))
            .foregroundStyle(Theme.ink)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.white.opacity(0.72))
            .clipShape(Capsule())
    }

    private func premiumRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body.weight(.bold))
                .foregroundStyle(Theme.accent)
                .frame(width: 20)

            Text(text)
                .font(.body.weight(.medium))
                .foregroundStyle(Theme.ink)

            Spacer(minLength: 0)
        }
    }

    private var titleDisplayFont: Font {
        let baseSize: CGFloat = dynamicTypeSize.isAccessibilitySize ? 28 : 40
        return DisplayFont.snellBold.font(baseSize: baseSize)
    }

    private var secondaryPremiumButton: some View {
        Button("Misschien later") {
            onFinish()
        }
        .font(.body.weight(.semibold))
        .foregroundStyle(Theme.inkSoft)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Theme.surfaceMuted)
        .clipShape(Capsule())
    }

    private var primaryPremiumButton: some View {
        Button("Premium bekijken") {
            isPaywallPresented = true
        }
        .font(.body.weight(.bold))
        .foregroundStyle(Theme.accent)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Theme.surfaceStrong)
        .clipShape(Capsule())
    }
}

#Preview {
    OnboardingView(onFinish: {})
        .environment(PurchaseManager())
}

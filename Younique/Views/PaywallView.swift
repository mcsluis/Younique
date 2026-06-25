//
//  PaywallView.swift
//  Younique
//
//  Created by Marc van der Sluis on 24/06/2026.
//

import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(PurchaseManager.self) private var purchaseManager
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        @Bindable var manager = purchaseManager

        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Theme.creamTop, Theme.creamMid, Theme.sageBottom],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 28) {
                        Image(systemName: "sparkles")
                            .font(.system(size: dynamicTypeSize.isAccessibilitySize ? 44 : 56, weight: .bold))
                            .foregroundStyle(Theme.accent)
                            .symbolEffect(.pulse)

                        VStack(spacing: 12) {
                            Text("Haal meer uit Younique")
                                .font(.largeTitle.weight(.bold))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Theme.ink)

                            Text("Ontgrendel langere namen, extra klankstijlen en volledige controle over de lettergreepselectie met een eenmalige aankoop.")
                                .font(.body.weight(.medium))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Theme.inkSoft)
                        }
                        .padding(.horizontal, 24)

                        VStack(alignment: .leading, spacing: 14) {
                            Text("Wat je nu al gratis krijgt")
                                .font(.headline.weight(.bold))
                                .foregroundStyle(Theme.ink)

                            featureRow(icon: "wand.and.stars", text: "Onbeperkt namen genereren met 2 posities")
                            featureRow(icon: "slider.horizontal.3", text: "5 gratis klankstijlen om direct mee te spelen")
                            featureRow(icon: "heart.fill", text: "Favorieten bewaren, notities maken en delen")
                        }
                        .padding(20)
                        .background(Theme.surfaceStrong)
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(Theme.border, lineWidth: 1)
                        }
                        .padding(.horizontal, 24)

                        VStack(alignment: .leading, spacing: 14) {
                            Text("Wat Premium toevoegt")
                                .font(.headline.weight(.bold))
                                .foregroundStyle(Theme.ink)

                            featureRow(icon: "text.line.first.and.arrowtriangle.forward", text: "3, 4 en 5 posities voor langere en rijkere namen")
                            featureRow(icon: "square.grid.3x3.fill", text: "Alle selectiemodi, inclusief lettergrepen per positie kiezen")
                            featureRow(icon: "sparkles.rectangle.stack.fill", text: "3 extra premium klankstijlen voor meer richting en variatie")
                            featureRow(icon: "icloud.fill", text: "Favorieten synchroniseren via iCloud op al je apparaten")
                            featureRow(icon: "person.2.fill", text: "Deelbaar met je gezin via Family Sharing")
                            featureRow(icon: "infinity", text: "Eenmalig betalen, daarna blijvend ontgrendeld")
                        }
                        .padding(20)
                        .background(Theme.surfaceStrong)
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(Theme.border, lineWidth: 1)
                        }
                        .padding(.horizontal, 24)

                        VStack(spacing: 6) {
                            Text("Voor één kleine aankoop voelt de app veel vrijer en creatiever.")
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(Theme.ink)
                                .multilineTextAlignment(.center)

                            Text("Ideaal als jullie meerdere richtingen willen verkennen zonder vast te zitten aan de basisinstellingen.")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(Theme.inkSoft)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 24)

                        VStack(spacing: 14) {
                            Button {
                                Task { await purchaseManager.purchase() }
                            } label: {
                                HStack {
                                    if purchaseManager.isPurchasing {
                                        ProgressView()
                                            .tint(.white)
                                    } else {
                                        Text(purchaseButtonText)
                                            .font(.headline.weight(.bold))
                                    }
                                }
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
                            .disabled(purchaseManager.product == nil || purchaseManager.isPurchasing)
                            .opacity((purchaseManager.product == nil || purchaseManager.isPurchasing) ? 0.7 : 1)

                            Button {
                                Task { await purchaseManager.restore() }
                            } label: {
                                Text("Herstel aankopen")
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(Theme.inkSoft)
                            }
                            .disabled(purchaseManager.isPurchasing)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 16)
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Premium")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sluit") { dismiss() }
                        .tint(Theme.accent)
                }
            }
            .task {
                if purchaseManager.product == nil {
                    await purchaseManager.loadProduct()
                }
            }
            .onChange(of: purchaseManager.isUnlocked) { _, isUnlocked in
                if isUnlocked { dismiss() }
            }
            .alert("Er ging iets mis", isPresented: Binding(
                get: { manager.errorMessage != nil },
                set: { if !$0 { manager.errorMessage = nil } }
            )) {
                Button("OK") {}
            } message: {
                Text(purchaseManager.errorMessage ?? "")
            }
        }
    }

    private var purchaseButtonText: String {
        if let displayPrice = purchaseManager.product?.displayPrice {
            return "Ontgrendel Premium voor \(displayPrice)"
        }
        return "Laden..."
    }

    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body.weight(.bold))
                .foregroundStyle(Theme.accent)
                .frame(width: 22)
            Text(text)
                .font(.body.weight(.medium))
                .foregroundStyle(Theme.ink)
            Spacer()
        }
    }
}

#Preview {
    PaywallView()
        .environment(PurchaseManager())
}

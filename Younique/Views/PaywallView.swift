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
                            Text("Ontgrendel langere namen")
                                .font(.largeTitle.weight(.bold))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Theme.ink)

                            Text("Met de eenmalige Premium-aankoop gebruik je 3, 4 of 5 posities en alle selectiemodi, en synchroniseren je favorieten via iCloud naar al je apparaten. Deelbaar met je gezin via Family Sharing.")
                                .font(.body.weight(.medium))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Theme.inkSoft)
                        }
                        .padding(.horizontal, 24)

                        VStack(alignment: .leading, spacing: 10) {
                            featureRow(icon: "checkmark.seal.fill", text: "3, 4 en 5 posities + alle selectiemodi")
                            featureRow(icon: "icloud.fill", text: "Favorieten synchroniseren via iCloud")
                            featureRow(icon: "infinity", text: "Eenmalig betalen, voor altijd toegang")
                            featureRow(icon: "person.2.fill", text: "Deelbaar met je gezin via Family Sharing")
                        }
                        .padding(20)
                        .background(Theme.surfaceStrong)
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(Theme.border, lineWidth: 1)
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
            return "Ontgrendel voor \(displayPrice)"
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

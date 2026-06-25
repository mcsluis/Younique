//
//  SettingsView.swift
//  Younique
//
//  Created by Marc van der Sluis on 23/06/2026.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @AppStorage("displayFont") private var displayFontRaw: String = DisplayFont.default.rawValue
    @Environment(\.dismiss) private var dismiss
    @Environment(PurchaseManager.self) private var purchaseManager

    @State private var isPaywallPresented = false
    @State private var isPrivacyPolicyPresented = false

    private let previewName = "Younique"

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Premium") {
                    if purchaseManager.isUnlocked {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(Theme.accent)
                            Text("Premium ontgrendeld")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundStyle(Theme.ink)
                        }
                    } else {
                        Button {
                            isPaywallPresented = true
                        } label: {
                            HStack {
                                Image(systemName: "sparkles")
                                    .foregroundStyle(Theme.accent)
                                Text("Premium kopen")
                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                                    .foregroundStyle(Theme.ink)
                                Spacer()
                                if let displayPrice = purchaseManager.product?.displayPrice {
                                    Text(displayPrice)
                                        .font(.system(size: 13, weight: .medium, design: .rounded))
                                        .foregroundStyle(Theme.inkSoft)
                                }
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundStyle(Theme.inkSoft)
                            }
                        }
                        .buttonStyle(.plain)
                    }

                    Button {
                        Task { await purchaseManager.restore() }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .foregroundStyle(Theme.accent)
                            Text("Herstel aankopen")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundStyle(Theme.ink)
                        }
                    }
                    .buttonStyle(.plain)
                }

                Section("Lettertype gegenereerde naam") {
                    ForEach(DisplayFont.allCases) { option in
                        Button {
                            displayFontRaw = option.rawValue
                        } label: {
                            HStack(alignment: .center, spacing: 12) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(option.displayName)
                                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                                        .foregroundStyle(Theme.inkSoft)

                                    Text(previewName)
                                        .font(option.font(baseSize: 26))
                                        .foregroundStyle(Theme.ink)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                }

                                Spacer(minLength: 8)

                                if option.rawValue == displayFontRaw {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundStyle(Theme.accent)
                                }
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    }
                }

                Section("Over") {
                    Button {
                        isPrivacyPolicyPresented = true
                    } label: {
                        HStack {
                            Image(systemName: "hand.raised.fill")
                                .foregroundStyle(Theme.accent)
                            Text("Privacybeleid")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundStyle(Theme.ink)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(Theme.inkSoft)
                        }
                    }
                    .buttonStyle(.plain)

                    HStack {
                        Image(systemName: "app.badge")
                            .foregroundStyle(Theme.accent)
                        Text("Versie")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(Theme.ink)
                        Spacer()
                        Text(appVersion)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(Theme.inkSoft)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Instellingen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Klaar") { dismiss() }
                }
            }
            .sheet(isPresented: $isPaywallPresented) {
                PaywallView()
            }
            .sheet(isPresented: $isPrivacyPolicyPresented) {
                PrivacyPolicyView()
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(PurchaseManager())
}

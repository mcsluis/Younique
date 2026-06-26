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
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("appearancePreference") private var appearancePreferenceRaw = AppearancePreference.system.rawValue
    @AppStorage("appLanguagePreference") private var appLanguagePreferenceRaw = AppLanguagePreference.system.rawValue
    @Environment(\.dismiss) private var dismiss
    @Environment(PurchaseManager.self) private var purchaseManager

    @State private var isPaywallPresented = false
    @State private var isPrivacyPolicyPresented = false

    private var displayFont: DisplayFont {
        DisplayFont(rawValue: displayFontRaw) ?? .default
    }

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    if purchaseManager.isUnlocked {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(Theme.accent)
                            Text("Premium ontgrendeld")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(Theme.ink)
                        }
                    } else {
                        Button {
                            isPaywallPresented = true
                        } label: {
                            HStack(alignment: .firstTextBaseline) {
                                Image(systemName: "sparkles")
                                    .foregroundStyle(Theme.accent)
                                Text("Premium kopen")
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(Theme.ink)
                                Spacer()
                                if let displayPrice = purchaseManager.product?.displayPrice {
                                    Text(displayPrice)
                                        .font(.callout.weight(.medium))
                                        .foregroundStyle(Theme.inkSoft)
                                }
                                Image(systemName: "chevron.right")
                                    .font(.caption.weight(.bold))
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
                                .font(.body.weight(.semibold))
                                .foregroundStyle(Theme.ink)
                        }
                    }
                    .buttonStyle(.plain)
                } header: {
                    Text("Premium")
                } footer: {
                    Text("Premium is een eenmalige aankoop en wordt automatisch hersteld via je Apple-account.")
                }

                Section {
                    Picker("Lettertype", selection: $displayFontRaw) {
                        ForEach(DisplayFont.allCases) { option in
                            Text(option.displayName)
                                .font(option.font(baseSize: 17))
                                .tag(option.rawValue)
                        }
                    }

                    HStack {
                        Spacer()
                        Text("Younique")
                            .font(displayFont.font(baseSize: 32))
                            .foregroundStyle(Theme.ink)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .padding(.vertical, 8)
                        Spacer()
                    }
                    .accessibilityLabel("Voorbeeld in gekozen lettertype")
                } header: {
                    Text("Lettertype gegenereerde naam")
                } footer: {
                    Text("Dit lettertype wordt gebruikt zodra je een naam opent in het resultaat.")
                }

                Section {
                    Picker("Kleurmodus", selection: $appearancePreferenceRaw) {
                        ForEach(AppearancePreference.allCases) { option in
                            Text(option.title).tag(option.rawValue)
                        }
                    }

                    Picker("Taal", selection: $appLanguagePreferenceRaw) {
                        ForEach(AppLanguagePreference.allCases) { option in
                            Text(option.title).tag(option.rawValue)
                        }
                    }
                } header: {
                    Text("Weergave")
                } footer: {
                    Text("Wijzigingen in kleur en taal worden direct in de app toegepast.")
                }

                Section("Over") {
                    Button {
                        hasSeenOnboarding = false
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "sparkle")
                                .foregroundStyle(Theme.accent)
                            Text("Onboarding opnieuw tonen")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(Theme.ink)
                            Spacer()
                            Image(systemName: "arrow.counterclockwise")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(Theme.inkSoft)
                        }
                    }
                    .buttonStyle(.plain)

                    Button {
                        isPrivacyPolicyPresented = true
                    } label: {
                        HStack {
                            Image(systemName: "hand.raised.fill")
                                .foregroundStyle(Theme.accent)
                            Text("Privacybeleid")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(Theme.ink)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(Theme.inkSoft)
                        }
                    }
                    .buttonStyle(.plain)

                    HStack {
                        Image(systemName: "app.badge")
                            .foregroundStyle(Theme.accent)
                        Text("Versie")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(Theme.ink)
                        Spacer()
                        Text(appVersion)
                            .font(.callout.weight(.medium))
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
            .onChange(of: appLanguagePreferenceRaw) { _, newValue in
                let preference = AppLanguagePreference(rawValue: newValue) ?? .system
                Bundle.setAppLanguage(preference.languageCode)
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(PurchaseManager())
}

//
//  YouniqueApp.swift
//  Younique
//
//  Created by Marc van der Sluis on 21/06/2026.
//

import SwiftUI
import SwiftData

@main
struct YouniqueApp: App {
    @State private var purchaseManager = PurchaseManager()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("appearancePreference") private var appearancePreferenceRaw = AppearancePreference.system.rawValue
    @AppStorage("appLanguagePreference") private var appLanguagePreferenceRaw = AppLanguagePreference.system.rawValue

    init() {
        let preference = AppLanguagePreference(
            rawValue: UserDefaults.standard.string(forKey: "appLanguagePreference") ?? AppLanguagePreference.system.rawValue
        ) ?? .system
        Bundle.setAppLanguage(preference.languageCode)
    }

    private var appearancePreference: AppearancePreference {
        AppearancePreference(rawValue: appearancePreferenceRaw) ?? .system
    }

    private var appLanguagePreference: AppLanguagePreference {
        AppLanguagePreference(rawValue: appLanguagePreferenceRaw) ?? .system
    }

    private var shouldSkipOnboardingForUITests: Bool {
        ProcessInfo.processInfo.arguments.contains("UI_TEST_SKIP_ONBOARDING")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(purchaseManager)
                .preferredColorScheme(appearancePreference.colorScheme)
                .fullScreenCover(
                    isPresented: Binding(
                        get: { !hasSeenOnboarding && !shouldSkipOnboardingForUITests },
                        set: { newValue in
                            if !newValue {
                                hasSeenOnboarding = true
                            }
                        }
                    )
                ) {
                    OnboardingView {
                        hasSeenOnboarding = true
                    }
                    .environment(purchaseManager)
                }
                .task {
                    await purchaseManager.loadProduct()
                }
                .task(id: appLanguagePreference.rawValue) {
                    Bundle.setAppLanguage(appLanguagePreference.languageCode)
                }
                .environment(\.locale, appLanguagePreference.locale)
                .id(appLanguagePreference.rawValue)
        }
        .modelContainer(for: FavoriteName.self)
    }
}

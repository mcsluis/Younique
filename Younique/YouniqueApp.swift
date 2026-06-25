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

    private var appearancePreference: AppearancePreference {
        AppearancePreference(rawValue: appearancePreferenceRaw) ?? .system
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(purchaseManager)
                .preferredColorScheme(appearancePreference.colorScheme)
                .fullScreenCover(
                    isPresented: Binding(
                        get: { !hasSeenOnboarding },
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
        }
        .modelContainer(for: FavoriteName.self)
    }
}

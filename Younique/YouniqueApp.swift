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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(purchaseManager)
                .task {
                    await purchaseManager.loadProduct()
                }
        }
        .modelContainer(for: FavoriteName.self)
    }
}

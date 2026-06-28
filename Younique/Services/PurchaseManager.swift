//
//  PurchaseManager.swift
//  Younique
//
//  Created by Marc van der Sluis on 24/06/2026.
//

import Foundation
import StoreKit

@Observable
@MainActor
final class PurchaseManager {
    static let unlockProductID = "com.mcs.younique.unlock_full"

    /// v1.0 launches as free. While true, all Premium gates behave as unlocked
    /// and IAP-facing UI (paywall entries in Settings/Onboarding) stays hidden.
    /// Flip to false in v1.1 once the IAP is live in ASC.
    static let freeLaunch = true

    var product: Product?
    var isUnlocked: Bool = PurchaseManager.freeLaunch
    var isPurchasing: Bool = false
    var errorMessage: String?

    private nonisolated(unsafe) var updatesTask: Task<Void, Never>?

    init() {
        updatesTask = Task { [weak self] in
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await transaction.finish()
                    await self?.refreshEntitlement()
                }
            }
        }
    }

    deinit {
        updatesTask?.cancel()
    }

    func loadProduct() async {
        do {
            let products = try await Product.products(for: [Self.unlockProductID])
            product = products.first
            await refreshEntitlement()
        } catch {
            errorMessage = "Product kon niet worden geladen: \(error.localizedDescription)"
        }
    }

    func refreshEntitlement() async {
        if Self.freeLaunch {
            isUnlocked = true
            return
        }
        var unlocked = false
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == Self.unlockProductID,
               transaction.revocationDate == nil {
                unlocked = true
            }
        }
        isUnlocked = unlocked
    }

    func purchase() async {
        guard let product else { return }
        isPurchasing = true
        defer { isPurchasing = false }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    await transaction.finish()
                    await refreshEntitlement()
                } else {
                    errorMessage = "Aankoop kon niet worden geverifieerd."
                }
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func restore() async {
        do {
            try await AppStore.sync()
            await refreshEntitlement()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

//
//  PrivacyPolicyView.swift
//  Younique
//
//  Created by Marc van der Sluis on 25/06/2026.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Theme.creamTop, Theme.creamMid, Theme.sageBottom],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        section(
                            title: "Korte versie",
                            body: "Younique verzamelt en verstuurt geen persoonlijke gegevens. Alles wat je doet — namen genereren, favorieten bewaren, lettertype kiezen — blijft op je apparaat (of in je eigen iCloud)."
                        )

                        section(
                            title: "Wat slaan we op?",
                            body: "Op je apparaat: je favoriete namen (via Apple's SwiftData), je gekozen lettertype en de status van je Premium-aankoop. Niets hiervan wordt naar onze servers gestuurd — we hebben geen servers."
                        )

                        section(
                            title: "Aankopen",
                            body: "De Premium-aankoop verloopt volledig via Apple's App Store. Wij ontvangen geen betaalgegevens. Apple kan je bonnetje en aankoopstatus delen met de app — die gebruiken we alleen om Premium-functies te ontgrendelen. Family Sharing-leden krijgen automatisch toegang via Apple's eigen mechanisme."
                        )

                        section(
                            title: "Tracking & analytics",
                            body: "Younique gebruikt geen analytics, geen advertenties, geen tracking SDK's. Er worden geen gebeurtenissen of foutmeldingen naar externe diensten gestuurd."
                        )

                        section(
                            title: "iCloud-synchronisatie",
                            body: "Premium-gebruikers met iCloud ingeschakeld kunnen hun Youniquelist synchroniseren tussen hun eigen Apple-apparaten via Apple's SwiftData/CloudKit. Dit gebeurt versleuteld via je eigen Apple-ID — wij hebben er geen toegang toe. Family Sharing-leden behouden hun eigen iCloud en zien dus hun eigen favorieten, niet die van anderen."
                        )

                        section(
                            title: "Delen",
                            body: "Wanneer je een naam deelt via het deel-icoon, opent het standaard iOS-deelvenster. De naam gaat rechtstreeks naar de gekozen app (iMessage, WhatsApp, Mail, etc.) — Younique stuurt zelf geen data en houdt niets bij."
                        )

                        section(
                            title: "Kinderen",
                            body: "Younique is een tool voor (aanstaande) ouders. We verzamelen bewust geen gegevens, dus de app is geschikt voor alle leeftijden."
                        )

                        section(
                            title: "Contact",
                            body: "Vragen over privacy of de app in het algemeen? Mail naar mcsluis@gmail.com."
                        )

                        Text("Laatste update: 25 juni 2026")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(Theme.inkMuted)
                            .padding(.top, 8)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Privacybeleid")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sluit") { dismiss() }
                        .tint(Theme.accent)
                }
            }
        }
    }

    private func section(title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 17, weight: .semibold, design: .serif))
                .foregroundStyle(Theme.ink)

            Text(body)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.ink.opacity(0.78))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
        }
    }
}

#Preview {
    PrivacyPolicyView()
}

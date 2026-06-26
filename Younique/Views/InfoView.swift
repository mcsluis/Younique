//
//  InfoView.swift
//  Younique
//
//  Created by Marc van der Sluis on 22/06/2026.
//

import SwiftUI

struct InfoView: View {
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
                        title: "Hoe de app werkt",
                        lines: [
                            "Je kiest eerst het naamtype: meisjesnaam, jongensnaam of neutraal.",
                            "Daarna kies je hoeveel posities je wilt gebruiken: 2, 3, 4 of 5.",
                            "Daarna kies je hoe de lettergrepen bepaald worden via de selectiemodus.",
                            "Tik Ontdek een naam om de overlay te openen — daar verschijnt direct een naam.",
                            "In de overlay kun je opnieuw draaien met de toverstaf, de naam bewaren via het hartje, delen via het deel-icoon, of sluiten met het kruisje.",
                            "Het hartje linksboven in de werkbalk opent je bewaarde namen. Bij elke favoriet kun je via het deel-icoon de naam doorsturen naar je partner.",
                            "Het tandwiel rechtsboven laat je het lettertype voor de getoonde naam kiezen en je Premium-aankoop beheren."
                        ]
                    )

                    section(
                        title: "Naamtype",
                        lines: [
                            "Meisjesnaam laat meer zachte openers en meer open eindklanken over.",
                            "Jongensnaam laat meer stevige starts en meer gesloten of harde eindes over.",
                            "Neutraal haalt juist de meest uitgesproken meisjes- en jongensklanken weg voor een gemengder resultaat."
                        ]
                    )

                    section(
                        title: "Selectiemodi",
                        lines: [
                            "Geoptimaliseerd: de app gebruikt haar eigen lettergreeppools en optionele hoofdgroepfilters.",
                            "Iedere positie, elke lettergreep: elke positie gebruikt de volledige lettergreeppool, dus de opbouw is het meest los.",
                            "Elke gekozen lettergreep op alle posities: jij kiest lettergrepen en elke positie gebruikt exact dezelfde gekozen set.",
                            "Gekozen lettergrepen beschikbaar volgens de positiestructuur: jij kiest lettergrepen, maar de app verdeelt ze volgens de normale positieopbouw.",
                            "Zelf de lettergrepen per positie kiezen: jij bepaalt per positie apart welke lettergrepen beschikbaar zijn."
                        ]
                    )

                    section(
                        title: "Positieopbouw",
                        lines: [
                            "2 posities: begin + einde",
                            "3 posities: begin + midden + einde",
                            "4 posities: begin + verbinding + kern + einde",
                            "5 posities: begin + brug + kern + accent + einde"
                        ]
                    )

                    section(
                        title: "Wanneer verschijnt welke lettergreep",
                        lines: [
                            "In automatische modus bepaalt de positiestructuur welke pool op welke positie gebruikt wordt.",
                            "Het gekozen naamtype filtert eerst de beschikbare klanken, daarna volgt pas de positieverdeling of handmatige selectie.",
                            "Met \"Elke gekozen lettergreep op alle posities\" kan elke gekozen lettergreep op iedere positie terechtkomen.",
                            "Met \"Gekozen lettergrepen beschikbaar volgens de positiestructuur\" verschijnen alleen gekozen lettergrepen, maar nog wel binnen de logica van begin-, midden- en eindposities.",
                            "Met \"Zelf de lettergrepen per positie kiezen\" verschijnt op elke positie alleen wat je specifiek voor die positie hebt geselecteerd."
                        ]
                    )

                    section(
                        title: "Filters",
                        lines: [
                            "Hoofdgroepfilters werken alleen in de automatische modi.",
                            "Iedere positie, elke lettergreep gebruikt ook filters, maar laat alle posities uit dezelfde volledige pool trekken.",
                            "Handmatige modi zijn bewust eenvoudiger gehouden: daar stuur je direct op lettergrepen in plaats van op stijlclusters."
                        ]
                    )

                    section(
                        title: "Delen & bewaren",
                        lines: [
                            "Tik op het hartje om een naam aan je Youniquelist toe te voegen.",
                            "Tik in de Youniquelist op een naam om een notitie toe te voegen — bv. 'favo van mama' of 'past mooi bij Vermeer'.",
                            "Tik op het deel-icoon (vierkant met pijl) om een naam direct door te sturen naar je partner via iMessage, WhatsApp of e-mail.",
                            "Met Premium synchroniseren je favorieten via iCloud automatisch naar je andere Apple-apparaten."
                        ]
                    )

                    section(
                        title: "Premium",
                        lines: [
                            "Eenmalig €1,99 ontgrendelt 3, 4 en 5 posities en alle vier de handmatige selectiemodi.",
                            "Inclusief iCloud-synchronisatie van je Youniquelist.",
                            "Deelbaar met je gezin via Apple Family Sharing — als jij koopt, hebben gezinsleden ook toegang.",
                            "Eenmaal gekocht, voor altijd toegang. Geen abonnement."
                        ]
                    )
                }
                .padding(20)
                }
            }
            .navigationTitle("Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sluit") {
                        dismiss()
                    }
                    .tint(Theme.accent)
                }
            }
        }
    }

    private func section(title: LocalizedStringKey, lines: [LocalizedStringKey]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title3.weight(.semibold))
                .foregroundStyle(Theme.ink)

            ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                Text(line)
                    .font(.body.weight(.medium))
                    .foregroundStyle(Theme.ink.opacity(0.78))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Theme.border, lineWidth: 1)
        }
    }
}

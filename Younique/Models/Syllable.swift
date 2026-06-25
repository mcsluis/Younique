//
//  Syllable.swift
//  Younique
//
//  Created by Marc van der Sluis on 22/06/2026.
//

import Foundation

struct Syllable: Identifiable, Hashable {
    let id: String
    let text: String
    let preferredRoles: Set<SyllableRole>
    let styles: Set<SoundStyleTag>
    let nameTypes: Set<NameType>
    let groups: Set<NameFilterGroup>
    let weight: Double
}

extension Syllable {
    static let all: [Syllable] = allIDs.map { make($0) }

    static var a: Syllable { lookup["a"]! }
    static var an: Syllable { lookup["an"]! }
    static var ash: Syllable { lookup["ash"]! }
    static var ah: Syllable { lookup["ah"]! }
    static var ber: Syllable { lookup["ber"]! }
    static var bo: Syllable { lookup["bo"]! }
    static var brit: Syllable { lookup["brit"]! }
    static var ce: Syllable { lookup["ce"]! }
    static var cha: Syllable { lookup["cha"]! }
    static var ci: Syllable { lookup["ci"]! }
    static var cy: Syllable { lookup["cy"]! }
    static var da: Syllable { lookup["da"]! }
    static var de: Syllable { lookup["de"]! }
    static var del: Syllable { lookup["del"]! }
    static var des: Syllable { lookup["des"]! }
    static var dev: Syllable { lookup["dev"]! }
    static var di: Syllable { lookup["di"]! }
    static var dja: Syllable { lookup["dja"]! }
    static var dje: Syllable { lookup["dje"]! }
    static var `do`: Syllable { lookup["do"]! }
    static var el: Syllable { lookup["el"]! }
    static var en: Syllable { lookup["en"]! }
    static var ev: Syllable { lookup["ev"]! }
    static var ey: Syllable { lookup["ey"]! }
    static var fan: Syllable { lookup["fan"]! }
    static var fre: Syllable { lookup["fre"]! }
    static var i: Syllable { lookup["i"]! }
    static var im: Syllable { lookup["im"]! }
    static var `is`: Syllable { lookup["is"]! }
    static var it: Syllable { lookup["it"]! }
    static var ja: Syllable { lookup["ja"]! }
    static var jay: Syllable { lookup["jay"]! }
    static var jef: Syllable { lookup["jef"]! }
    static var jo: Syllable { lookup["jo"]! }
    static var ju: Syllable { lookup["ju"]! }
    static var ka: Syllable { lookup["ka"]! }
    static var kai: Syllable { lookup["kai"]! }
    static var ke: Syllable { lookup["ke"]! }
    static var kel: Syllable { lookup["kel"]! }
    static var ki: Syllable { lookup["ki"]! }
    static var kim: Syllable { lookup["kim"]! }
    static var la: Syllable { lookup["la"]! }
    static var le: Syllable { lookup["le"]! }
    static var ley: Syllable { lookup["ley"]! }
    static var li: Syllable { lookup["li"]! }
    static var lin: Syllable { lookup["lin"]! }
    static var lo: Syllable { lookup["lo"]! }
    static var lon: Syllable { lookup["lon"]! }
    static var lu: Syllable { lookup["lu"]! }
    static var ly: Syllable { lookup["ly"]! }
    static var lyn: Syllable { lookup["lyn"]! }
    static var lynn: Syllable { lookup["lynn"]! }
    static var ma: Syllable { lookup["ma"]! }
    static var man: Syllable { lookup["man"]! }
    static var mel: Syllable { lookup["mel"]! }
    static var mi: Syllable { lookup["mi"]! }
    static var mo: Syllable { lookup["mo"]! }
    static var na: Syllable { lookup["na"]! }
    static var nay: Syllable { lookup["nay"]! }
    static var ney: Syllable { lookup["ney"]! }
    static var ni: Syllable { lookup["ni"]! }
    static var no: Syllable { lookup["no"]! }
    static var ny: Syllable { lookup["ny"]! }
    static var o: Syllable { lookup["o"]! }
    static var on: Syllable { lookup["on"]! }
    static var pha: Syllable { lookup["pha"]! }
    static var pri: Syllable { lookup["pri"]! }
    static var que: Syllable { lookup["que"]! }
    static var quel: Syllable { lookup["quel"]! }
    static var ra: Syllable { lookup["ra"]! }
    static var re: Syllable { lookup["re"]! }
    static var rell: Syllable { lookup["rell"]! }
    static var ri: Syllable { lookup["ri"]! }
    static var ris: Syllable { lookup["ris"]! }
    static var ro: Syllable { lookup["ro"]! }
    static var sa: Syllable { lookup["sa"]! }
    static var sha: Syllable { lookup["sha"]! }
    static var son: Syllable { lookup["son"]! }
    static var ste: Syllable { lookup["ste"]! }
    static var ta: Syllable { lookup["ta"]! }
    static var tay: Syllable { lookup["tay"]! }
    static var ti: Syllable { lookup["ti"]! }
    static var tin: Syllable { lookup["tin"]! }
    static var ty: Syllable { lookup["ty"]! }
    static var va: Syllable { lookup["va"]! }
    static var vi: Syllable { lookup["vi"]! }
    static var von: Syllable { lookup["von"]! }
    static var x: Syllable { lookup["x"]! }
    static var ya: Syllable { lookup["ya"]! }
    static var you: Syllable { lookup["you"]! }
    static var za: Syllable { lookup["za"]! }
    static var shan: Syllable { lookup["shan"]! }

    static var ali: Syllable { lookup["ali"]! }
    static var astr: Syllable { lookup["astr"]! }
    static var bea: Syllable { lookup["bea"]! }
    static var bel: Syllable { lookup["bel"]! }
    static var beth: Syllable { lookup["beth"]! }
    static var blair: Syllable { lookup["blair"]! }
    static var car: Syllable { lookup["car"]! }
    static var cel: Syllable { lookup["cel"]! }
    static var clay: Syllable { lookup["clay"]! }
    static var elle: Syllable { lookup["elle"]! }
    static var frey: Syllable { lookup["frey"]! }
    static var ing: Syllable { lookup["ing"]! }
    static var isa: Syllable { lookup["isa"]! }
    static var jax: Syllable { lookup["jax"]! }
    static var liv: Syllable { lookup["liv"]! }
    static var lou: Syllable { lookup["lou"]! }
    static var lux: Syllable { lookup["lux"]! }
    static var luz: Syllable { lookup["luz"]! }
    static var mar: Syllable { lookup["mar"]! }
    static var max: Syllable { lookup["max"]! }
    static var mia: Syllable { lookup["mia"]! }
    static var nia: Syllable { lookup["nia"]! }
    static var noe: Syllable { lookup["noe"]! }
    static var nor: Syllable { lookup["nor"]! }
    static var rey: Syllable { lookup["rey"]! }
    static var ria: Syllable { lookup["ria"]! }
    static var rio: Syllable { lookup["rio"]! }
    static var rose: Syllable { lookup["rose"]! }
    static var run: Syllable { lookup["run"]! }
    static var rene: Syllable { lookup["rene"]! }
    static var sage: Syllable { lookup["sage"]! }
    static var sar: Syllable { lookup["sar"]! }
    static var se: Syllable { lookup["se"]! }
    static var sia: Syllable { lookup["sia"]! }
    static var skye: Syllable { lookup["skye"]! }
    static var sol: Syllable { lookup["sol"]! }
    static var sve: Syllable { lookup["sve"]! }
    static var thor: Syllable { lookup["thor"]! }
    static var tia: Syllable { lookup["tia"]! }
    static var tor: Syllable { lookup["tor"]! }
    static var ulf: Syllable { lookup["ulf"]! }
    static var vik: Syllable { lookup["vik"]! }
    static var wren: Syllable { lookup["wren"]! }
    static var zan: Syllable { lookup["zan"]! }
    static var zev: Syllable { lookup["zev"]! }

    static func withID(_ id: String) -> Syllable? {
        lookup[id.lowercased()]
    }

    private static let lookup: [String: Syllable] = Dictionary(
        uniqueKeysWithValues: all.map { ($0.id, $0) }
    )

    private static let allIDs: [String] = [
        "a", "an", "ash", "ah", "ber", "bo", "brit", "ce", "cha", "ci", "cy", "da", "de", "del",
        "des", "dev", "di", "dja", "dje", "do", "el", "en", "ev", "ey", "fan", "fre", "i", "im",
        "is", "it", "ja", "jay", "jef", "jo", "ju", "ka", "kai", "ke", "kel", "ki", "kim", "la",
        "le", "ley", "li", "lin", "lo", "lon", "lu", "ly", "lyn", "lynn", "ma", "man", "mel",
        "mi", "mo", "na", "nay", "ney", "ni", "no", "ny", "o", "on", "pha", "pri", "que", "quel",
        "ra", "re", "rell", "ri", "ris", "ro", "sa", "sha", "son", "ste", "ta", "tay", "ti",
        "tin", "ty", "va", "vi", "von", "x", "ya", "you", "za", "shan",
        "ali", "astr", "bea", "bel", "beth", "blair", "car", "cel", "clay", "elle", "frey", "ing",
        "isa", "jax", "liv", "lou", "lux", "luz", "mar", "max", "mia", "nia", "noe", "nor", "rey",
        "ria", "rio", "rose", "run", "rene", "sage", "sar", "se", "sia", "skye", "sol", "sve",
        "thor", "tia", "tor", "ulf", "vik", "wren", "zan", "zev"
    ]

    private static func make(_ text: String) -> Syllable {
        Syllable(
            id: text,
            text: text,
            preferredRoles: roles(for: text),
            styles: styles(for: text),
            nameTypes: allowedNameTypes(for: text),
            groups: groups(for: text),
            weight: weight(for: text)
        )
    }

    private static func roles(for text: String) -> Set<SyllableRole> {
        let value = text.lowercased()
        var roles = Set<SyllableRole>()

        if leadIDs.contains(value) { roles.insert(.lead) }
        if bridgeIDs.contains(value) { roles.insert(.bridge) }
        if coreIDs.contains(value) { roles.insert(.core) }
        if accentIDs.contains(value) { roles.insert(.accent) }
        if endingIDs.contains(value) { roles.insert(.ending) }

        if roles.isEmpty {
            roles = [.core]
        }

        return roles
    }

    private static func styles(for text: String) -> Set<SoundStyleTag> {
        let value = text.lowercased()
        var styles = Set<SoundStyleTag>()

        if latinIDs.contains(value) { styles.insert(.latin) }
        if spanishIDs.contains(value) { styles.insert(.spanish) }
        if englishIDs.contains(value) { styles.insert(.english) }
        if modernIDs.contains(value) { styles.insert(.modern) }
        if softIDs.contains(value) { styles.insert(.soft) }
        if boldIDs.contains(value) { styles.insert(.bold) }
        if romanticIDs.contains(value) { styles.insert(.romantic) }
        if elegantIDs.contains(value) { styles.insert(.elegant) }
        if unisexIDs.contains(value) { styles.insert(.unisex) }

        if styles.isEmpty {
            styles = [.unisex]
        }

        return styles
    }

    private static func allowedNameTypes(for text: String) -> Set<NameType> {
        let value = text.lowercased()
        var allowed: Set<NameType> = [.girl, .boy, .neutral]

        if girlDisallowedIDs.contains(value) { allowed.remove(.girl) }
        if boyDisallowedIDs.contains(value) { allowed.remove(.boy) }
        if neutralDisallowedIDs.contains(value) { allowed.remove(.neutral) }

        return allowed.isEmpty ? [.neutral] : allowed
    }

    private static func groups(for text: String) -> Set<NameFilterGroup> {
        let value = text.lowercased()
        var groups = Set<NameFilterGroup>()

        if sharpStartIDs.contains(value) { groups.insert(.sharpStarts) }
        if flowStartIDs.contains(value) { groups.insert(.flowStarts) }
        if urbanAccentIDs.contains(value) { groups.insert(.urbanAccents) }
        if englishTailIDs.contains(value) { groups.insert(.englishTails) }
        if softFillerIDs.contains(value) { groups.insert(.softFillers) }

        return groups
    }

    private static func weight(for text: String) -> Double {
        let value = text.lowercased()
        if signatureIDs.contains(value) { return 1.25 }
        if rareIDs.contains(value) { return 0.75 }
        return 1.0
    }
}

private extension Syllable {
    static let leadIDs: Set<String> = [
        "ash", "bo", "brit", "cha", "cy", "de", "dja", "dje", "ja", "jef", "jo", "ju",
        "ka", "kai", "ke", "ki", "kim", "la", "le", "li", "lo", "lu", "ma", "mel",
        "mi", "mo", "na", "ni", "no", "pri", "ra", "ro", "sa", "sha", "ste", "von",
        "ta", "ty", "vi", "you", "za", "ali", "astr", "bea", "bel", "beth", "blair",
        "car", "cel", "clay", "elle", "frey", "isa", "jax", "liv", "lou", "luz", "mar",
        "mia", "nia", "noe", "rey", "ria", "rose", "sage", "sar", "se", "sia", "skye",
        "sol", "sve", "thor", "tia", "tor", "ulf", "vik", "wren", "zan", "zev"
    ]

    static let bridgeIDs: Set<String> = [
        "a", "an", "ce", "ci", "da", "de", "di", "el", "ey", "i", "im", "is", "it",
        "la", "le", "li", "lin", "lo", "ly", "na", "ney", "ni", "o", "on", "ra",
        "re", "ri", "ro", "ta", "ti", "va", "bea", "car", "cel", "elle", "ing",
        "isa", "lou", "mia", "nia", "noe", "ria", "rio", "sar", "se", "sia", "tia"
    ]

    static let coreIDs: Set<String> = [
        "ash", "ber", "del", "dev", "ev", "fan", "fre", "jay", "kel", "ley", "lon",
        "man", "mel", "pha", "quel", "rell", "ris", "sha", "shan", "son", "tay", "von",
        "astr", "bel", "beth", "blair", "car", "clay", "frey", "ing", "jax", "lux",
        "mar", "max", "nor", "rey", "rio", "rose", "run", "sage", "skye", "sol",
        "thor", "tor", "ulf", "vik", "wren", "zan", "zev"
    ]

    static let accentIDs: Set<String> = [
        "a", "ah", "ce", "da", "el", "en", "ey", "ley", "lyn", "lynn", "na", "nay",
        "ney", "ni", "o", "on", "ra", "ri", "ro", "sha", "shan", "ta", "tin", "ya",
        "bea", "elle", "isa", "lou", "luz", "mia", "nia", "noe", "ria", "rose", "sage",
        "sar", "sia", "sol", "tia"
    ]

    static let endingIDs: Set<String> = [
        "a", "ah", "des", "do", "el", "en", "ey", "lyn", "lynn", "na", "no", "ny",
        "o", "on", "que", "ra", "ro", "son", "ta", "x", "ya", "ali", "ana", "bea",
        "beth", "elle", "ing", "isa", "lou", "lux", "luz", "mia", "noe", "rey", "ria",
        "rio", "rose", "sage", "skye", "sol", "thor", "tor", "vik", "wren", "zev"
    ]

    static let latinIDs: Set<String> = [
        "a", "ah", "ali", "ana", "bea", "bel", "car", "ce", "cha", "da", "de", "di",
        "el", "en", "isa", "la", "le", "li", "lo", "lou", "lu", "luz", "ma", "mar",
        "mel", "mi", "mia", "na", "nia", "noe", "o", "ra", "re", "ri", "ria", "rio",
        "ro", "sa", "sar", "se", "sha", "sia", "sol", "ta", "tia", "va", "ya"
    ]

    static let spanishIDs: Set<String> = [
        "a", "ali", "ana", "bel", "car", "ce", "cha", "da", "de", "di", "el", "en",
        "isa", "la", "lo", "lou", "luz", "mar", "na", "noe", "o", "ra", "ri", "ria",
        "rio", "ro", "sa", "sar", "se", "sol", "ta", "tia", "ya"
    ]

    static let englishIDs: Set<String> = [
        "ash", "ber", "beth", "blair", "brit", "clay", "elle", "ey", "jay", "kel", "ley",
        "lin", "lyn", "lynn", "ney", "que", "rell", "rose", "sage", "skye", "son", "tay",
        "wren"
    ]

    static let modernIDs: Set<String> = [
        "ash", "blair", "cy", "dev", "jax", "kai", "ki", "lux", "max", "mia", "noe",
        "ria", "sage", "skye", "ty", "va", "vi", "vik", "wren", "x", "ya", "you", "za", "zev"
    ]

    static let softIDs: Set<String> = [
        "a", "ah", "an", "bea", "ce", "el", "elle", "en", "ey", "i", "isa", "la", "le",
        "li", "lin", "lou", "lu", "ma", "mel", "mi", "mia", "na", "nia", "o", "ra",
        "ri", "ria", "sa", "sha", "sia", "sol", "ta", "ya"
    ]

    static let boldIDs: Set<String> = [
        "ash", "ber", "blair", "bo", "brit", "dev", "fan", "fre", "jax", "ka", "ke",
        "kel", "lux", "max", "ris", "ro", "run", "ste", "thor", "tor", "ty",
        "ulf", "vik", "von", "x", "zan", "zev"
    ]

    static let romanticIDs: Set<String> = [
        "ah", "bea", "bel", "ce", "cha", "el", "elle", "en", "ey", "isa", "la", "le",
        "ley", "li", "lou", "luz", "ma", "mel", "mia", "na", "nia", "noe", "ra", "ri",
        "ria", "rose", "sa", "sha", "sia", "sol", "ya"
    ]

    static let elegantIDs: Set<String> = [
        "astr", "bea", "bel", "beth", "car", "cel", "clay", "elle", "kel", "ley", "lin",
        "lou", "lynn", "noe", "que", "quel", "rell", "rene", "ria", "rose", "sage", "sha",
        "skye", "wren"
    ]

    static let unisexIDs: Set<String> = [
        "ash", "bo", "ce", "de", "el", "frey", "ka", "ki", "la", "li", "lo", "lux",
        "mar", "mi", "na", "no", "ra", "ri", "rio", "ro", "sage", "sol", "ta", "tor",
        "va", "vi", "vik", "wren", "ya", "zev"
    ]

    static let sharpStartIDs: Set<String> = [
        "blair", "brit", "clay", "jax", "ka", "ke", "pri", "ste", "ta", "thor", "tor", "vik"
    ]

    static let flowStartIDs: Set<String> = [
        "ali", "ana", "bea", "el", "elle", "isa", "la", "le", "li", "lu", "ma", "mel", "mi",
        "mia", "na", "nia", "noe", "ra", "ria", "rose", "sa", "sha", "sol"
    ]

    static let urbanAccentIDs: Set<String> = [
        "dja", "dje", "jay", "jax", "sha", "thor", "ty", "ya", "you", "za", "zan", "zev"
    ]

    static let englishTailIDs: Set<String> = [
        "beth", "blair", "clay", "ey", "ley", "lyn", "lynn", "ney", "rose", "sage", "skye",
        "son", "tay", "wren"
    ]

    static let softFillerIDs: Set<String> = [
        "a", "an", "bea", "ce", "de", "di", "el", "en", "i", "isa", "na", "nia", "o", "on",
        "ra", "ria", "se", "ta"
    ]

    static let girlDisallowedIDs: Set<String> = [
        "jef", "cy", "son", "x", "do", "des", "dev", "del", "kel", "lon", "man", "no", "on",
        "ro", "ty", "jax", "max", "thor", "tor", "ulf", "vik", "zev"
    ]

    static let boyDisallowedIDs: Set<String> = [
        "brit", "cha", "dja", "dje", "pri", "sha", "mel", "lyn", "lynn", "que", "ya", "bea",
        "beth", "elle", "lou", "mia", "nia", "ria", "rose", "sia"
    ]

    static let neutralDisallowedIDs: Set<String> = [
        "dja", "dje", "jef", "pri", "brit", "son", "x", "des", "beth"
    ]

    static let signatureIDs: Set<String> = [
        "ash", "ce", "cha", "el", "kel", "la", "ley", "lou", "mar", "mi", "ra", "rio", "rose",
        "sage", "sha", "sol", "tor", "vi", "wren", "zev"
    ]

    static let rareIDs: Set<String> = [
        "ali", "astr", "dja", "dje", "ing", "jef", "lux", "noe", "rene", "sar", "sve", "ulf"
    ]
}

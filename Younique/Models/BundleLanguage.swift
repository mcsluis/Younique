//
//  BundleLanguage.swift
//  Younique
//
//  Created by Codex on 26/06/2026.
//

import Foundation
import ObjectiveC.runtime

private var bundleLanguageKey: UInt8 = 0

private final class LocalizedBundle: Bundle, @unchecked Sendable {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let overrideBundle = objc_getAssociatedObject(self, &bundleLanguageKey) as? Bundle {
            return overrideBundle.localizedString(forKey: key, value: value, table: tableName)
        }

        return super.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    static func setAppLanguage(_ languageCode: String?) {
        object_setClass(Bundle.main, LocalizedBundle.self)

        guard let languageCode,
              let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            objc_setAssociatedObject(Bundle.main, &bundleLanguageKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return
        }

        objc_setAssociatedObject(Bundle.main, &bundleLanguageKey, bundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    static func appLocalizedString(_ key: String) -> String {
        if let overrideBundle = objc_getAssociatedObject(Bundle.main, &bundleLanguageKey) as? Bundle {
            return overrideBundle.localizedString(forKey: key, value: nil, table: nil)
        }

        return Bundle.main.localizedString(forKey: key, value: nil, table: nil)
    }
}

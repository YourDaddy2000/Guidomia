//
//  Extension+Double.swift
//  Guidomia
//
//  Created by Roman Bozhenko on 05.06.2021.
//

import Foundation

extension Double {
    var kFormatted: String {
        switch self {
        case ..<1_000:
            return String(format: "%.0f", locale: Locale.current, self)
        case 1_000 ..< 999_999:
            return String(format: "%.1fK", locale: Locale.current, self / 1_000).replacingOccurrences(of: ".0", with: "")
        default:
            return String(format: "%.1fM", locale: Locale.current, self / 1_000_000).replacingOccurrences(of: ".0", with: "")
        }
    }
}

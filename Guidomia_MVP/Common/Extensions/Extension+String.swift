//
//  Extension+String.swift
//  Guidomia_MVP
//
//  Created by Roman Bozhenko on 09.06.2021.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

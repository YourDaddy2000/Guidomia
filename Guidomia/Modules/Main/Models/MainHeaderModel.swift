//
//  MainHeaderModel.swift
//  Guidomia
//
//  Created by Roman Bozhenko on 05.06.2021.
//

struct MainHeaderModel: Codable, Equatable {
    let backgroundImageName: String
    let title: String
    let subtitle: String
    
    static func ==(lhs: MainHeaderModel, rhs: MainHeaderModel) -> Bool {
        lhs.backgroundImageName == rhs.backgroundImageName &&
        lhs.title == rhs.title &&
        lhs.subtitle == rhs.subtitle
    }
}

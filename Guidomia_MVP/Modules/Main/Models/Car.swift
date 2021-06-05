//
//  Car.swift
//  Guidomia_MVP
//
//  Created by Roman Bozhenko on 04.06.2021.
//

struct CarModel: Codable {
    let consList: [String]
    let customerPrice: Double
    let make: String
    let marketPrice: Double
    let model: String
    let prosList: [String]
    let rating: Int
    
    var imageName: String {
        make.lowercased()
            .appending(" ")
            .appending(model.lowercased())
            .replacingOccurrences(of: " ", with: "_")
    }
}

//
//  Car.swift
//  Guidomia_MVP
//
//  Created by Roman Bozhenko on 04.06.2021.
//

struct CarModel: Codable, Equatable {
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
    
    static func ==(lhs: CarModel, rhs: CarModel) -> Bool {
        lhs.consList == rhs.consList &&
        lhs.customerPrice == rhs.customerPrice &&
        lhs.make == rhs.make &&
        lhs.marketPrice == rhs.marketPrice &&
        lhs.model == rhs.model &&
        lhs.prosList == rhs.prosList &&
        lhs.rating == rhs.rating
    }
}

//
//  CombinedMainModel.swift
//  Guidomia
//
//  Created by Roman Bozhenko on 05.06.2021.
//

struct CombinedMainModel {
    var header: MainHeaderModel?
    var cars: [CarModel] = []
    var pickerItems: [String: [String]] = [:]
}

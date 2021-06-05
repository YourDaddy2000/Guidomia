//
//  MainJSONService.swift
//  Guidomia_MVP
//
//  Created by Roman Bozhenko on 04.06.2021.
//

import Foundation

protocol MainModuleApiProtocol {
    func fetchHeader(completion: (Result<MainHeaderModel?, NSError>) -> Void)
    func fetchCarList(completion: (Result<[CarModel]?, NSError>) -> Void)
}

struct MainJSONService: MainModuleApiProtocol {
    private struct Keys {
        static let name = "car_list"
        static let type = "json"
    }
    
    func fetchHeader(completion: (Result<MainHeaderModel?, NSError>) -> Void) {
        let model = MainHeaderModel(
            backgroundImageName: "tacoma",
            title: "Tacoma 2021",
            subtitle: "Get your's now")
        completion(.success(model))
    }
    
    func fetchCarList(completion: (Result<[CarModel]?, NSError>) -> Void) {
        if let path = Bundle.main.path(forResource: Keys.name, ofType: Keys.type) {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let cars = try JSONDecoder().decode([CarModel].self, from: data)
                completion(.success(cars))
              } catch {
                completion(.failure(error as NSError))
              }
        }
    }
}

//
//  MainPresenter.swift
//  Guidomia_MVP
//
//  Created by Roman Bozhenko on 04.06.2021.
//

import Foundation

protocol MainPresenterProtocol: BasePresenterProtocol {
    init(viewController: MainPresenterOutputProtocol,
         coordinator: MainCoordinator,
         api: MainModuleApiProtocol)
    func fetchCarList()
    func fetchHeader()
    func filter(make: String)
    func filter(modelName: String, cars: [CarModel])
    func convertOffersIntoPickerItems(
        currentPickerItems: [String : [String]],
        offers: [(make: String, model: String)]
    ) -> [String : [String]]
}

final class MainPresenter: MainPresenterProtocol {
    private weak var controller: MainPresenterOutputProtocol!
    private weak var coordinator: MainCoordinator!
    private let api: MainModuleApiProtocol
    
    private var carsBackup: [CarModel] = []
    
    init(viewController: MainPresenterOutputProtocol,
         coordinator: MainCoordinator,
         api: MainModuleApiProtocol) {
        self.controller = viewController
        self.coordinator = coordinator
        self.api = api
    }
    
    func viewDidLoad() {
        fetchHeader()
        fetchCarList()
    }
    
    func fetchCarList() {
        api.fetchCarList { [weak self] result in
            switch result {
            case .success(let cars):
                self?.carsBackup = cars ?? []
                self?.handle(cars)
            case .failure(let error):
                self?.handle(error)
            }
        }
    }
    
    func fetchHeader() {
        api.fetchHeader { [weak self] result in
            switch result {
            case .success(let header):
                self?.handle(header)
            case .failure(let error):
                self?.handle(error)
            }
        }
    }
    
    func filter(make: String) {
        if make.isEmpty {
            return handle(carsBackup)
        }
        
        let filteredItems = carsBackup.filter { $0.make == make }
        handle(filteredItems)
    }
    
    func filter(modelName: String, cars: [CarModel]) {
        guard !modelName.isEmpty else { return }
        let filteredItems = cars.filter { $0.model == modelName }
        handle(filteredItems)
    }
    
    func convertOffersIntoPickerItems(
        currentPickerItems: [String : [String]],
        offers: [(make: String, model: String)]
    ) -> [String : [String]] {
        var newPI = currentPickerItems
        
        offers.forEach {
            if newPI[$0.make] == nil {
                newPI[$0.make] = []
            }

            if !newPI[$0.make]!.contains($0.model) {
                newPI[$0.make]?.append($0.model)
            }
        }
        
        return newPI
    }
}

//MARK: - Private Methods Extension
private extension MainPresenter {
    func handle(_ error: NSError) {
        controller.show(error: error)
    }
    
    func handle(_ header: MainHeaderModel?) {
        if let header = header {
            controller.updateHeader(header)
        }
    }
    
    func handle(_ cars: [CarModel]?) {
        guard let cars = cars else { return }
        let prosAndCons = cars.map { ($0.prosList, $0.consList) }
        let offers = cars.map { ($0.make, $0.model) }
        
        controller.updateCars(cars, offers, prosAndCons)
    }
}

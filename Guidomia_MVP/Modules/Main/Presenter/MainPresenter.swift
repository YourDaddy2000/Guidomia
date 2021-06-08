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
    func filter(make: String, model: String, cars: [CarModel])
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
                self?.controller.updateCars(cars)
            case .failure(let error):
                self?.handle(error)
            }
        }
    }
    
    func fetchHeader() {
        api.fetchHeader { [weak self] result in
            switch result {
            case .success(let header):
                self?.controller.updateHeader(header)
            case .failure(let error):
                self?.handle(error)
            }
        }
    }
    
    func filter(make: String) {
        if make.isEmpty {
            return controller.updateCars(carsBackup)
        }
        
        let filteredItems = carsBackup.filter { $0.make == make }
        controller.updateCars(filteredItems)
    }
    
    func filter(make: String, model: String, cars: [CarModel]) {
        filter(make: make)
        
        guard !model.isEmpty else { return }
        let filteredItems = cars.filter { $0.model == model }
        controller.updateCars(filteredItems)
    }
}

//MARK: - Private Methods Extension
private extension MainPresenter {
    func handle(_ error: NSError) {
        controller.show(error: error)
    }
}

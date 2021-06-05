//
//  MainPresenter.swift
//  Guidomia_MVP
//
//  Created by Roman Bozhenko on 04.06.2021.
//

import Foundation

protocol MainPresenterProtocol: BasePresenterProtocol {
    var tableViewItems: CombinedMainModel { get }
    init(viewController: MainPresenterOutputProtocol,
         coordinator: MainCoordinator,
         api: MainModuleApiProtocol)
}

final class MainPresenter: MainPresenterProtocol {
    private weak var controller: MainPresenterOutputProtocol!
    private weak var coordinator: MainCoordinator!
    private let api: MainModuleApiProtocol
    
    var tableViewItems = CombinedMainModel() {
        didSet {
            controller.reloadTableView()
        }
    }
    
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
}

//MARK: - Private Methods Extension
private extension MainPresenter {
    func handle(_ error: NSError) {
        controller.show(error: error)
    }
    
    func handle(_ header: MainHeaderModel?) {
        if let header = header {
            tableViewItems.header = header
        }
    }
    
    func handle(_ cars: [CarModel]?) {
        if let cars = cars {
            tableViewItems.cars = cars
        }
    }
}

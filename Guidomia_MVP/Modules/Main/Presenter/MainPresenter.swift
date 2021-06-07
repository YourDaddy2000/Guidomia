//
//  MainPresenter.swift
//  Guidomia_MVP
//
//  Created by Roman Bozhenko on 04.06.2021.
//

import Foundation

protocol MainPresenterProtocol: BasePresenterProtocol {
    var tableViewItems: CombinedMainModel { get }
    var prosAndConsStackViewWidth: Double { get set }
    var expandedCellIndex: Int { get set }
    var amountOfNonExpandableCells: Int { get }
    var selectedMake: String { get set }
    var selectedModel: String { get set }
    
    init(viewController: MainPresenterOutputProtocol,
         coordinator: MainCoordinator,
         api: MainModuleApiProtocol)
    func fetchCarList()
    func fetchHeader()
    func filter(make: String)
    func filter(model: String)
}

final class MainPresenter: MainPresenterProtocol {
    private weak var controller: MainPresenterOutputProtocol!
    private weak var coordinator: MainCoordinator!
    private let api: MainModuleApiProtocol
    
    private var carsBackup: [CarModel] = []
    
    var tableViewItems = CombinedMainModel()
    var prosAndConsStackViewWidth: Double = 0
    var amountOfNonExpandableCells: Int = 1
    var expandedCellIndex: Int = 0
    var selectedMake: String = ""
    var selectedModel: String = ""
    
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
        expandedCellIndex = 0
        handle(filteredItems)
    }
    
    func filter(model: String) {
        filter(make: selectedMake)
        
        guard !model.isEmpty else { return }
        let filteredItems = tableViewItems.cars.filter { $0.model == model }
        expandedCellIndex = 0
        handle(filteredItems)
    }
}

//MARK: - Private Methods Extension
private extension MainPresenter {
    func handle(_ error: NSError) {
        controller.show(error: error)
    }
    
    func handle(_ model: MainHeaderModel?) {
        if let model = model,
           tableViewItems.header != model {
            tableViewItems.header = model
            controller.reloadTableView()
        }
    }
    
    func handle(_ models: [CarModel]?) {
        if let models = models,
           tableViewItems.cars != models {
            tableViewItems.cars = models
            tableViewItems.prosAndCons = models.map { ($0.prosList, $0.consList) }
            
            let offers: [(make: String, model: String)] = models.map { ($0.make, $0.model) }
            
            
            offers.forEach {
                if tableViewItems.pickerItems[$0.make] == nil {
                    tableViewItems.pickerItems[$0.make] = []
                }
                
                if !tableViewItems.pickerItems[$0.make]!.contains($0.model) {
                    tableViewItems.pickerItems[$0.make]?.append($0.model)
                }
            }
            controller.reloadTableView()
        }
    }
}

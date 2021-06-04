//
//  MainPresenter.swift
//  Guidomia_MVP
//
//  Created by Roman Bozhenko on 04.06.2021.
//

protocol MainPresenterProtocol: BasePresenterProtocol {
    init(viewController: MainPresenterOutputProtocol,
         coordinator: MainCoordinator)
}

final class MainPresenter: MainPresenterProtocol {
    private weak var controller: MainPresenterOutputProtocol!
    private weak var coordinator: MainCoordinator!
    
    init(viewController: MainPresenterOutputProtocol,
         coordinator: MainCoordinator) {
        self.controller = viewController
        self.coordinator = coordinator
    }
    
    func viewDidLoad() {
        
    }
    
    
}


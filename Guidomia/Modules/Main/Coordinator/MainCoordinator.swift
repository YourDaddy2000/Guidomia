//
//  MainCoordinator.swift
//  Guidomia
//
//  Created by Roman Bozhenko on 04.06.2021.
//

import UIKit

protocol MainCoordinatorInputProtocol: class {
    init(navigationController: UINavigationController, router: MainCoordinatorOutputProtocol)
}

protocol MainCoordinatorOutputProtocol: class {
    
}

final class MainCoordinator {
    private let navigationController: UINavigationController
    private weak var router: MainCoordinatorOutputProtocol?
    
    init(navigationController: UINavigationController, router: MainCoordinatorOutputProtocol) {
        self.navigationController = navigationController
        self.router = router
        
        let viewController = getMainController()
        navigationController.viewControllers = [viewController]
    }
    
    private func getMainController() -> UIViewController {
        let viewController = MainViewController()
        let presenter = MainPresenter(
            viewController: viewController,
            coordinator: self,
            api: MainJSONService())
        viewController.presenter = presenter
        
        return viewController
    }
}

extension MainCoordinator: MainCoordinatorInputProtocol {
    
}

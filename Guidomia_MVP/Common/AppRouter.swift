//
//  AppRouter.swift
//  Guidomia_MVP
//
//  Created by Roman Bozhenko on 04.06.2021.
//

import UIKit

final class Router {
    private let navigationController: UINavigationController
    private var mainCoordinator: MainCoordinatorInputProtocol?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        configure()
    }
    
    private func configure() {
        mainCoordinator = MainCoordinator(
            navigationController: navigationController,
            router: self)
    }
}

extension Router: MainCoordinatorOutputProtocol {
    
}

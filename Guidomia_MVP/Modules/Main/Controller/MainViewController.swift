//
//  MainViewController.swift
//  Guidomia_MVP
//
//  Created by Roman Bozhenko on 04.06.2021.
//

import UIKit

protocol MainPresenterOutputProtocol: BaseViewControllerProtocol {
    
}

final class MainViewController: BaseViewController {
    
    var presenter: MainPresenterProtocol!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    
}

// MARK: - Presenter output protocol implementation
extension MainViewController: MainPresenterOutputProtocol {
    
    
}

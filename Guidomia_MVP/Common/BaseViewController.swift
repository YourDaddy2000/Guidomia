//
//  BaseViewController.swift
//  Guidomia_MVP
//
//  Created by Roman Bozhenko on 04.06.2021.
//

import UIKit

protocol BaseViewControllerProtocol: AnyObject {
    func show(error: NSError)
    func show(message: String, title: String?)
}

class BaseViewController: UIViewController, BaseViewControllerProtocol {
    func show(error: NSError) {
        self.show(message: error.localizedDescription, title: "Whoops!")
    }
    
    func show(message: String, title: String?) {
        let popup = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let positiveAction = UIAlertAction(title: "ok",
                                           style: .default,
                                           handler: nil)
        popup.addAction(positiveAction)
        popup.preferredAction = positiveAction
        
        self.present(popup, animated: true, completion: nil)
    }
}

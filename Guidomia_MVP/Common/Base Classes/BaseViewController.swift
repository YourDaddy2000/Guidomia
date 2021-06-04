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

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureNavBar() {
        setRightBarButton()
        setNavBarBackground()
        setTitle("Guidomia")
    }
    
    func setNavBarBackground() {
        let image = Drawer.drawNavBarBackgroundImage(height: navBarHeight)
        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
    }
    
    func setTitle(_ title: String) {
        let titleLabel = UILabel()
        titleLabel.text = title.uppercased()
        titleLabel.font = UIFont(name: "Copperplate", size: 27)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        titleLabel.frame.size.height = navBarHeight
        titleLabel.frame.origin.x = 10
        navigationController?.navigationBar.addSubview(titleLabel)
        navigationItem.titleView = UIView()
    }
    
    func setRightBarButton() {
        let img = Drawer.drawMenuButtonImage()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: img.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(didTapRightBarButton))
    }
    
    @objc func didTapRightBarButton() {
        show(message: "This has not been implemented yet", title: "Whoops!")
    }
}
    
extension BaseViewController: BaseViewControllerProtocol {
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

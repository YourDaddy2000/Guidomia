//
//  BaseViewController.swift
//  Guidomia
//
//  Created by Roman Bozhenko on 04.06.2021.
//

import UIKit

protocol BaseViewControllerProtocol: AnyObject {
    func show(error: NSError)
    func show(message: String, title: String?)
}

class BaseViewController: UIViewController {
    
    override var title: String? { didSet { setTitle(title) } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureNavBar() {
        title = .guidomia
        setRightBarButton()
        setNavBarBackground()
    }
    
    func setNavBarBackground() {
        let image = Drawer.drawNavBarBackgroundImage(height: navBarHeight)
        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
    }
    
    func setRightBarButton() {
        let image = Drawer.drawMenuButtonImage()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: image.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(didTapRightBarButton))
    }
    
    @objc func didTapRightBarButton() {
        show(message: .notImplemented, title: .whoops)
    }
}
    
extension BaseViewController: BaseViewControllerProtocol {
    func show(error: NSError) {
        show(message: error.localizedDescription, title: .whoops)
    }
    
    func show(message: String, title: String?) {
        let popup = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let positiveAction = UIAlertAction(title: .ok,
                                           style: .default,
                                           handler: nil)
        popup.addAction(positiveAction)
        popup.preferredAction = positiveAction
        present(popup, animated: true)
    }
}

//MARK: - Private Methods Extension
 private extension BaseViewController {
    func setTitle(_ title: String?) {
        guard let title = title else { return }
        let titleLabelTag = 123
        let titleLabel = UILabel()
        let navBar = navigationController?.navigationBar
        
        titleLabel.text = title.uppercased()
        titleLabel.font = UIFont(name: "Copperplate", size: 27)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        titleLabel.frame.size.height = navBarHeight
        titleLabel.frame.origin.x = 10
        titleLabel.tag = titleLabelTag
        
        navBar?.viewWithTag(titleLabelTag)?.removeFromSuperview()
        navBar?.addSubview(titleLabel)
        navigationItem.titleView = UIView()
    }
}

private extension String {
    static let whoops = "Whoops!"
    static let notImplemented = "This is under development"
    static let ok = "Ok"
    static let guidomia = "Guidomia"
}

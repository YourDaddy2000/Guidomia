//
//  Extension+UIViewController.swift
//  Guidomia
//
//  Created by Roman Bozhenko on 04.06.2021.
//

import UIKit

extension UIViewController {
    var navBarHeight: CGFloat {
        let manager = view.window?.windowScene?.statusBarManager
        let barFrameHeight = manager?.statusBarFrame.height ?? 0
        let barHeight = navigationController?.navigationBar.frame.height ?? 0
        
        return barFrameHeight + barHeight
    }
}

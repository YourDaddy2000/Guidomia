//
//  Extension+UIView.swift
//  Guidomia_MVP
//
//  Created by Roman Bozhenko on 06.06.2021.
//
import UIKit

extension UIView {
    func hide(_ isHidden: Bool, views: [UIView]) {
        views.forEach {
            $0.isHidden = isHidden
        }
    }
    
    func set(alpha: CGFloat, for views: [UIView]) {
        views.forEach {
            $0.alpha = alpha
        }
    }
    
    func removeSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}

extension UIStackView {
    func removeArrangedSubviews() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}

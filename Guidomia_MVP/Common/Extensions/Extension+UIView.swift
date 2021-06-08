//
//  Extension+UIView.swift
//  Guidomia_MVP
//
//  Created by Roman Bozhenko on 06.06.2021.
//
import UIKit

extension UIView {
    @IBInspectable
        var shadowRadius: CGFloat {
            get {
                layer.shadowRadius
            }
            set {
                layer.masksToBounds = false
                layer.shadowRadius = newValue
            }
        }

        @IBInspectable
        var shadowOpacity: Float {
            get {
                layer.shadowOpacity
            }
            set {
                layer.masksToBounds = false
                layer.shadowOpacity = newValue
            }
        }

        @IBInspectable
        var shadowOffset: CGSize {
            get {
                return layer.shadowOffset
            }
            set {
                layer.masksToBounds = false
                layer.shadowOffset = newValue
            }
        }

        @IBInspectable
        var shadowColor: UIColor? {
            get {
                if let color = layer.shadowColor {
                    return UIColor(cgColor: color)
                }
                return nil
            }
            set {
                if let color = newValue {
                    layer.shadowColor = color.cgColor
                } else {
                    layer.shadowColor = nil
                }
            }
        }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            layer.cornerRadius
        }
    }
    
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
    
    static var id: String {
        return String(describing: self)
    }
}

extension UIStackView {
    func removeArrangedSubviews() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}

//
//  Extension+UITableView.swift
//  Guidomia
//
//  Created by Roman Bozhenko on 08.06.2021.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_ type: T.Type) {
        let nib = UINib(nibName: type.id, bundle: nil)
        register(nib, forCellReuseIdentifier: type.id)
    }
    
    func register(_ types: [UITableViewCell.Type]) {
        types.forEach { register($0) }
    }
    
    func register<T: UITableViewHeaderFooterView>(_ type: T.Type) {
        let nib = UINib(nibName: type.id, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: type.id)
    }
    
    func dequeue<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T {
        dequeueReusableHeaderFooterView(withIdentifier: type.id) as! T
    }
    
    func dequeue<T: UITableViewCell>(_ type: T.Type) -> T {
        dequeueReusableCell(withIdentifier: type.id) as! T
    }
}

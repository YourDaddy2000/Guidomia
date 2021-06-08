//
//  MainVCHeaderView.swift
//  Guidomia_MVP
//
//  Created by Roman Bozhenko on 04.06.2021.
//

import UIKit

final class MainVCHeaderView: UITableViewHeaderFooterView {
    @IBOutlet private weak var carImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    func configure(with model: (imageName: String, titleText: String, subtitleText: String)) {
        carImageView.image = UIImage(named: model.imageName)
        titleLabel.text = model.titleText
        subtitleLabel.text = model.subtitleText
    }
}

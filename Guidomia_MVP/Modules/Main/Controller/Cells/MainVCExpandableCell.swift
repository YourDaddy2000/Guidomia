//
//  MainVCExpandableCell.swift
//  Guidomia_MVP
//
//  Created by Roman Bozhenko on 04.06.2021.
//

import UIKit

class MainVCExpandableCell: UITableViewCell {
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bottomSpacerView: UIView!
    @IBOutlet weak var starsStackView: UIStackView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bottomSpacerView.isHidden = false
        starsStackView.subviews.forEach {
            $0.alpha = 0
        }
    }
    
    func configure(with item: CarModel, isLast: Bool) {
        bottomSpacerView.isHidden = isLast
        
        carImageView.image = UIImage(named: item.imageName)
        priceLabel.text = "Price : \(item.customerPrice.kFormatted)"
        titleLabel.text = item.make + " " + item.model
        
        setRating(item.rating)
    }
    
    private func setRating(_ rating: Int) {
        for i in 0..<rating {
            starsStackView.subviews[i].alpha = 1
        }
    }
}

//
//  MainVCExpandableCell.swift
//  Guidomia_MVP
//
//  Created by Roman Bozhenko on 04.06.2021.
//

import UIKit

class MainVCExpandableCell: UITableViewCell {
    @IBOutlet private weak var carImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var bottomSpacerView: UIView!
    @IBOutlet private weak var starsStackView: UIStackView!
    @IBOutlet private(set) weak var prosStackView: UIStackView!
    @IBOutlet private(set) weak var consStackView: UIStackView!
    @IBOutlet private weak var prosStackViewContainer: UIStackView!
    @IBOutlet private weak var constStackViewContainer: UIStackView!
    
    //MARK: Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        set(alpha: 0, for: starsStackView.arrangedSubviews)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bottomSpacerView.isHidden = false
        prosStackView.removeArrangedSubviews()
        consStackView.removeArrangedSubviews()
        expandProsAndCons(false)
        set(alpha: 0, for: starsStackView.arrangedSubviews)
    }
    
    //MARK: Public Methods
    func configure(with item: CarModel, isLast: Bool) {
        bottomSpacerView.isHidden = isLast
        
        carImageView.image = UIImage(named: item.imageName)
        priceLabel.text = "Price : \(item.customerPrice.kFormatted)"
        titleLabel.text = item.make + " " + item.model
        
        setRating(item.rating)
    }
    
    func expandProsAndCons(_ isExpanded: Bool) {
        hide(!isExpanded, views: [prosStackViewContainer,
                                  constStackViewContainer,
        ])
    }
    
    //MARK: Private Methods
    private func setRating(_ rating: Int) {
        for i in 0..<rating {
            starsStackView.subviews[i].alpha = 1
        }
    }
}

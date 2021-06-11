//
//  MainVCExpandableCell.swift
//  Guidomia
//
//  Created by Roman Bozhenko on 04.06.2021.
//

import UIKit

final class MainVCExpandableCell: UITableViewCell {
    @IBOutlet private weak var carImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var bottomSpacerView: UIView!
    @IBOutlet private weak var starsStackView: UIStackView!
    @IBOutlet private weak var prosStackView: UIStackView!
    @IBOutlet private weak var consStackView: UIStackView!
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
    func configure(with item: CarModel, isLast: Bool, expandProAndCons shouldExpand: Bool) {
        bottomSpacerView.isHidden = isLast
        
        carImageView.image = UIImage(named: item.imageName)
        priceLabel.text = "price".localized + item.customerPrice.kFormatted
        titleLabel.text = item.make + " " + item.model
        
        setRating(item.rating)
        expandProsAndCons(shouldExpand)
        fillProsStackView(with: item.prosList)
        fillConsStackView(with: item.consList)
    }
}

//MARK: Private Methods Extension
private extension MainVCExpandableCell {
    
    func expandProsAndCons(_ isExpanded: Bool) {
        hide(!isExpanded, views: [prosStackViewContainer,
                                  constStackViewContainer,
        ])
    }
    
    func fillProsStackView(with items: [String]) {
        stackView(prosStackView, fillWith: items)
    }
    
    func fillConsStackView(with items: [String]) {
        stackView(consStackView, fillWith: items)
    }
    
    func stackView(_ stackView: UIStackView, fillWith items: [String]) {
        items.forEach {
            guard !$0.isEmpty else { return }
            let label = getDotLabelForProsAndConsStackView()
            label.text = $0
            setHeight(of: label, stackViewWidth: stackView.bounds.width)
            stackView.addArrangedSubview(label)
        }
    }
    
    func setHeight(of label: DotLabel, stackViewWidth: CGFloat) {
        guard stackViewWidth > .zero else { return }
        label.sizeToFit()
        var labelHeight = label.bounds.height
        
        if label.frame.width > stackViewWidth {
            var sizeDiff = Int(label.frame.width / stackViewWidth)
            let height = labelHeight
            
            while sizeDiff > .zero {
                labelHeight += height
                sizeDiff -= 1
            }
        }
        
        label.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
    }
    
    func getDotLabelForProsAndConsStackView() -> DotLabel {
        let label = DotLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = .zero
        
        return label
    }
    
    func setRating(_ rating: Int) {
        for i in 0..<rating {
            starsStackView.subviews[i].alpha = 1
        }
    }
}

//
//  FilterTableViewCell.swift
//  Guidomia_MVP
//
//  Created by Roman Bozhenko on 06.06.2021.
//

import UIKit

final class FilterTableViewCell: UITableViewCell {
    @IBOutlet private(set) weak var makeButton: UIButton!
    @IBOutlet private(set) weak var modelButton: UIButton!
    @IBOutlet private(set) weak var makePickerView: UIPickerView!
    @IBOutlet private(set) weak var modelPickerView: UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
    }
    
    private func reset() {
        makePickerView.isHidden = true
        modelPickerView.isHidden = true
    }
    
    var makePickerViewAction: (() -> Void)!
    var modelPickerViewAction: (() -> Void)!

    @IBAction private func didTapMakeButton (_ sender: UIButton?) {
        makePickerViewAction?()
    }
    
    @IBAction private func didTapModelButton (_ sender: UIButton?) {
        modelPickerViewAction?()
    }
}

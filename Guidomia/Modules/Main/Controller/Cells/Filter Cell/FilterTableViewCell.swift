//
//  FilterTableViewCell.swift
//  Guidomia
//
//  Created by Roman Bozhenko on 06.06.2021.
//

import UIKit

final class FilterTableViewCell: UITableViewCell {
    @IBOutlet private weak var makeButton: UIButton!
    @IBOutlet private weak var modelButton: UIButton!
    @IBOutlet private weak var makePickerView: UIPickerView!
    @IBOutlet private weak var modelPickerView: UIPickerView!
    @IBOutlet private weak var makeApplyFilterButton: UIButton!
    @IBOutlet private weak var modelApplyFilterButton: UIButton!
    
    var makePickerViewAction: ((_ makePV: UIPickerView) -> Void)!
    var modelPickerViewAction: (() -> Void)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
    }
    
    //MARK: Public
    func setPickerViewDelegate(delegate: UIPickerViewDelegate & UIPickerViewDataSource) {
        makePickerView.delegate = delegate
        modelPickerView.delegate = delegate
        makePickerView.dataSource = delegate
        modelPickerView.dataSource = delegate
    }
    
    func setMakeButtonTitle(_ title: String?) {
        button(makeButton, setTitle: title)
    }
    
    func setModelButtonTitle(_ title: String?) {
        button(modelButton, setTitle: title)
    }
    
    func resetMakeButtonName() {
        button(makeButton, setTitle: "any_make".localized)
    }
    
    func toggleMakePickerViewIsHidden() {
        makePickerView.isHidden.toggle()
        makeApplyFilterButton.isHidden.toggle()
    }
    
    func toggleModelPickerViewIsHidden() {
        modelPickerView.reloadAllComponents()
        modelPickerView.isHidden.toggle()
        modelApplyFilterButton.isHidden.toggle()
    }
    
    func hideMakePickerView() {
        makePickerView.isHidden = true
        makeApplyFilterButton.isHidden = true
    }
    
    func hideModelPickerView() {
        modelPickerView.isHidden = true
        modelApplyFilterButton.isHidden = true
    }
    
    func resetModelButtonName() {
        button(modelButton, setTitle: "any_model".localized)
    }
    
    func selectModelPickerViewEmptyRow() {
        modelPickerView.selectRow(0, inComponent: 0, animated: false)
    }
    
    @IBAction func didTapMakeButton (_ sender: UIButton? = nil) {
        makePickerViewAction?(makePickerView)
    }
    
    @IBAction func didTapModelButton (_ sender: UIButton? = nil) {
        modelPickerViewAction?()
    }
    
    //MARK: Private
    private func button(_ button: UIButton, setTitle title: String?) {
        button.setTitle(title, for: .normal)
    }
    
    private func reset() {
        resetMakeButtonName()
        resetModelButtonName()
        makePickerView.isHidden = true
        modelPickerView.isHidden = true
        makeApplyFilterButton.isHidden = true
        modelApplyFilterButton.isHidden = true
    }
}

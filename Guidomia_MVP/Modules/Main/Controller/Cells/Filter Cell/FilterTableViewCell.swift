//
//  FilterTableViewCell.swift
//  Guidomia_MVP
//
//  Created by Roman Bozhenko on 06.06.2021.
//

private let makeString: String = "Make"
private let modelString: String = "Model"
private let anyString: String = "Any "

import UIKit

final class FilterTableViewCell: UITableViewCell {
    @IBOutlet private weak var makeButton: UIButton!
    @IBOutlet private weak var modelButton: UIButton!
    @IBOutlet private weak var makePickerView: UIPickerView!
    @IBOutlet private weak var modelPickerView: UIPickerView!
    
    var makePickerViewAction: ((_ makePV: UIPickerView, UIPickerView) -> Void)!
    var modelPickerViewAction: ((_ makePV: UIPickerView, UIPickerView) -> Void)!
    
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
        button(makeButton, setTitle: title)
    }
    
    func resetMakeButtonName() {
        button(makeButton, setTitle: anyString + makeString)
    }
    
    func resetModelButtonName() {
        button(modelButton, setTitle: anyString + modelString)
    }
    
    func selectModelPickerViewEmptyRow() {
        modelPickerView.selectRow(0, inComponent: 0, animated: false)
    }
    
    @IBAction func didTapMakeButton (_ sender: UIButton? = nil) {
        makePickerViewAction?(makePickerView, modelPickerView)
    }
    
    @IBAction func didTapModelButton (_ sender: UIButton? = nil) {
        modelPickerViewAction?(makePickerView, modelPickerView)
    }
    
    //MARK: Private
    private func button(_ button: UIButton, setTitle title: String?) {
        button.setTitle(title, for: .normal)
    }
    
    private func reset() {
        makePickerView.isHidden = true
        modelPickerView.isHidden = true
    }
}

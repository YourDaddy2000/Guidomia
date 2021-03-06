//
//  MainViewController.swift
//  Guidomia
//
//  Created by Roman Bozhenko on 04.06.2021.
//

import UIKit

protocol MainPresenterOutputProtocol: BaseViewControllerProtocol {
    func updateCars(
        _ cars: [CarModel],
        _ offers: [(make: String, model: String)])
    func updateHeader(_ header: MainHeaderModel)
}

final class MainViewController: BaseViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private var tvItems = CombinedMainModel()
    private var expandedCellIndex: Int = 0
    private var selectedMake: String = ""
    private var selectedModel: String = ""
    private var modelsArray: [String]? {
        tvItems.pickerItems[selectedMake]
    }
    private var makesArray: [String] {
        Array(tvItems.pickerItems.keys)
    }
    
    var presenter: MainPresenterProtocol!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        configureTableView()
    }
}

//MARK: - Private Methods Extension
private extension MainViewController {
    func configureTableView() {
        tableView.register(MainVCHeaderView.self)
        tableView.register([MainVCExpandableCell.self,
                            FilterTableViewCell.self])
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 143
    }
}

// MARK: - Presenter output protocol implementation
extension MainViewController: MainPresenterOutputProtocol {
    func updateCars(
        _ cars: [CarModel],
        _ offers: [(make: String, model: String)]) {
        if tvItems.cars != cars {
            tvItems.cars = cars
            tvItems.pickerItems = presenter.convertOffersIntoPickerItems(
                currentPickerItems: tvItems.pickerItems,
                offers: offers)
            
            tableView.reloadData()
        }
    }
    
    func updateHeader(_ header: MainHeaderModel) {
        if tvItems.header != header {
            tvItems.header = header
            tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource & UITableViewDelegate extension
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0, let header = tvItems.header else { return nil }
        let view = tableView.dequeue(MainVCHeaderView.self)
        
        view.configure(with: (
                        imageName: header.backgroundImageName,
                        titleText: header.title,
                        subtitleText: header.subtitle)
        )
        
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tvItems.header == nil || section != 0 ? .zero : tableView.bounds.width / 1.5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : tvItems.cars.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item != expandedCellIndex {
            expandedCellIndex = indexPath.item
            
            UIView.transition(
                with: tableView,
                duration: 0.15,
                options: [.transitionCrossDissolve],
                animations: {
                    tableView.reloadData()
                }
            )
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == .zero {
            return getFilterCell(for: indexPath)
        }
        
        return getMainVCExpandableCell(for: IndexPath(
                                        item: indexPath.item,
                                        section: .zero))
    }
}

//MARK: - TableView Helper Methods
private extension MainViewController {
    func getFilterCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(FilterTableViewCell.self)
        
        cell.makePickerViewAction = { [weak self] makePV in
            self?.applyFilter(
                forMakePickerView: makePV,
                selectedMake: self!.selectedMake)
            
            self?.resetSelectedModel()
            self?.tableView.performBatchUpdates({
                cell.toggleMakePickerViewIsHidden()
                cell.hideModelPickerView()
            })
        }
        
        cell.modelPickerViewAction = { [weak self, unowned cell] in
            guard let self = self,
                  !self.selectedMake.isEmpty else {
                return cell.didTapMakeButton()
            }
            self.expandedCellIndex = 0
            self.presenter.filter(make: self.selectedMake)
            self.presenter.filter(
                modelName: self.selectedModel,
                cars: self.tvItems.cars)
            
            self.tableView?.performBatchUpdates({
                cell.toggleModelPickerViewIsHidden()
                cell.hideMakePickerView()
            })
        }
        
        cell.setPickerViewDelegate(delegate: self)
        
        return cell
    }
    
    func getMainVCExpandableCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(MainVCExpandableCell.self)
        let items = tvItems.cars
        let isLast = indexPath.item == items.count - 1
        let shouldExpand = indexPath.item == expandedCellIndex
        
        cell.configure(
            with: items[indexPath.item],
            isLast: isLast,
            expandProAndCons: shouldExpand)
        
        return cell
    }
}

private extension UIPickerView {
    var isModelPickerView: Bool { tag == 1 } // tag is set in .xib
}

//MARK: - UIPickerViewDelegate & UIPickerViewDataSource extension
extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (items(for: pickerView)?.count ?? 0) + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row > 0 {
            return items(for: pickerView)?[row - 1]
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let cell = tableView.visibleCells.first(where: { $0 is FilterTableViewCell }) as? FilterTableViewCell else { return }
        
        if row == 0 {
            if pickerView.isModelPickerView {
                return cell.resetModelButtonName()
            }
            
            cell.resetModelButtonName()
            cell.resetMakeButtonName()
            resetSelectedMake()
            return
        }
        
        let row = row - 1
        
        if pickerView.isModelPickerView {
            let models = items(for: pickerView)
            selectedModel = models?[row] ?? ""
            cell.setModelButtonTitle(models?[row])
            return
        }
        
        setSelectedMake(row)
        cell.resetModelButtonName()
        cell.selectModelPickerViewEmptyRow()
        cell.setMakeButtonTitle(selectedMake)
    }
}

//MARK: - PickerView Helper Methods
private extension MainViewController {
    func applyFilter(forMakePickerView pickerView: UIPickerView, selectedMake: String) {
        if !pickerView.isHidden {
            expandedCellIndex = 0
            presenter.filter(make: selectedMake)
        }
    }
    
    func items(for pickerView: UIPickerView) -> [String]? {
        pickerView.isModelPickerView ? modelsArray : makesArray
    }
    
    func setSelectedMake(_ index: Int) {
        let make = makesArray[index]
        
        if selectedMake != make {
            selectedMake = make
        }
    }
    
    func resetSelectedMake() {
        selectedMake = ""
    }
    
    func resetSelectedModel() {
        selectedModel = ""
    }
}

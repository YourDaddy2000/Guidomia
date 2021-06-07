//
//  MainViewController.swift
//  Guidomia_MVP
//
//  Created by Roman Bozhenko on 04.06.2021.
//

import UIKit

private let headerId = String(describing: MainVCHeaderView.self)
private let expandableCellId = String(describing: MainVCExpandableCell.self)
private let filterCellId = String(describing: FilterTableViewCell.self)
private let makePickerViewTag = 0
private let modelPickerViewTag = 1
private let makeString: String = "Make"
private let modelString: String = "Model"
private let anyString: String = "Any "

protocol MainPresenterOutputProtocol: BaseViewControllerProtocol {
    func reloadTableView()
}

final class MainViewController: BaseViewController {
    @IBOutlet private weak var tableView: UITableView!
    
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
        let cellNib = UINib(nibName: expandableCellId, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: expandableCellId)
        
        let filtercellNib = UINib(nibName: filterCellId, bundle: nil)
        tableView.register(filtercellNib, forCellReuseIdentifier: filterCellId)
        
        let headerNib = UINib(nibName: headerId, bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: headerId)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 143
    }
}

// MARK: - Presenter output protocol implementation
extension MainViewController: MainPresenterOutputProtocol {
    func reloadTableView() {
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = presenter.tableViewItems.header else { return nil }
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId)  as! MainVCHeaderView
        
        view.carImageView.image = UIImage(named: header.backgroundImageName)
        view.titleLabel.text = header.title
        view.subtitleLabel.text = header.subtitle

        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return presenter.tableViewItems.header == nil ? .zero : 250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.tableViewItems.cars.count + presenter.amountOfNonExpandableCells
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.item - presenter.amountOfNonExpandableCells != presenter.expandedCellIndex else { return }
        presenter.expandedCellIndex = indexPath.item - presenter.amountOfNonExpandableCells
        
        tableView.performBatchUpdates { [weak tableView] in
            tableView?.visibleCells.forEach {
                ($0 as? MainVCExpandableCell)?.expandProsAndCons(false)
            }
            
            if let cell = tableView?.dequeueReusableCell(
                withIdentifier: expandableCellId,
                for: indexPath) as? MainVCExpandableCell {
                cell.expandProsAndCons(true)
                tableView?.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == .zero {
            return getFilterCell(for: indexPath)
        }
        
        return getMainVCExpandableCell(for: IndexPath(
                                        item: indexPath.item - presenter.amountOfNonExpandableCells,
                                        section: .zero))
    }
    
    private func getFilterCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: filterCellId, for: indexPath) as! FilterTableViewCell
        cell.makePickerView.tag = makePickerViewTag
        cell.modelPickerView.tag = modelPickerViewTag
        
        cell.makePickerViewAction = { [weak self, unowned cell] in
            guard let self = self else { return }
            self.applyFilter(for: cell.makePickerView)
            
            self.tableView.performBatchUpdates({
                cell.makePickerView.isHidden.toggle()
                cell.modelPickerView.isHidden = true
            })
        }
        
        cell.modelPickerViewAction = { [weak self, unowned cell] in
            guard let self = self,
                  !self.presenter.selectedMake.isEmpty else {
                cell.makePickerViewAction?()
                return
            }
            
            self.applyFilter(for: cell.makePickerView)
            
            self.tableView?.performBatchUpdates({
                cell.modelPickerView.reloadAllComponents()
                cell.modelPickerView.isHidden.toggle()
                cell.makePickerView.isHidden = true
            })
        }
        
        cell.makePickerView.delegate = self
        cell.modelPickerView.delegate = self
        cell.makePickerView.dataSource = self
        cell.modelPickerView.dataSource = self
        
        return cell
    }
    
    private func applyFilter(for pickerView: UIPickerView) {
        if !pickerView.isHidden {
            presenter.filter(make: presenter.selectedMake)
        }
    }
    
    private func getMainVCExpandableCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: expandableCellId, for: indexPath) as! MainVCExpandableCell
        let items = presenter.tableViewItems.cars
        let isLast = indexPath.item == items.count - presenter.amountOfNonExpandableCells
        let shouldExpand = indexPath.item == presenter.expandedCellIndex
        
        presenter.setProsAndConsStackViewWidth(cell.prosStackView.bounds.width)
        cell.configure(with: items[indexPath.item], isLast: isLast)
        cell.expandProsAndCons(shouldExpand)
        
        let prosAndCons = presenter.tableViewItems.prosAndCons[indexPath.item]
        presenter.cell(
            fill: cell.prosStackView,
            stackViewWidth: presenter.prosAndConsStackViewWidth,
            with: prosAndCons.pros)
        presenter.cell(
            fill: cell.consStackView,
            stackViewWidth: presenter.prosAndConsStackViewWidth,
            with: prosAndCons.cons)
        
        return cell
    }
}

private extension UIPickerView {
    var isModelPickerView: Bool { tag == modelPickerViewTag }
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
                return resetModelButtonName(of: cell)
            }
            
            resetMakeButtonName(of: cell)
            resetSelectedMake()
            return
        }
        
        let row = row - 1
        
        if pickerView.isModelPickerView {
            return button(
                cell.modelButton,
                setTitle: items(for: pickerView)?[row])
        }
        
        setSelectedMake(row)
        resetModelButtonName(of: cell)
        selectEmptyRow(in: cell.modelPickerView)
        button(cell.makeButton, setTitle: presenter.selectedMake)
    }
    
    private func items(for pickerView: UIPickerView) -> [String]? {
        pickerView.isModelPickerView ? presenter.modelsArray : presenter.makesArray
    }
    
    private func setSelectedMake(_ index: Int) {
        let make = presenter.makesArray[index]
        
        if presenter.selectedMake != make {
            presenter.selectedMake = make
        }
    }
    
    private func resetSelectedMake() {
        presenter.selectedMake = ""
    }
    
    private func selectEmptyRow(in pickerView: UIPickerView) {
        pickerView.selectRow(0, inComponent: 0, animated: false)
    }
    
    private func resetMakeButtonName(of cell: FilterTableViewCell) {
        button(cell.makeButton, setTitle: anyString + makeString)
    }
    
    private func resetModelButtonName(of cell: FilterTableViewCell) {
        button(cell.modelButton, setTitle: anyString + modelString)
    }
    
    private func button(_ button: UIButton, setTitle title: String?) {
        button.setTitle(title, for: .normal)
    }
}

//MARK: - MainPresenterProtocol helping methods extension
private extension MainPresenterProtocol {
    var modelsArray: [String]? {
        tableViewItems.pickerItems[selectedMake]
    }
    
    var makesArray: [String] {
        Array(tableViewItems.pickerItems.keys)
    }
    
    func setProsAndConsStackViewWidth(_ width: CGFloat) {
        if prosAndConsStackViewWidth.isZero {
            prosAndConsStackViewWidth = Double(width)
        }
    }
    
    func cell(fill stackView: UIStackView, stackViewWidth width: Double, with strings: [String]) {
        strings.forEach {
            guard !$0.isEmpty else { return }
            let label = getDotLabelForProsAndConsStackView()
            label.text = $0
            setHeight(of: label, stackViewWidth: CGFloat(width))
            stackView.addArrangedSubview(label)
        }
    }
    
    func getDotLabelForProsAndConsStackView() -> DotLabel {
        let label = DotLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = .zero
        
        return label
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
}

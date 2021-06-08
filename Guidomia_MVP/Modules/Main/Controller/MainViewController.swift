//
//  MainViewController.swift
//  Guidomia_MVP
//
//  Created by Roman Bozhenko on 04.06.2021.
//

import UIKit

private let makePickerViewTag = 0
private let modelPickerViewTag = 1
private let makeString: String = "Make"
private let modelString: String = "Model"
private let anyString: String = "Any "

protocol MainPresenterOutputProtocol: BaseViewControllerProtocol {
    func updateCars(_ cars: [CarModel]?)
    func updateHeader(_ header: MainHeaderModel?)
}

final class MainViewController: BaseViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private var tvItems = CombinedMainModel()
    private var prosAndConsStackViewWidth: Double = 0
    private var amountOfNonExpandableCells: Int = 1
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
    func updateCars(_ cars: [CarModel]?) {
        if let models = cars,
           tvItems.cars != models {
            tvItems.cars = models
            tvItems.prosAndCons = models.map { ($0.prosList, $0.consList) }
            
            let offers: [(make: String, model: String)] = models.map { ($0.make, $0.model) }
            
            
            offers.forEach {
                if tvItems.pickerItems[$0.make] == nil {
                    tvItems.pickerItems[$0.make] = []
                }
                
                if !tvItems.pickerItems[$0.make]!.contains($0.model) {
                    tvItems.pickerItems[$0.make]?.append($0.model)
                }
            }
            
            tableView.reloadData()
        }
    }
    
    func updateHeader(_ header: MainHeaderModel?) {
        if let header = header, tvItems.header != header {
            tvItems.header = header
            tableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tvItems.header else { return nil }
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: MainVCHeaderView.id)  as! MainVCHeaderView
        
        view.carImageView.image = UIImage(named: header.backgroundImageName)
        view.titleLabel.text = header.title
        view.subtitleLabel.text = header.subtitle

        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tvItems.header == nil ? .zero : tableView.bounds.width / 1.5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvItems.cars.count + amountOfNonExpandableCells
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.item - amountOfNonExpandableCells != expandedCellIndex,
              indexPath.item != 0 else { return }
        expandedCellIndex = indexPath.item - amountOfNonExpandableCells
        
        tableView.performBatchUpdates { [weak tableView] in
            tableView?.visibleCells.forEach {
                ($0 as? MainVCExpandableCell)?.expandProsAndCons(false)
            }
            
            if let cell = tableView?.dequeueReusableCell(
                withIdentifier: MainVCExpandableCell.id,
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
                                        item: indexPath.item - amountOfNonExpandableCells,
                                        section: .zero))
    }
}

//MARK: - TableView Helper Methods
private extension MainViewController {
    func getFilterCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.id, for: indexPath) as! FilterTableViewCell
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
                  !self.selectedMake.isEmpty else {
                cell.makePickerViewAction?()
                return
            }
            
            self.expandedCellIndex = 0
            self.applyFilter(for: cell.makePickerView)
            self.presenter.filter(
                make: self.selectedMake,
                model: self.selectedModel,
                cars: self.tvItems.cars)
            
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
    
    func getMainVCExpandableCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainVCExpandableCell.id, for: indexPath) as! MainVCExpandableCell
        let items = tvItems.cars
        let isLast = indexPath.item == items.count - amountOfNonExpandableCells
        let shouldExpand = indexPath.item == expandedCellIndex
        
        self.setProsAndConsStackViewWidth(cell.prosStackView.bounds.width)
        cell.configure(with: items[indexPath.item], isLast: isLast)
        cell.expandProsAndCons(shouldExpand)
        
        let prosAndCons = tvItems.prosAndCons[indexPath.item]
        self.cell(
            fill: cell.prosStackView,
            stackViewWidth: prosAndConsStackViewWidth,
            with: prosAndCons.pros)
        self.cell(
            fill: cell.consStackView,
            stackViewWidth: prosAndConsStackViewWidth,
            with: prosAndCons.cons)
        
        return cell
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
            
            resetModelButtonName(of: cell)
            resetMakeButtonName(of: cell)
            resetSelectedMake()
            return
        }
        
        let row = row - 1
        
        if pickerView.isModelPickerView {
            let models = items(for: pickerView)
            selectedModel = models?[row] ?? ""
            button( cell.modelButton, setTitle: models?[row])
            return
        }
        
        setSelectedMake(row)
        resetModelButtonName(of: cell)
        selectEmptyRow(in: cell.modelPickerView)
        button(cell.makeButton, setTitle: selectedMake)
    }
}

//MARK: - PickerView Helper Methods
private extension MainViewController {
    func applyFilter(for pickerView: UIPickerView) {
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
    
    func selectEmptyRow(in pickerView: UIPickerView) {
        pickerView.selectRow(0, inComponent: 0, animated: false)
    }
    
    func resetMakeButtonName(of cell: FilterTableViewCell) {
        button(cell.makeButton, setTitle: anyString + makeString)
    }
    
    func resetModelButtonName(of cell: FilterTableViewCell) {
        resetSelectedModel()
        button(cell.modelButton, setTitle: anyString + modelString)
    }
    
    func resetSelectedModel() {
        selectedModel = ""
    }
    
    func button(_ button: UIButton, setTitle title: String?) {
        button.setTitle(title, for: .normal)
    }
}

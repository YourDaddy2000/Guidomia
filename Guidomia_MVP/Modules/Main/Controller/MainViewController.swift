//
//  MainViewController.swift
//  Guidomia_MVP
//
//  Created by Roman Bozhenko on 04.06.2021.
//

import UIKit

private let headerId = String(describing: MainVCHeaderView.self)
private let expandableCellId = String(describing: MainVCExpandableCell.self)

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
        return presenter.tableViewItems.header == nil ? 0 : 250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.tableViewItems.cars.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.item != presenter.expandedCellIndex else { return }
        presenter.expandedCellIndex = indexPath.item
        
        tableView.performBatchUpdates {
            tableView.visibleCells.forEach {
                ($0 as! MainVCExpandableCell).expandProsAndCons(false)
            }
            let cell = tableView.dequeueReusableCell(
                withIdentifier: expandableCellId,
                for: indexPath) as! MainVCExpandableCell
            
            cell.expandProsAndCons(true)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: expandableCellId, for: indexPath) as! MainVCExpandableCell
        let items = presenter.tableViewItems.cars
        let isLast = indexPath.item == items.count-1
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

//MARK: MainPresenterProtocol helping methods extension
private extension MainPresenterProtocol {
    func setProsAndConsStackViewWidth(_ width: CGFloat) {
        if prosAndConsStackViewWidth == 0 {
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
        label.numberOfLines = 0
        
        return label
    }
    
    func setHeight(of label: DotLabel, stackViewWidth: CGFloat) {
        guard stackViewWidth > 0 else { return }
        label.sizeToFit()
        var labelHeight = label.bounds.height
        
        if label.frame.width > stackViewWidth {
            var sizeDiff = Int(label.frame.width / stackViewWidth)
            let height = labelHeight
            
            while sizeDiff > 0 {
                labelHeight += height
                sizeDiff -= 1
            }
        }
        
        label.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
    }
}

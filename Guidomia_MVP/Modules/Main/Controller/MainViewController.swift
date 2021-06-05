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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.tableViewItems.cars.count-1 == indexPath.item ? 113 : 143
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.tableViewItems.cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: expandableCellId, for: indexPath) as! MainVCExpandableCell
        let item = presenter.tableViewItems.cars[indexPath.row]
        cell.bottomSpacerView.isHidden = indexPath.item == presenter.tableViewItems.cars.count-1
        
        cell.carImageView.image = UIImage(named: item.imageName)
        cell.priceLabel.text = "Price : \(item.customerPrice.kFormatted)"
        cell.titleLabel.text = item.make + " " + item.model
        
        return cell
    }
}

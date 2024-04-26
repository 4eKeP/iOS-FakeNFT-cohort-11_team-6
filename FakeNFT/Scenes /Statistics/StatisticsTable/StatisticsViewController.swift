//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 05.04.2024.
//

import UIKit
import SnapKit

protocol StatisticsView: AnyObject, ErrorView {
    func updateData(with: [UserDetailed])
}

final class StatisticsViewController: UIViewController, ErrorView {
    
    private let presenter: StatisticsPresenter
    
    enum Section {
        case main
    }
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, UserDetailed> = {
        UITableViewDiffableDataSource<Section, UserDetailed>(
            tableView: tableView,
            cellProvider: {[weak self] (tableView, indexPath, user) -> UITableViewCell? in
                
                guard let self else { return UITableViewCell()}
                let cell: StatisticsTableViewCell = tableView.dequeueReusableCell()
                cell.set(user: user)
                cell.selectionStyle = .none
                return cell
            })
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(StatisticsTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var sortButton: UIBarButtonItem = {
        let sortButton = UIBarButtonItem(title: "",
                                         style: .plain,
                                         target: self,
                                         action: #selector(sortButtonPressed))
        sortButton.image = UIImage(resource: .sort)
        return sortButton
    }()
    
    init(presenter: StatisticsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        layoutUI()
        presenter.viewDidLoad()
    }
    
    
    private func configureNavBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func layoutUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func sortButtonPressed() {
        let alert = SortAlertController { [weak self] in
            guard let self else { return }
            presenter.nameSortActionTapped()
        } ratingSortHandler: { [weak self]  in
            guard let self else { return }
            presenter.ratingSortActionTapped()
        }
        
        present(alert, animated: true)
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter.tableSelected(atRow: indexPath.row)
    }
}

extension StatisticsViewController: StatisticsView {
    func updateData(with users: [UserDetailed]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UserDetailed>()
        snapshot.appendSections([.main])
        snapshot.appendItems(users)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}


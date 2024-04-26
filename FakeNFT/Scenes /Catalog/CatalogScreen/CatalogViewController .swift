//
//  CatalogViewController .swift
//  FakeNFT
//
//  Created by admin on 24.03.2024.
//

import UIKit
import Kingfisher
import ProgressHUD

protocol CatalogViewControllerProtocol: UIViewController, AnyObject, ErrorView {
    func reloadTableView()
}

final class CatalogViewController: UIViewController, CatalogViewControllerProtocol {
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(loadNftToCatalog),
                                 for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: Asset.CatalogImages.filterIcon.image,
                                     style: .plain,
                                     target: self,
                                     action: #selector(showSortingMenu))
        return button
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.register(CatalogViewCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Asset.Colors.ypWhite.color
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private let presenter: CatalogPresenterProtocol
    
    private let tableViewTopSpacing: CGFloat = 20
    private let tableViewSideSpacing: CGFloat = 16
    private let cellHeight: CGFloat = 187
    
    init(presenter: CatalogPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadNftToCatalog()
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            ProgressHUD.dismiss()
        }
    }
    
    //MARK: - @objc func
    
    @objc func showSortingMenu() {
        let alerts = [
            AlertModel(title: L10n.Catalog.sortByName, style: .default, completion: {
                [weak self] in
                    self?.presenter.sortNFT(by: .name)
                    self?.reloadTableView()
            }),
            AlertModel(title: L10n.Catalog.sortByNFTCount, style: .default, completion: {
                [weak self] in
                    self?.presenter.sortNFT(by: .nftCount)
                    self?.reloadTableView()
            }),
            AlertModel(title: L10n.Catalog.close, style: .cancel, completion: nil)
        ]
        presenter.showAlertController(alerts: alerts)
    }
    
    @objc func loadNftToCatalog() {
        ProgressHUD.show()
        presenter.fetchCollections()
    }
    
}
//MARK: - UITableViewDataSource

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CatalogViewCell = tableView.dequeueReusableCell()
        cell.selectionStyle = .none
        let nftModel = presenter.dataSource[indexPath.row]
        let url = URL(string: nftModel.cover.encodeUrl)
        return cell.makeCell(nftCatalogModel: nftModel, coverURL: url)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }
}
//MARK: - UITableViewDelegate

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = CollectionScreenAssembler().setupCollectionScreen(catalogModel: presenter.dataSource[indexPath.row])
        navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK: - ConfigUI

private extension CatalogViewController {
    
    func setupUI() {
        configNavBar()
        configUI()
    }
    
    func configNavBar() {
        sortButton.tintColor = Asset.Colors.ypBlack.color
        navigationController?.navigationBar.tintColor = Asset.Colors.ypWhite.color
        navigationItem.rightBarButtonItem = sortButton
    }
    
    func configUI() {
        view.backgroundColor = Asset.Colors.ypWhite.color
        view.addSubview(tableView)
        tableView.refreshControl = refreshControl
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: tableViewSideSpacing),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -tableViewSideSpacing),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

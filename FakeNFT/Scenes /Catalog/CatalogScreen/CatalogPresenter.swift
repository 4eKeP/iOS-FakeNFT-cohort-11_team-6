//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by admin on 24.03.2024.
//

import UIKit

protocol CatalogPresenterProtocol: AnyObject {
    var dataSource: [NFTCatalogModel] { get }
    var viewController: CatalogViewControllerProtocol? { get set }
    func fetchCollections()
    func sortNFT(by parameters: NFTCatalogSortingParameters)
    func showAlertController(alerts: [AlertModel])
}

final class CatalogPresenter: CatalogPresenterProtocol {
    
    weak var viewController: CatalogViewControllerProtocol?
    private var dataProvider: CatalogDataProviderProtocol
    
    var dataSource: [NFTCatalogModel] {
        dataProvider.NFTCollections
    }
    
    init(dataProvider: CatalogDataProviderProtocol) {
        self.dataProvider = dataProvider
    }
    
    func fetchCollections() {
        dataProvider.fetchNFTCollection { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.viewController?.reloadTableView()
            case .failure(let error):
                let errorModel = self.makeErrorModel(error)
                viewController?.showError(errorModel)
            }
        }
    }
    
    func sortNFT(by parameters: NFTCatalogSortingParameters) {
        dataProvider.sortNFTCollections(by: parameters)
    }
    
    private func makeErrorModel(_ error: Error) -> ErrorModel {
        return ErrorModel { [weak self] in
            self?.fetchCollections()
        }
    }
    
    func showAlertController(alerts: [AlertModel]) {
        let alertController = UIAlertController(
            title: L10n.Catalog.sorting,
            message: nil,
            preferredStyle: .actionSheet)

        for alert in alerts {
            let action = UIAlertAction(title: alert.title, style: alert.style) { _ in
                if let completion = alert.completion {
                    completion()
                }
            }
            alertController.addAction(action)
        }
        guard let viewController = viewController else { return }
        viewController.present(alertController, animated: true)
    }
}


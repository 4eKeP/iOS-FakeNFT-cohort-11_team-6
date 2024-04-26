//
//  ControllersFactory.swift
//  FakeNFT
//
//  Created by admin on 26.03.2024.
//

import UIKit

enum ControllersType {
    case catalogViewController
}

final class ControllersFactory {
    
    func setupController(of type: ControllersType) -> UINavigationController {
        switch type {
        case .catalogViewController:
            let dataProvider = CatalogDataProvider(networkClient: DefaultNetworkClient())
            let catalogPresenter = CatalogPresenter(dataProvider: dataProvider)
            let catalogController = CatalogViewController(presenter: catalogPresenter)
            catalogPresenter.viewController = catalogController
            let catalogNavigationItem = createNavigation(with: L10n.Tab.catalog,
                                                     and: UIImage(systemName: "rectangle.stack.fill"),
                                                     vc: catalogController)
            return catalogNavigationItem
        }
    }
    
    func setupTabBarController() -> UIViewController {
        let servicesAssembly = ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl())
        let tabBarController = TabBarController(controllersFactory: self, servicesAssembly: servicesAssembly)
        
        return tabBarController
    }
    
    private func createNavigation(with title: String,
                                  and image: UIImage?,
                                  vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.prefersLargeTitles = true
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image

        return nav
    }
}

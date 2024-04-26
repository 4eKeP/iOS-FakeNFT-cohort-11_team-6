//
//  CollectionScreenAssembler.swift
//  FakeNFT
//
//  Created by admin on 08.04.2024.
//

import Foundation

final class CollectionScreenAssembler {
    func setupCollectionScreen(catalogModel model: NFTCatalogModel) -> CollectionViewController {
        let networkClient = DefaultNetworkClient()
        let nftStorage = NftStorageImpl()
        let nftService = NftServiceImpl(networkClient: networkClient, storage: nftStorage)
        let profileService = ProfileServiceImpl(networkClient: networkClient)
        let cartService = CartServiceImpl(networkClient: networkClient)
        let collectionPresenter = CollectionViewControllerPresenter(nftCatalogModel: model,
                                                                    nftService: nftService,
                                                                    profileService: profileService,
                                                                    cartService: cartService
        )
        let viewController = CollectionViewController(presenter: collectionPresenter)
        collectionPresenter.viewController = viewController
        viewController.hidesBottomBarWhenPushed = true
        
        return viewController
    }
}

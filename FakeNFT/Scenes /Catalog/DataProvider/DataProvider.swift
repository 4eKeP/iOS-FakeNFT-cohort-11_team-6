//
//  DataProvider.swift
//  FakeNFT
//
//  Created by admin on 24.03.2024.
//

import Foundation

protocol DataProviderProtocol: AnyObject {
    func fetchNFTCollection(completion: @escaping () -> Void)
    func sortNFTCollections(by parameter: NFTCatalogSortingParameters)
    var NFTCollections: [NFTCatalogModel] { get }
}

enum NFTCatalogSortingParameters: String {
    case name
    case nftCount
}

final class DataProvider: DataProviderProtocol {
    
    var NFTCollections: [NFTCatalogModel] = []
    let networkClient: DefaultNetworkClient
    
    init(networkClient: DefaultNetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchNFTCollection(completion: @escaping () -> Void) {
        networkClient.send(request: NFTCollectionsRequest(), type: [NFTCatalogModel].self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nft):
                NFTCollections = nft
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func sortNFTCollections(by parameter: NFTCatalogSortingParameters) {
        switch parameter {
        case .name:
            NFTCollections.sort { $0.name < $1.name }
        case .nftCount:
            NFTCollections.sort { $0.nftCount < $1.nftCount }
        }
    }
}
//
//  Presenter.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 04.04.2024.
//

import Foundation


class CartPresenter {
    private weak var view: CartView?
    private let cartService: CartService
    private let nftService: NftService
    
    init(view: CartView, cartService: CartService, nftService: NftService) {
        self.view = view
        self.cartService = cartService
        self.nftService = nftService
    }
    
    func viewDidLoad() {
        view?.showLoader()
        loadCart(httpMethod: .get, model: Nft.self)
    }

    func loadCart(httpMethod: HttpMethod, model: Nft.Type) {
        cartService.loadCart(httpMethod: httpMethod, model: model as? Encodable) { [weak self] result in
            switch result {
            case .success(let cart):
                self?.loadNFTs(for: cart.nfts)
            case .failure(let error):
                self?.view?.hideLoader()
                self?.view?.displayError(error.localizedDescription)
            }
        }
    }
    
    private func loadNFTs(for ids: [String]) {
        var nfts: [Nft] = []
        let group = DispatchGroup()
        
        for id in ids {
            group.enter()
            nftService.loadNft(id: id) { [weak self] result in
                defer { group.leave() }
                switch result {
                case .success(let nft):
                    nfts.append(nft)
                case .failure(let error):
                    print("Error loading NFT: \(error)")
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.view?.hideLoader()
            if nfts.isEmpty {
                self?.view?.displayEmptyCart()
            } else {
                self?.view?.displayNFTs(nfts)
            }
        }
    }
    
    func deleteNFT(withId id: String) {
        // Implement delete NFT logic
    }
}

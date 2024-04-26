//
//  CongratulationPresenter.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 15.04.2024.
//

import Foundation

final class CongratulationPresenter {
    
    // MARK: - Private Properties
    private weak var view: CongratulationView?
    
    private var cartService: CartService = CartServiceImpl(networkClient: DefaultNetworkClient())
    
    // MARK: - Public Methods
    func getPaymentOrder() {
        let newId: [String] = []
        self.cartService.updateOrder(nftsIds: newId, update: false) { _ in }
    }
}

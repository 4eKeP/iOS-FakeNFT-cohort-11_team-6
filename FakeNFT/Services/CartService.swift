//
//  CartService.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 02.04.2024.
//

import Foundation

typealias CartCompletion = (Result<Cart, Error>) -> Void

protocol CartService {
    func loadCart(httpMethod: HttpMethod, model: (any Encodable)?, completion: @escaping CartCompletion)
}

final class CartServiceImpl: CartService {

    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadCart(httpMethod: HttpMethod, model: (any Encodable)?, completion: @escaping CartCompletion) {
        let model = httpMethod == .get ? nil : model
        let request = CartRequest(method: httpMethod, model: model)
    
        networkClient.send(request: request, type: Cart.self) { result in
            switch result {
            case .success(let cart):
                completion(.success(cart))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

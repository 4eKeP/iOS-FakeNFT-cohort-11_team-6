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
    func deleteFromCart(nftId: String, completion: @escaping CartCompletion)
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
    
    func deleteFromCart(nftId: String, completion: @escaping CartCompletion) {
        let request = CartRequest(method: .delete, model: nil)
        
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

//private func deleteFromCart(httpMethod: HttpMethod, id: String? = nil, completion: @escaping (Error?) -> Void ) {
//        cartService.deleteFromCart(nftId: id ?? "") { result in
//            switch result {
//            case .success:
//                // Если удаление прошло успешно
//                completion(nil)
//            case .failure(let error):
//                completion(error)
//            }
//        }
//    }
//
//    deleteFromCart(httpMethod: .delete, id: cartId) { error in
//        if let error = error {
//            print("Произошла ошибка при удалении из корзины: \(error)")
//        } else {
//            print("Объект успешно удален из корзины")
//        }
//    }

//
//  OrderUpdateRequest.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 10.04.2024.
//

import Foundation

struct OrderUpdateRequest: NetworkRequest {
    let newOrder: NewOrderModel?
    
    var httpMethod: HttpMethod = .put
    
    var dto: (any Encodable)? {
        if let data = newOrder {
            let formData: [String: String] = [
                "nfts": data.nfts.joined(separator: ", ")
            ]
            return formData
        } else {
            return nil
        }
    }
    
    var headers: [String: String]? = ["X-Practicum-Mobile-Token": "6209b976-c7aa-4061-8574-573765a55e71"]
    
    var endpoint: URL? {
        URL(string: "\(NetworkConstants.baseURL)/api/v1/orders/1")
    }
}

struct NewOrderModel: Encodable {
    var nfts: [String]
}

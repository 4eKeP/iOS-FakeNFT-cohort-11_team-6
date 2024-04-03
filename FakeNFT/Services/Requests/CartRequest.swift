//
//  CartRequest.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 02.04.2024.
//

import Foundation

struct CartRequest: NetworkRequest {

    let method: HttpMethod
    let model: (any Encodable)?
    
    var httpMethod: HttpMethod {
        method
    }
    
    var dto: (any Encodable)? {
        model
    }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}

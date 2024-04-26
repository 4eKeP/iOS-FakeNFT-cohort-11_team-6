//
//  CartBuildRequest.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 25.03.2024.
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
        URL(string: "\(NetworkConstants.baseURL)/api/v1/orders/1")
    }
}

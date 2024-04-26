//
//  CurrencyRequest.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 11.04.2024.
//

import Foundation

struct CurrencyRequest: NetworkRequest {
    var httpMethod: HttpMethod = .get
    
    var dto: (any Encodable)? = nil
    
    var headers: [String: String]? = ["X-Practicum-Mobile-Token": "6209b976-c7aa-4061-8574-573765a55e71"]
    
    var endpoint: URL? {
        URL(string: "\(NetworkConstants.baseURL)/api/v1/currencies")
    }
}

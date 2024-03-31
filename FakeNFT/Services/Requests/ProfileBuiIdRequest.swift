//
//  ProfileBuiIdRequest.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 25.03.2024.
//

import Foundation

struct ProfileRequest: NetworkRequest {

    let method: HttpMethod
    let model: (any Encodable)?
    
    var httpMethod: HttpMethod {
        method
    }
    
    var dto: (any Encodable)? {
        model
    }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}
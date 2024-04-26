//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by admin on 06.04.2024.
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
        URL(string: "\(NetworkConstants.baseURL)/api/v1/profile/1")
    }
}

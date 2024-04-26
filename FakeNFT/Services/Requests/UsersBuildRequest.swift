//
//  UsersBuildRequest.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 05.04.2024.
//

import Foundation

struct UsersBuildRequest: NetworkRequest {

    var endpoint: URL? {
        URL(string: "\(NetworkConstants.baseURL)/api/v1/users")
    }
}



//
//  UserDetailedBuildRequest.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 31.03.2024.
//

import Foundation

struct UserDetailedBuildRequest: NetworkRequest {

    let id: String

    var endpoint: URL? {
        URL(string: "\(NetworkConstants.baseURL)/api/v1/users/\(id)")
    }
}


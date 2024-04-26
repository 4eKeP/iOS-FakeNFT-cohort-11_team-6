//
//  NFTCollectionsRequest.swift
//  FakeNFT
//
//  Created by admin on 24.03.2024.
//

import Foundation

struct NFTCollectionsRequest: NetworkRequest {
    var endpoint: URL?
    init() {
        guard let endpoint = URL(string: "\(NetworkConstants.baseURL)/api/v1/collections") else { return }
        self.endpoint = endpoint
    }
}

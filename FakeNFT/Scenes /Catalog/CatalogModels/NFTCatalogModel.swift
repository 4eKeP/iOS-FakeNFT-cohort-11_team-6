//
//  NFTCatalogModel.swift
//  FakeNFT
//
//  Created by admin on 24.03.2024.
//

import Foundation

struct NFTCatalogModel: Codable {
    let name: String
    let cover: String
    let nfts: [String]
    let id: String
    let description: String
    let author: String
    var nftCount: Int {
        nfts.count
    }
    
}

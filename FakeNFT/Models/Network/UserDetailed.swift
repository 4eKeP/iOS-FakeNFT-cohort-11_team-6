//
//  UserDetailed.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 31.03.2024.
//

import Foundation

// MARK: - UserDetailed
struct UserDetailed: Codable, Hashable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating, id: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

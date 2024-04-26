//
//  NftStatistics.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 25.03.2024.
//

import Foundation

struct NftStatistics: Hashable {
    let name: String
    let images: [URL]
    let rating: Int
    let price: Double
    let id: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

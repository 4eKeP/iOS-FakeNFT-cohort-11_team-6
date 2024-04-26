//
//  PaymentConfirmation.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 11.04.2024.
//

import Foundation

struct PaymentConfirmation: Codable {
    let success: Bool
    let orderId: String
    let id: String
}

//
//  EditProfileModel.swift
//  FakeNFT
//
//  Created by Dinara on 11.04.2024.
//

import Foundation

struct EditProfileModel: Encodable {
    let name: String?
    let description: String?
    let avatar: String?
    let website: String?
    let likes: [String]?
}

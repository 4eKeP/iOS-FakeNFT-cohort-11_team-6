//
//  AlertModel.swift
//  FakeNFT
//
//  Created by admin on 26.03.2024.
//

import UIKit

struct AlertModel {
    let title: String
    let style: UIAlertAction.Style
    let completion: (() -> Void)?
}

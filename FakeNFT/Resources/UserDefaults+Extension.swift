//
//  OnBoardingController.swift
//  FakeNFT
//
//  Created by admin on 18.04.2024.
//

import Foundation

extension UserDefaults {
    private enum Keys: String {
        case isOnBoarded
    }
    
    var isOnBoarded: Bool {
        get {
            bool(forKey: Keys.isOnBoarded.rawValue)
        }
        set {
            setValue(newValue, forKey: Keys.isOnBoarded.rawValue)
        }
    }
}

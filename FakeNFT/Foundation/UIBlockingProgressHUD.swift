//
//  UIBlockingProgressHUD.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 29.03.2024.
//

import Foundation

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show(){
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func dismiss(){
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}

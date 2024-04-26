//
//  String+Extension.swift
//  FakeNFT
//
//  Created by admin on 24.03.2024.
//

import Foundation

extension String {
    var encodeUrl: String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }

    var decodeUrl: String {
        return self.removingPercentEncoding!
    }
}

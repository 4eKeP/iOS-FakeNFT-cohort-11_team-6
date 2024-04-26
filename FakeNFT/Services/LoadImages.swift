//
//  LoadImages.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 03.04.2024.
//

import UIKit

class LoadNftImages {
    func loadImages(from imageURLs: [URL], completion: @escaping ([UIImage]?) -> Void) {
        var images: [UIImage] = []
        let dispatchGroup = DispatchGroup()
        
        for url in imageURLs {
            dispatchGroup.enter()
            URLSession.shared.dataTask(with: url) { data, response, error in
                defer { dispatchGroup.leave() }
                
                guard let data = data, error == nil, let image = UIImage(data: data) else {
                    return
                }
                
                images.append(image)
            }.resume()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(images)
        }
    }
}

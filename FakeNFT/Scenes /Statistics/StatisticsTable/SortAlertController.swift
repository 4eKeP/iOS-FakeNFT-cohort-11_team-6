//
//  SortAlertController.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 06.04.2024.
//

import UIKit

final class SortAlertController: UIAlertController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    convenience init(nameSortHandler: @escaping () -> Void, ratingSortHandler: @escaping () -> Void) {
        self.init(title: nil, message: "Сортировка", preferredStyle: .actionSheet)
        
        let nameSortAction = UIAlertAction(title: "По имени", style: .default) { _ in
            nameSortHandler()
        }
        
        let ratingSortAction = UIAlertAction(title: "По рейтингу", style: .default){ _ in
            ratingSortHandler()
        }
        
        let cancelAlertAction = UIAlertAction(title: "Закрыть", style: .cancel)
        
        addAction(nameSortAction)
        addAction(ratingSortAction)
        addAction(cancelAlertAction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

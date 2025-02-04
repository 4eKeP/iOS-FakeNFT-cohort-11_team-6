//
//  CongratulationViewController.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 26.03.2024.
//

import UIKit

protocol CongratulationView: AnyObject {
    func getPaymentOrder()
}

final class CongratulationViewController: UIViewController {
    
    // MARK: - Public Properties
    var allPaymentNft: [Nft] = []
    
    // MARK: - Private Properties
    private let presenter = CongratulationPresenter()
    
    private lazy var pictureImage: UIImageView = {
       let image = UIImage(named: "CongratulationImage")
        let imageView = UIImageView(image: image)
        imageView.heightAnchor.constraint(equalToConstant: 278).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 278).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var congratulationLabel: UILabel = {
       let label = UILabel()
        label.text = "Успех! Оплата прошла, поздравляем с покупкой!"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.widthAnchor.constraint(equalToConstant: 303).isActive = true
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var backCatalogButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.titleLabel?.textColor = .white
        button.setTitle("Вернуться в каталог", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.layer.masksToBounds = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(backToCatalog), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupAllViews()
        getPaymentOrder()
    }
    
    // MARK: - Private Methods
    @objc
    private func backToCatalog() {
        dismiss(animated: true)
    }
    
    private func getPaymentOrder() {
        presenter.getPaymentOrder()
    }

    private func setupAllViews() {
        [pictureImage, congratulationLabel, backCatalogButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            pictureImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 196),
            pictureImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 49),
            pictureImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -49),
            
            congratulationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            congratulationLabel.topAnchor.constraint(equalTo: pictureImage.bottomAnchor, constant: 20),
            
            backCatalogButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            backCatalogButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backCatalogButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

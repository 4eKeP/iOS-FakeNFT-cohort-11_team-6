//
//  CryptoWalletCell.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 25.03.2024.
//

import UIKit

final class CryptoWalletCell: UICollectionViewCell {
    
    lazy var cryptoImage: UIImageView = {
        let image = UIImage(named: "Bitcoin (BTC)")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Private Properties
    private lazy var cryptoBacground: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named: "ypLightGray")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var fullNameCrypto: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.text = "Bitcoin"
        label.heightAnchor.constraint(equalToConstant: 18).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var shortNameCrypto: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.text = "BTC"
        label.heightAnchor.constraint(equalToConstant: 18).isActive = true
        label.textColor = UIColor(named: "ypUniGreen")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cryptoBacground)
        [cryptoImage, fullNameCrypto, shortNameCrypto].forEach {
            cryptoBacground.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            cryptoBacground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cryptoBacground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cryptoBacground.topAnchor.constraint(equalTo: contentView.topAnchor),
            cryptoBacground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        
            cryptoImage.leadingAnchor.constraint(equalTo: cryptoBacground.leadingAnchor, constant: 12),
            cryptoImage.topAnchor.constraint(equalTo: cryptoBacground.topAnchor, constant: 5),
            cryptoImage.bottomAnchor.constraint(equalTo: cryptoBacground.bottomAnchor, constant: -5),
        
            fullNameCrypto.leadingAnchor.constraint(equalTo: cryptoImage.trailingAnchor, constant: 4),
            fullNameCrypto.topAnchor.constraint(equalTo: cryptoBacground.topAnchor, constant: 5),
            
            shortNameCrypto.topAnchor.constraint(equalTo: fullNameCrypto.bottomAnchor),
            shortNameCrypto.leadingAnchor.constraint(equalTo: cryptoImage.trailingAnchor, constant: 4)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setupUiElements(currency: Currency) {
        fullNameCrypto.text = currency.title
        shortNameCrypto.text = currency.name
    }
}

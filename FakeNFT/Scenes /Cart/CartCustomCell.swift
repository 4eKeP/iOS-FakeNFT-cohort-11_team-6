//
//  File.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 22.03.2024.
//

import UIKit

protocol CartCellDelegate: AnyObject {
    func deleteButtonTapped(at indexPath: IndexPath, image: UIImage)
}

class CartCustomCell: UITableViewCell {
    
    var starsCount: Int? {
        didSet {
            setupStarsView()
        }
    }
    
    weak var delegate: CartCellDelegate?
    
    var indexPath: IndexPath?
    
    private lazy var nftView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nftImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "")
        imageView.image = image
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var nftName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.text = "April"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stars: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        return imageView
    }()
    
    lazy var starsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 2 // Расстояние между звездами
        // Создаем пять звезд
        for i in 1...5 {
            let fullStar = "star"
            let emptyStar = "star.fill"
            let starImageView = UIImageView(image: UIImage(systemName: emptyStar))
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
            starImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            starImageView.tintColor = .systemYellow
            stack.addArrangedSubview(starImageView)
        }

        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private func setupStarsView() {
            //Рейтинг NFT
            starsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

            guard let starsCount = starsCount else { return }

            for i in 0..<5 {
                let fullStar = "fullStar"
                let emptyStar = "emptyStar"
                let starImageView = UIImageView(image: UIImage(named: i < starsCount ? fullStar : emptyStar))
                starImageView.translatesAutoresizingMaskIntoConstraints = false
                starImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
                starImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
                starImageView.tintColor = .systemYellow
                starsStack.addArrangedSubview(starImageView)
            }
        }
        
    private lazy var nftPriceLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.text = "Цена"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nftPrice: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.text = "1,78 ETH"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deleteNftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Group 7"), for: .normal)
        button.addTarget(self, action: #selector(deleteNFT), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func deleteNFT() {
        guard let indexPath = indexPath else { return }
        delegate?.deleteButtonTapped(at: indexPath, image: nftImage.image!)
        print("DELETE")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAllViews()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAllViews()
    }
    
    private func setupAllViews() {
        contentView.addSubview(nftView)
        nftView.addSubview(nftImage)
        nftView.addSubview(nftName)
        nftView.addSubview(starsStack)
        nftView.addSubview(nftPriceLabel)
        nftView.addSubview(nftPrice)
        nftView.addSubview(deleteNftButton)
        
        NSLayoutConstraint.activate([
            nftView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            nftView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nftImage.topAnchor.constraint(equalTo: nftView.topAnchor, constant: 16),
            nftImage.leadingAnchor.constraint(equalTo: nftView.leadingAnchor, constant: 16),
            nftImage.bottomAnchor.constraint(equalTo: nftView.bottomAnchor, constant: -16),
            nftImage.widthAnchor.constraint(equalToConstant: 108),
            
            nftName.topAnchor.constraint(equalTo: nftView.topAnchor, constant: 24),
            nftName.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            
            starsStack.topAnchor.constraint(equalTo: nftName.bottomAnchor, constant: 4),
            starsStack.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            
            nftPriceLabel.topAnchor.constraint(equalTo: starsStack.bottomAnchor, constant: 12),
            nftPriceLabel.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            nftPriceLabel.trailingAnchor.constraint(equalTo: nftView.trailingAnchor, constant: -147),
            
            nftPrice.topAnchor.constraint(equalTo: nftPriceLabel.bottomAnchor, constant: 4),
            nftPrice.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            
            deleteNftButton.centerYAnchor.constraint(equalTo: nftView.centerYAnchor),
            deleteNftButton.trailingAnchor.constraint(equalTo: nftView.trailingAnchor, constant: -16),
            deleteNftButton.widthAnchor.constraint(equalToConstant: 40),
            deleteNftButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}



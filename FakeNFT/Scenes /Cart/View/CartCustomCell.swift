//
//  File.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 22.03.2024.
//

import UIKit

protocol CartCellDelegate: AnyObject {
    func deleteButtonTapped(at indexPath: IndexPath, image: UIImage, id: String)
}

final class CartCustomCell: UITableViewCell {
    
    // MARK: Public Properties
    weak var delegate: CartCellDelegate?
    var indexPath: IndexPath?
    var deleteNftId: String?
    
    lazy var nftImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "")
        imageView.image = image
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: Private Properties
    private var starsCount: Int? {
        didSet {
            setupStarsView()
        }
    }
    
    private lazy var nftView: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.Colors.ypWhite.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nftName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.text = "April"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stars: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        return imageView
    }()
    
    private lazy var starsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 2
        for _ in 1...5 {
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
    
    // MARK: - Initializers / Public Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAllViews()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAllViews()
    }
    
    func update(name: String, price: String, starsCount: Int, indexPath: IndexPath) {
        nftName.text = name
        nftPrice.text = price
        self.starsCount = starsCount
        self.indexPath = indexPath
    }
    
    // MARK: - Private Methods
    @objc
    private func deleteNFT() {
        guard let indexPath = indexPath,
              let image = nftImage.image,
              let deleteNftId = deleteNftId else {
            return
        }
        delegate?.deleteButtonTapped(at: indexPath, image: image, id: deleteNftId)
    }
    
    private func setupStarsView() {
        starsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        guard let starsCount = starsCount else { return }
        for index in 0..<5 {
            let fullStar = "fullStar"
            let emptyStar = "emptyStar"
            let starImageView = UIImageView(image: UIImage(named: index < starsCount ? fullStar : emptyStar))
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
    
    private lazy var nftPrice: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.text = "1,78 ETH"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deleteNftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Group 7"), for: .normal)
        if traitCollection.userInterfaceStyle == .dark {
                button.tintColor = .white
            } else {
                button.tintColor = .black
            }
        button.addTarget(self, action: #selector(deleteNFT), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func setupAllViews() {
        contentView.addSubview(nftView)
        [nftImage, nftName, starsStack, nftPriceLabel, nftPrice, deleteNftButton].forEach {
            nftView.addSubview($0)
        }
        
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



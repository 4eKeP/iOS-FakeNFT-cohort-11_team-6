//
//  FavoriteNFTCell.swift
//  FakeNFT
//
//  Created by Dinara on 30.03.2024.
//

import Kingfisher
import SnapKit
import UIKit

protocol FavoriteNFTCellDelegate: AnyObject {
    func didTapLikeButton(in cell: FavoriteNFTCell)
}

final class FavoriteNFTCell: UICollectionViewCell {
    // MARK: - Public properties
    public static let cellID = String(describing: FavoriteNFTCell.self)

    // MARK: - Private Properties
    private var id: String?

    // MARK: - Delegate
    weak var delegate: FavoriteNFTCellDelegate?

    // MARK: - UI
    private lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.addTarget(
            self,
            action: #selector(likeButtonDidTap),
            for: .touchUpInside)
        return button
    }()

    private lazy var name: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor(named: "ypBlack")
        label.numberOfLines = 0
        return label
    }()

    private lazy var ratingView: RatingView = {
        let view = RatingView()
        return view
    }()

    private lazy var priceValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(named: "ypBlack")
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 4
        return stackView
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Method
    func configureCell(with model: NFT) {
        if let imageURLString = model.images.first,
           let imageURL = URL(string: imageURLString) {
            image.kf.setImage(with: imageURL)
        } else {
            image.image = UIImage(named: "avatar_icon")
        }

        name.text = model.name
        ratingView.setRating(model.rating)
        let stringFromNumber = String(format: "%.2f", model.price)
        priceValue.text = stringFromNumber + " ETH"
        id = model.id
    }

    func setIsLikedNFT(_ isLiked: Bool) {
        if isLiked {
            favoriteButton.setImage(UIImage(named: "favorite_button_active"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "favorite_button_inactive"), for: .normal)
        }
    }
}

private extension FavoriteNFTCell {
    // MARK: - Setup Views
    private func setupViews() {
        self.backgroundColor = .systemBackground

        [name,
         ratingView,
         priceValue
        ].forEach {
            stackView.addArrangedSubview($0)
        }

        [image,
         favoriteButton,
         stackView
        ].forEach {
            contentView.addSubview($0)
        }
    }

    // MARK: - Setup Constraints
    func setupConstraints() {
        image.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(80)
        }

        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(image.snp.top).offset(6)
            make.trailing.equalTo(image.snp.trailing).offset(-6)
            make.width.equalTo(21)
            make.height.equalTo(18)
        }

        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(image.snp.centerY)
            make.leading.equalTo(image.snp.trailing).offset(12)
            make.width.equalTo(76)
            make.height.equalTo(66)
        }

        ratingView.snp.makeConstraints { make in
            make.width.equalTo(68)
            make.height.equalTo(12)
        }
    }

    // MARK: - Actions
    @objc func likeButtonDidTap() {
            delegate?.didTapLikeButton(in: self)
    }
}

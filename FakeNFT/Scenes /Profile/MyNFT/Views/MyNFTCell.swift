//
//  MyNFTCell.swift
//  FakeNFT
//
//  Created by Dinara on 28.03.2024.
//

import Kingfisher
import SnapKit
import UIKit

// MARK: - MyNFTCellDelegate Protocol
protocol MyNFTCellDelegate: AnyObject {
    func didTapLikeButton(with nftID: String)
}

// MARK: - MyNFTCell
final class MyNFTCell: UITableViewCell {

    // MARK: - Public properties
    public static let cellID = String(describing: MyNFTCell.self)

    // MARK: - Private Properties
    private var id: String?

    // MARK: - Delegate
    weak var delegate: MyNFTCellDelegate?

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
        return label
    }()

    private lazy var ratingView: RatingView = {
        let view = RatingView()
        return view
    }()

    private lazy var author: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(named: "ypBlack")
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
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

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Profile.priceText
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(named: "ypBlack")
        return label
    }()

    private lazy var priceValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(named: "ypBlack")
        return label
    }()

    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 2
        return stackView
    }()

    // MARK: - Lifecycle
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
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
        author.text = "от \(model.author)"
        let stringFromNumber = String(format: "%.2f", model.price)
        priceValue.text = stringFromNumber + " ETH"
        id = model.id
    }

    func setIsLiked(isLiked: Bool) {
        if isLiked {
            favoriteButton.setImage(UIImage(named: "favorite_button_active"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "favorite_button_inactive"), for: .normal)
        }
    }
 }

// MARK: - Private Extension
private extension MyNFTCell {
    // MARK: - Setup Views
    func setupViews() {
        self.backgroundColor = .systemBackground

        [name,
         ratingView,
         author
        ].forEach {
            stackView.addArrangedSubview($0)
        }

        [priceLabel,
         priceValue
        ].forEach {
            priceStackView.addArrangedSubview($0)
        }

        [image,
         favoriteButton,
         stackView,
         priceStackView
        ].forEach {
            contentView.addSubview($0)
        }
    }

    // MARK: - Setup Constraints
    func setupConstraints() {
        image.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(108)
        }

        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(image.snp.top).offset(12)
            make.trailing.equalTo(image.snp.trailing).offset(-12)
            make.width.equalTo(18)
            make.height.equalTo(16)
        }

        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(image.snp.centerY)
            make.leading.equalTo(image.snp.trailing).offset(20)
            make.bottom.equalTo(image.snp.bottom).offset(-23)
        }

        priceStackView.snp.makeConstraints { make in
            make.centerY.equalTo(stackView.snp.centerY)
            make.trailing.equalToSuperview().offset(-39)
            make.bottom.equalTo(stackView.snp.bottom).offset(-10)
        }

        ratingView.snp.makeConstraints { make in
            make.width.equalTo(68)
            make.height.equalTo(12)
        }
    }

    // MARK: - Actions
    @objc func likeButtonDidTap() {
        if let id = id {
            delegate?.didTapLikeButton(with: id)
        }
    }
}

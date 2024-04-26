//
//  NFTCollectionViewCellThreePerRow.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 24.03.2024.
//

import UIKit
import SnapKit
import Kingfisher

final class NFTCollectionViewCellThreePerRow: UICollectionViewCell, ReuseIdentifying {
    
    static let reuseID = "NFTCollectionViewCellThreePerRow"
    
    private var id: String = ""
    
    private lazy var nftImageView: UIImageView = {
        let nftImageView = UIImageView()
        nftImageView.layer.cornerRadius = 12
        nftImageView.layer.masksToBounds = true
     //   nftImageView.image = Asset.MockImages.Beige.April._1.image
        return nftImageView
    }()
    
    private lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.setImage(
            UIImage(systemName: "heart.fill"),
            for: .normal)
        likeButton.tintColor = .white
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        return likeButton
    }()
    
    private lazy var ratingStackView: RatingStackView = RatingStackView()
    private lazy var bottomContainerView = UIView()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .bodyBold
        nameLabel.text = "Archie"
        
        nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        nameLabel.numberOfLines = 2
        nameLabel.adjustsFontSizeToFitWidth = true
        return nameLabel
    }()
    
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = .systemFont(ofSize: 10, weight: .medium)
        priceLabel.text = "1,78 ETH"
        return priceLabel
    }()
    
    private lazy var cartButton: UIButton = {
        let cartButton = UIButton()
        cartButton.setImage(UIImage(resource: .cartAdd).withTintColor(.label), for: .normal)
        cartButton.addTarget(self, action: #selector(cartTapped), for: .touchUpInside)
        return cartButton
    }()
    
    weak var delegate: NFTCollectionViewCellThreePerRowDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        contentView.addSubview(nftImageView)
        nftImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }
        
        contentView.addSubview(likeButton)
        likeButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(40)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        contentView.addSubview(ratingStackView)
        ratingStackView.snp.makeConstraints { make in
            make.top.equalTo(nftImageView.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalTo(nftImageView.snp.trailing).offset(-40)
        }
        
        contentView.addSubview(bottomContainerView)
        bottomContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(ratingStackView.snp.bottom).offset(5)
            make.trailing.equalToSuperview()
            make.bottom.greaterThanOrEqualToSuperview().offset(-21)
        }
        
        bottomContainerView.addSubview(cartButton)
        cartButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
        }
        
        bottomContainerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalTo(cartButton.snp.leading)
        }
        
        bottomContainerView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.trailing.equalTo(cartButton.snp.leading)
        }
        
    }
    
    @objc private func likeTapped() {
        likeButton.isUserInteractionEnabled = false
        delegate?.likeTapped(id: id)
    }
    
    @objc private func cartTapped() {
        cartButton.isUserInteractionEnabled = false
        delegate?.cartTapped(id: id)
    }
    
    func setLikedStateToLikeButton(isLiked: Bool) {
        if isLiked {
            likeButton.tintColor = Asset.Colors.Universal.ypUniRed.color
        } else {
            likeButton.tintColor = Asset.Colors.Universal.ypUniWhite.color
        }
    }
    
    func setAddedStateToCart(isAdded: Bool) {
        if isAdded {
            cartButton.setImage(Asset.StatisticsImages.cartDelete.image.withTintColor(.label), for: .normal)
        } else {
            cartButton.setImage(Asset.StatisticsImages.cartAdd.image.withTintColor(.label), for: .normal)
        }
    }
    
    func set(data: NftStatistics) {
        nftImageView.kf.setImage(with: data.images[0])
        nameLabel.text = data.name
        ratingStackView.set(rating: data.rating)
        let numStr = String(format: "%.2f", data.price)
        priceLabel.text = numStr + " ETH"
        id = data.id
    }
    
    func set(data: CollectionCellModel) {
        nftImageView.kf.setImage(with: data.image)
        nameLabel.text = data.name
        ratingStackView.set(rating: data.rating)
        let numStr = String(format: "%.2f", data.price)
        priceLabel.text = numStr + " ETH"
        id = data.id
        setLikedStateToLikeButton(isLiked: data.isLiked)
        setAddedStateToCart(isAdded: data.isAddedToCart)
    }
    
    func getId() -> String { id }
    
    func setIsUserInteractionEnabledToTrue(isCart: Bool) {
        if isCart {
            cartButton.isUserInteractionEnabled = true
        } else {
            likeButton.isUserInteractionEnabled = true
        }
    }
}

//
//  StatisticsTableViewCell.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 05.04.2024.
//

import UIKit
import SnapKit

final class StatisticsTableViewCell: UITableViewCell, ReuseIdentifying {
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = Asset.Colors.ypLightGray.color
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        return containerView
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 14
        avatarImageView.contentMode = .scaleAspectFit
        return avatarImageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.6
        return nameLabel
    }()
    
    private lazy var countNftLabel: UILabel = {
        let countNftLabel = UILabel()
        countNftLabel.font = .systemFont(ofSize: 22, weight: .bold)
        countNftLabel.textAlignment = .right
        countNftLabel.adjustsFontSizeToFitWidth = true
        countNftLabel.minimumScaleFactor = 0.6
        return countNftLabel
    }()
    
    private lazy var ratingLabel: UILabel = {
        let ratingLabel = UILabel()
        ratingLabel.font = .systemFont(ofSize: 15, weight: .regular)
        return ratingLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
    }
    
    private func configure() {
        
        contentView.addSubview(ratingLabel)
        ratingLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(27)
            make.height.equalTo(20)
        }
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalTo(ratingLabel.snp.trailing).offset(8)
        }
        
        [
            avatarImageView,
            nameLabel,
            countNftLabel
        ].forEach{ containerView.addSubview($0) }
        
        avatarImageView.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.width.equalTo(28)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(8)
            make.trailing.equalTo(countNftLabel.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }
        
        countNftLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
        }
    }
    
    func set(user: UserDetailed) {
        ratingLabel.text = user.rating
        nameLabel.text = user.name
        countNftLabel.text = "\(user.nfts.count)"
        
        guard let url = URL(string: user.avatar) else { return }
        avatarImageView.kf.setImage(with: url) {[weak self] result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                let errorImage = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(Asset.Colors.Universal.ypUniGray.color, renderingMode: .alwaysOriginal)
                self?.avatarImageView.image = errorImage
            }
        }
    }
}

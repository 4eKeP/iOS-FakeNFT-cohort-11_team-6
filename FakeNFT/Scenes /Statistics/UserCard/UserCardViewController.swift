//
//  UserCardViewController.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 31.03.2024.
//

import UIKit
import SnapKit
import Kingfisher

protocol UserCardView: AnyObject,ErrorView {
    func updateData(with userDetailed: UserDetailed)
}

final class UserCardViewController: UIViewController {
    
    private let presenter: UserCardPresenter
    
    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.layer.masksToBounds = true
        return avatarImageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        return nameLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.numberOfLines = 4
        descriptionLabel.lineBreakMode = .byWordWrapping
        return descriptionLabel
    }()
    
    private lazy var websiteButton: UIButton = {
        let websiteButton = UIButton()
        websiteButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        websiteButton.layer.cornerRadius = 16
        websiteButton.layer.masksToBounds = true
        websiteButton.layer.borderWidth = 1
        websiteButton.setTitleColor(.label, for: .normal)
        websiteButton.layer.borderColor = UIColor.label.cgColor
        websiteButton.setTitle("Перейти на сайт пользователя", for: .normal)
        websiteButton.addTarget(self, action: #selector(websiteButtonTapped), for: .touchUpInside)
        
        websiteButton.isHidden = true
        return websiteButton
    }()
    
    private lazy var colletionNFTControl: UIControl = {
        let colletionNFTControl = UIControl()
        colletionNFTControl.addTarget(self, action: #selector(colletionNFTControlTapped), for: UIControl.Event.touchUpInside)
        return colletionNFTControl
    }()
    
    private lazy var collectionNFTLabel: UILabel = {
        let collectionNFTLabel = UILabel()
        collectionNFTLabel.font = .systemFont(ofSize: 17, weight: .bold)
        return collectionNFTLabel
    }()
    
    private lazy var chevronImageView: UIImageView = {
        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.forward"))
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.tintColor = .label
        
        chevronImageView.isHidden = true
        return chevronImageView
    }()
    
    init(presenter: UserCardPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutUI()
        presenter.viewDidLoad()
        let backButton = UIBarButtonItem(title: "",
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonPressed))
        backButton.image = UIImage(systemName: "chevron.left")
        navigationItem.leftBarButtonItem = backButton
        
    }
    
    @objc private func backButtonPressed() {
        presenter.backButtonPressed()
    }
    
    
    func layoutUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.height.equalTo(70)
            make.width.equalTo(70)
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.centerY.equalTo(avatarImageView.snp.centerY)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-18)
        }
        
        view.addSubview(websiteButton)
        websiteButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(28)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(40)
        }
        
        view.addSubview(colletionNFTControl)
        colletionNFTControl.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(54)
            make.top.equalTo(websiteButton.snp.bottom).offset(40)
        }
        
        colletionNFTControl.addSubview(collectionNFTLabel)
        collectionNFTLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        colletionNFTControl.addSubview(chevronImageView)
        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    @objc private func colletionNFTControlTapped(){
        presenter.colletionNFTControlTapped()
    }
    
    @objc private func websiteButtonTapped() {
        presenter.websiteButtonTapped()
    }
}
    
extension  UserCardViewController: UserCardView {
    func updateData(with userDetailed: UserDetailed) {
        guard let avatarUrl = URL(string: userDetailed.avatar) else { return }
        
        avatarImageView.kf.setImage(with: avatarUrl) {[weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(_):
                break
            case .failure(_):
                let errorImage = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(Asset.Colors.Universal.ypUniGray.color, renderingMode: .alwaysOriginal)
                avatarImageView.image = errorImage
            }
        }
        
        nameLabel.text = userDetailed.name
        descriptionLabel.text = userDetailed.description
        collectionNFTLabel.text = "Коллекция NFT (\(userDetailed.nfts.count))"
        
        chevronImageView.isHidden = false
        websiteButton.isHidden = false
    }
}

//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Dinara on 23.03.2024.
//

import Kingfisher
import SnapKit
import UIKit

// MARK: - ProfileViewControllerProtocol
protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenter? { get set }
    func updateProfileDetails(_ profile: UserProfile?)
    func updateAvatar(url: URL)
}

// MARK: - ProfileViewController Class 
final class ProfileViewController: UIViewController {

    // MARK: - Public Properties
    let servicesAssembly: ServicesAssembly
    var presenter: ProfilePresenter?
    weak var delegate: ProfilePresenterDelegate?
    private let profileService = UserProfileService.shared
    private var avatarImage: UIImage?

    // MARK: - Private Properties
    private var myNFTsCount = 0
    private var myFavoritesCount = 0

    // MARK: - UI
    private lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(editBarButtonTapped)
        )
        button.tintColor = UIColor(named: "ypUniBlack")
        return button
    }()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ypUniBlack")
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()

    // swiftlint:disable all
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ypUniBlack")
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    // swiftlint:enable all

    private lazy var siteLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ypUniBlue")
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()

    private lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            ProfileCell.self,
            forCellReuseIdentifier: ProfileCell.cellID
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.isScrollEnabled = false
        return tableView
    }()

    // MARK: - Init
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViews()
        setupConstraints()
        delegate = self
        presenter?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
}

// MARK: - ProfileViewController Class
private extension ProfileViewController {
    // MARK: - Setup Navigation
    func setupNavigation() {
        navigationItem.rightBarButtonItem = editButton
    }

    // MARK: - Setup Views
    func setupViews() {
        view.backgroundColor = .systemBackground

        [avatarImageView,
         nameLabel
        ].forEach {
            stackView.addArrangedSubview($0)
        }

        [stackView,
         descriptionLabel,
         siteLabel
        ].forEach {
            userInfoStackView.addArrangedSubview($0)
        }

        userInfoStackView.setCustomSpacing(8, after: descriptionLabel)

        [userInfoStackView,
         tableView
        ].forEach {
            view.addSubview($0)
        }
    }

    // MARK: - Setup Constraints
    func setupConstraints() {
        let cellHeight = CGFloat(54)

        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(70)
        }

        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(70)
        }

        userInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(userInfoStackView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(cellHeight * 3)
        }
    }

    // MARK: - Actions
    @objc func editBarButtonTapped() {
        presenter?.didTapEditProfile()
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileCell.cellID,
            for: indexPath
        ) as? ProfileCell else {
            fatalError("Could not cast to ProfileCell")
        }

        let myNFTLabel = L10n.Profile.myNFT
        let favoriteNFTlabel = L10n.Profile.favoritesNFT
        let aboutDeveloperLabel = L10n.Profile.aboutDeveloper

        switch indexPath.section {
        case 0:
            cell.configureText(label: "\(myNFTLabel) (\(myNFTsCount))")
        case 1:
            cell.configureText(label: "\(favoriteNFTlabel) (\(myFavoritesCount))")
        case 2:
            cell.configureText(label: "\(aboutDeveloperLabel)")
        default:
            break
        }

        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            presenter?.didTapMyNFT()
        case 1:
            presenter?.didTapFavoriteNFT()
        case 2:
            let viewController = AboutDeveloperViewController()
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
}

// MARK: - ProfileViewControllerProtocol
extension ProfileViewController: ProfileViewControllerProtocol {
    func updateProfileDetails(_ profile: UserProfile?) {
        if let profile {
            nameLabel.text = profile.name
            descriptionLabel.text = profile.description
            siteLabel.text = profile.website

            guard let avatarURLString = profile.avatar,
                  let avatarURL = URL(string: avatarURLString) else {
                return
            }
            updateAvatar(url: avatarURL)

            myNFTsCount = profile.nfts.count
            myFavoritesCount = profile.likes.count
            tableView.reloadData()

        } else {
            nameLabel.text = ""
            descriptionLabel.text = ""
            siteLabel.text = ""
            avatarImageView.image = UIImage()
        }
    }

    func updateAvatar(url: URL) {
        avatarImageView.kf.setImage(with: url, options: [.forceRefresh])
    }
}

extension ProfileViewController: ProfilePresenterDelegate {
    func navigateToEditProfileScreen(profile: UserProfile) {
        let editProfileService = EditProfileService.shared
        let editProfileViewController = EditProfileViewController(
            presenter: nil
        )
        editProfileViewController.editProfilePresenterDelegate = self
        editProfileService.setView(editProfileViewController)
        let editProfilePresenter = EditProfilePresenter(
            view: editProfileViewController,
            editProfileService: editProfileService, profile: profile
        )
        editProfilePresenter.delegate = self
        editProfileViewController.presenter = editProfilePresenter
        editProfileViewController.modalPresentationStyle = .popover
        self.present(editProfileViewController, animated: true)
    }

    func navigateToFavoriteNFTScreen(with nftID: [String], and likedNFT: [String]) {
        let favoriteNFTViewController = FavoriteNFTViewController(nftID: nftID, likedID: likedNFT)
        favoriteNFTViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(
            favoriteNFTViewController,
            animated: true
        )
    }

    func navigateToMyNFTScreen(with nftID: [String], and likedNFT: [String]) {
        let myNFTViewController = MyNFTViewController(nftID: nftID, likedID: likedNFT)
        myNFTViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(
            myNFTViewController,
            animated: true
        )
    }
}

// MARK: - EditProfilePresenterDelegate
extension ProfileViewController: EditProfilePresenterDelegate {
    func profileDidUpdate(_ profile: UserProfile, newAvatarURL: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.updateProfileDetails(profile)
            self?.presenter?.updateUserProfile(with: profile)
        }
    }
}

//
//  FavoriteNFTViewController.swift
//  FakeNFT
//
//  Created by Dinara on 30.03.2024.
//

import SnapKit
import UIKit

protocol FavoriteNFTViewControllerProtocol: AnyObject {
    var presenter: FavoriteNFTPresenter? { get set }
    func updateFavoriteNFTs(_ likes: [NFT]?)
}

// MARK: - FavoriteNFTViewController
final class FavoriteNFTViewController: UIViewController {

    // MARK: - Private Properties
    private var favoriteNFTS: [NFT] = []
    var presenter: FavoriteNFTPresenter?
    private var nftID: [String]
    private var likedNFT: [String]
    private let editProfileService = EditProfileService.shared

    init(nftID: [String], likedID: [String]) {
        self.nftID = nftID
        self.likedNFT = likedID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    private lazy var navBackButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(navBackButtonDidTap))
        button.tintColor = UIColor(named: "ypBlack")
        return button
    }()

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let horizontalInset: CGFloat = 16
        let numberOfColumns: CGFloat = 2
        let minimumInterItemSpacing: CGFloat = 7
        let minimumLineSpacing: CGFloat = 20
        let totalHorizontalInset: CGFloat = horizontalInset * numberOfColumns + minimumInterItemSpacing
        let itemWidth: CGFloat = (view.frame.width - totalHorizontalInset) / numberOfColumns

        layout.minimumLineSpacing = minimumLineSpacing
        layout.minimumInteritemSpacing = minimumInterItemSpacing
        layout.estimatedItemSize = CGSize(width: itemWidth,
                                          height: view.frame.height)
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FavoriteNFTCell.self,
                                forCellWithReuseIdentifier: FavoriteNFTCell.cellID)
        collectionView.clipsToBounds = false
        return collectionView
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Profile.emptyFavouriteNFT
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor(named: "ypBlack")
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupViews()
        setupConstraints()
        presenter = FavoriteNFTPresenter(nftID: self.nftID, likedNFT: self.likedNFT, editProfileService: editProfileService)
        presenter?.view = self
        presenter?.viewDidLoad()
    }
}

// MARK: - Private Extension
private extension FavoriteNFTViewController {
    // MARK: - Setup Navigation
    func setupNavigation() {
        navigationItem.title = L10n.Profile.NFTFavorites
        navigationItem.leftBarButtonItem = navBackButton
    }

    // MARK: - Setup Views
    func setupViews() {
        [collectionView,
         emptyLabel
        ].forEach {
            view.addSubview($0)
        }
    }

    // MARK: - Setup Constraints
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        emptyLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

    // MARK: - Actions
    @objc func navBackButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension FavoriteNFTViewController: UICollectionViewDataSource,
                                     UICollectionViewDelegate,
                                     UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if let presenter = presenter {
            if  presenter.likes.isEmpty {
               emptyLabel.isHidden = false
               collectionView.isHidden = true
               navigationItem.title = ""
            } else {
                emptyLabel.isHidden = true
                collectionView.isHidden = false
            }
        } else {
            print("presenter is nil")
        }

        return presenter?.likes.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoriteNFTCell.cellID,
            for: indexPath
        ) as? FavoriteNFTCell else {
            fatalError("Could not cast to FavoriteNFTCell")
        }

        guard let likes = presenter?.likes[indexPath.row] else {
            return UICollectionViewCell()
        }

        cell.configureCell(with: likes)
        cell.delegate = self

        cell.setIsLikedNFT(likedNFT.contains(likes.id))

        cell.selectedBackgroundView = .none

        return cell
    }
}

extension FavoriteNFTViewController: FavoriteNFTCellDelegate {
    func didTapLikeButton(in cell: FavoriteNFTCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }

        guard let like = presenter?.likes[indexPath.row] else { return }
        presenter?.tapLikeNFT(for: like)

    }
}

extension FavoriteNFTViewController: FavoriteNFTViewControllerProtocol {
    func updateFavoriteNFTs(_ likes: [NFT]?) {
        guard let presenter = presenter else {
            print("Presenter is nil")
            return
        }

        guard let likes = likes else {
            print("Received nil Likes")
            return
        }

        presenter.likes = likes

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

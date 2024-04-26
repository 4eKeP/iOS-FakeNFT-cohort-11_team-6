//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by admin on 28.03.2024.
//

import UIKit


final class CollectionViewController: UIViewController, ErrorView {
    
    private let collectionLabelsFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    private var collectionViewHeightConstraint = NSLayoutConstraint()
    
    //MARK: - Views
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private lazy var coverImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.ypBlack.color
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var aboutAuthorLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.ypBlack.color
        label.font = collectionLabelsFont
        label.text = L10n.Catalog.Collection.aboutAuthor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var authorLinkLabel: UILabel = {
        let label = UILabel()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(authorLinkTapped))
        label.font = collectionLabelsFont
        label.textColor = Asset.Colors.Universal.ypUniBlue.color
        label.backgroundColor = Asset.Colors.ypWhite.color
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    private lazy var collectionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = collectionLabelsFont
        label.textColor = Asset.Colors.ypBlack.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nftCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 28
        layout.minimumInteritemSpacing = 9
        self.collectionCellWidth = calculateCellWidth(frameWidth: view.frame.width)
        layout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth * 1.6)
        let nftCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        nftCollection.isScrollEnabled = false
        nftCollection.dataSource = self
        nftCollection.delegate = self
        nftCollection.backgroundColor = Asset.Colors.ypWhite.color
        nftCollection.translatesAutoresizingMaskIntoConstraints = false
        nftCollection.register(NFTCollectionViewCellThreePerRow.self)
        return nftCollection
    }()
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(backButtonTapped))
        return button
    }()
    
    private let presenter: CollectionViewControllerProtocol
    
    //MARK: - Constants
    
    private let coverImageHeight: CGFloat = 310
    
    private let collectionControllerSpacing: CGFloat = 16
    
    private let titleToAboutAuthorSpacing: CGFloat = 13
    
    private let aboutAuthorToAuthorLinkSpacing: CGFloat = 4
    
    private let aboutAuthorToDescriptionSpacing: CGFloat = 5
    
    private let descriptionToNftCollectionSpacing: CGFloat = 24
    
    private var collectionCellWidth: CGFloat = 0
    
    private var topBarHeight: CGFloat {
        let statusBarHeight: CGFloat = 54.0
        let navBarHeight: CGFloat = 96
        
        return statusBarHeight + navBarHeight
    }
    
    init(presenter: CollectionViewControllerPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.controllerDidLoad()
        setupUI()
    }
    
    //MARK: - public funcs
    
    func show(viewCollectionViewModel model: CollectionViewModel) {
        DispatchQueue.main.async {
            self.loadCoverImage(url: model.coverImageURL)
            self.titleLabel.text = model.title
            self.authorLinkLabel.text = model.authorName
            self.collectionDescriptionLabel.text = model.description
        }
    }
    
    func reloadCollectionView() {
        nftCollectionView.reloadData()
    }
    
    func reloadCollectionForLikesAndCard(with nfts: [CollectionCellModel], id: String?, isCart: Bool?) {
        for (index, _) in nfts.enumerated() {
            if let cell = nftCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? NFTCollectionViewCellThreePerRow {
                let retunedNft = presenter.returnCollectionCell(for: index)
                cell.set(data: retunedNft)
                
                if let id,
                   let isCart,
                   cell.getId() == id {
                    cell.setIsUserInteractionEnabledToTrue(isCart: isCart)
                }
                
                cell.delegate = presenter
            }
        }
    }
    
    func configNavBackButton() {
        navigationController?.navigationBar.tintColor = Asset.Colors.ypBlack.color
        navigationItem.leftBarButtonItem = backButton
    }
    
    //MARK: - private funcs
    
    @objc private func authorLinkTapped() {
        presenter.authorLinkTapped()
    }
    
    @objc private func backButtonTapped() {
        presenter.backButtonTapped()
    }
    
    private func loadCoverImage(url: URL) {
        coverImageView.kf.setImage(with: url)
    }
}

//MARK: - UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        calculateCollectionHeight(itemCount: presenter.nftArray.count, cellHeight: self.collectionCellWidth * 1.78)
        return presenter.nftArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell: NFTCollectionViewCellThreePerRow = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.delegate = self.presenter
        let nft = presenter.returnCollectionCell(for: indexPath.row)
        cell.set(data: nft)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension CollectionViewController: UICollectionViewDelegate {
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewController: UICollectionViewDelegateFlowLayout {

}

//MARK: - UI config

private extension CollectionViewController {
    func setupUI() {
        addingViews()
        configConstraints()
        configNavBackButton()
        view.backgroundColor = Asset.Colors.ypWhite.color
    }
    
    func addingViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        [ coverImageView,
          titleLabel,
          aboutAuthorLabel,
          authorLinkLabel,
          collectionDescriptionLabel,
          nftCollectionView
        ].forEach {containerView.addSubview($0)}
    }
    
    func configConstraints() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        collectionViewHeightConstraint = nftCollectionView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: -topBarHeight),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            coverImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: coverImageHeight),
            
            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: collectionControllerSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: collectionControllerSpacing),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor),
            
            aboutAuthorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: titleToAboutAuthorSpacing),
            aboutAuthorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            authorLinkLabel.leadingAnchor.constraint(equalTo: aboutAuthorLabel.trailingAnchor, constant: aboutAuthorToAuthorLinkSpacing),
            authorLinkLabel.bottomAnchor.constraint(equalTo: aboutAuthorLabel.bottomAnchor),
            
            collectionDescriptionLabel.topAnchor.constraint(equalTo: aboutAuthorLabel.bottomAnchor, constant: aboutAuthorToDescriptionSpacing),
            collectionDescriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            collectionDescriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -collectionControllerSpacing),
            
            nftCollectionView.topAnchor.constraint(equalTo: collectionDescriptionLabel.bottomAnchor, constant: descriptionToNftCollectionSpacing),
            nftCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: collectionControllerSpacing),
            nftCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -collectionControllerSpacing),
            nftCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            collectionViewHeightConstraint
        ])
    }
    
    func calculateCollectionHeight(itemCount: Int, cellHeight: CGFloat) {
        let itemsPerRow = 3
        let bottomMargin: CGFloat = 40
        let numRows = (itemCount + itemsPerRow) / itemsPerRow // Вычисляем количество строк
        // Вычисляем высоту коллекции
        collectionViewHeightConstraint.constant = CGFloat(numRows) * cellHeight + bottomMargin
    }
    
    func calculateCellWidth(frameWidth: CGFloat) -> CGFloat {
        let availableWidth = (frameWidth - (10 * 2 + 16 * 2))
        let itemWidth = availableWidth / 3
        return itemWidth
    }
}





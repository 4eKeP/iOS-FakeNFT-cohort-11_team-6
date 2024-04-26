//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 24.03.2024.
//

import UIKit
import SnapKit

protocol UsersCollectionView: AnyObject, ErrorView {
    func updateData(with: [NftStatistics], id: String?, isCart: Bool?)
}

final class UsersCollectionViewController: UIViewController, ErrorView {
    
    private let presenter: UsersCollectionPresenter
    
    enum Section {
        case main
    }
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, NftStatistics> = {
        UICollectionViewDiffableDataSource<Section, NftStatistics>(
            collectionView: collectionView,
            cellProvider: {[weak self] (collectionView, indexPath, nft) -> UICollectionViewCell? in
                
                guard let self else { return UICollectionViewCell()}
                let cell: NFTCollectionViewCellThreePerRow = collectionView.dequeueReusableCell(indexPath: indexPath)
                
                cell.delegate = presenter
                return cell
            })
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let countOfCellsInRow: CGFloat = 3
        let minimumInteritemSpacing: CGFloat = 9
        let sidePadding: CGFloat = 16
        let aspectRatio: CGFloat = 1.78
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: sidePadding, bottom: 0, right: sidePadding)
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        
        let totalPaddingWidth = (minimumInteritemSpacing+1) * (countOfCellsInRow-1) + sidePadding * (countOfCellsInRow-1)
        let availableWidth = view.frame.width - totalPaddingWidth
        let itemWidth = availableWidth / countOfCellsInRow
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * aspectRatio)
        
        return layout
    }()
    
    private lazy var collectionView: UICollectionView! = {
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.register(NFTCollectionViewCellThreePerRow.self)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    init(presenter: UsersCollectionPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
        configureCollectionView()
        presenter.viewDidLoad()
    }
    
    private func configureVC(){
        navigationController?.navigationBar.tintColor = .label
        title = "Коллекция NFT"
        view.backgroundColor = .systemBackground
        
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
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
}

extension UsersCollectionViewController: UsersCollectionView {
    
    func updateData(with nfts: [NftStatistics], id: String?, isCart: Bool?) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, NftStatistics>()
        snapshot.appendSections([.main])
        snapshot.appendItems(nfts)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        for (index, nft) in nfts.enumerated() {
            if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? NFTCollectionViewCellThreePerRow {
                cell.set(data: nft)
                
                let idOfCell = nft.id
                cell.setLikedStateToLikeButton(isLiked: presenter.isLiked(idOfCell))
                cell.setAddedStateToCart(isAdded: presenter.isAddedToCart(idOfCell))
                
                if let id,
                   let isCart,
                   cell.getId() == id {
                    cell.setIsUserInteractionEnabledToTrue(isCart: isCart)
                }
                
                cell.delegate = presenter
            }
        }
    }
}

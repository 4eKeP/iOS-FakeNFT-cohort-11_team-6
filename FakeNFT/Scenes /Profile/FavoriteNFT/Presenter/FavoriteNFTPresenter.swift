//
//  FavoriteNFTPresenter.swift
//  FakeNFT
//
//  Created by Dinara on 09.04.2024.
//

import Foundation

protocol FavoriteNFTPresenterProtocol: AnyObject {
    var view: FavoriteNFTViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class FavoriteNFTPresenter {
    weak var view: FavoriteNFTViewControllerProtocol?
    private let favoriteNFTService = FavoriteNFTService.shared
    var nftID: [String]
    var likedNFT: [String]
    var likes: [NFT] = []
    private let editProfileService: EditProfileService

    init(nftID: [String], likedNFT: [String], editProfileService: EditProfileService) {
        self.nftID = nftID
        self.likedNFT = likedNFT
        self.editProfileService = editProfileService
    }

    func tapLikeNFT(for nft: NFT) {
        if let index = likedNFT.firstIndex(of: nft.id) {
            likedNFT.remove(at: index)
            likes.removeAll { $0.id == nft.id }
        } else {
            likedNFT.append(nft.id)
            likes.append(nft)
        }
        updateLikes()
        view?.updateFavoriteNFTs(likes)
    }

    func isLiked(id: String) -> Bool {
        return likedNFT.contains(id)
    }
}

extension FavoriteNFTPresenter: FavoriteNFTPresenterProtocol {
    func viewDidLoad() {
        fetchFavoriteNFTs()
    }
}

private extension FavoriteNFTPresenter {
    func fetchFavoriteNFTs() {
        var allNFTs: [NFT] = []
        let group = DispatchGroup()

        for id in likedNFT {
            group.enter()

            favoriteNFTService.fetchNFTs(id) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let likes):
                    allNFTs.append(likes)
                case .failure(let error):
                    print("Failed to fetch NFTs: \(error)")
                }
            }
            group.notify(queue: .main) { [weak self] in
                self?.view?.updateFavoriteNFTs(allNFTs)
            }
        }
    }

    func updateLikes() {
        let model = EditProfileModel(
            name: nil,
            description: nil,
            avatar: nil,
            website: nil,
            likes: likedNFT
        )

        editProfileService.updateProfile(with: model) { result in
            switch result {
            case .success:
                print("Успешно")
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
}

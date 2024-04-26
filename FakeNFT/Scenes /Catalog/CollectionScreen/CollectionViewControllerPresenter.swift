//
//  CollectionViewControllerPresenter.swift
//  FakeNFT
//
//  Created by admin on 06.04.2024.
//

import UIKit
import SafariServices
import ProgressHUD

protocol CollectionViewControllerProtocol: NFTCollectionViewCellThreePerRowDelegate {
    var nftArray: [Nft] { get }
    func controllerDidLoad()
    func returnCollectionCell(for index: Int) -> CollectionCellModel
    func authorLinkTapped()
    func backButtonTapped()
}

final class CollectionViewControllerPresenter: CollectionViewControllerProtocol {
    
    weak var viewController: CollectionViewController?
    private let dispatchGroup = DispatchGroup()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    let nftModel: NFTCatalogModel
    var authorURL: String = ""
    var nftArray: [Nft] = []
    
    private var profile: Profile?
    private var cart: Cart?
    
    private var idLikes: Set<String> = []
    private var idAddedToCart: Set<String> = []
    
    private var idLikesForRequests: Set<String> = []
    private var idAddedToCartForRequests: Set<String> = []
    
    private let nftService: NftService
    private let profileService: ProfileService
    private let cartService: CartService
    
    init(nftCatalogModel nftModel: NFTCatalogModel,
         nftService: NftService,
         profileService: ProfileService,
         cartService: CartService) {
        self.nftModel = nftModel
        self.nftService = nftService
        self.profileService = profileService
        self.cartService = cartService
    }
    
    //MARK: - Public funcs
    
    func controllerDidLoad() {
        ProgressHUD.show()
        
        dispatchGroup.enter()
        loadProfile(httpMethod: .get, completion: { [weak self] error in
            guard let self else { return }
            dispatchGroup.leave()
            if error != nil { return }
        })
        
        dispatchGroup.enter()
        loadCart(httpMethod: .get, completion: { [weak self] error in
            guard let self else { return }
            dispatchGroup.leave()
            if error != nil { return }
        })
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            processNFTsLoading()
            ProgressHUD.dismiss()
        }
        
        prepareFullDataForShow()
    }
    
    func isLiked(_ idOfCell: String) -> Bool {
        idLikes.contains(idOfCell)
    }
    
    func isAddedToCart(_ idOfCell: String) -> Bool {
        idAddedToCart.contains(idOfCell)
    }
    
    func prepareFullDataForShow() {
        guard let coverURL = URL(string: nftModel.cover)  else { return assertionFailure("can't get cover URL") }
        let viewData = CollectionViewModel(coverImageURL: coverURL,
                                           title: nftModel.name,
                                           description: nftModel.description,
                                           authorName: nftModel.author)
        viewController?.show(viewCollectionViewModel: viewData)
    }
    
#warning("Сообщение для ревьюера: Наставник сказал написать это уведомление для Вас, так как в ответе от сервера отсутствует ссылка на сайт автора коллекции и это недоработка сервера как он сказал, так что наставник разрешил брать сайт автора первой nft в коллекции (к сожалению сайты которые даны в nft не рабочие но переход осуществляется по правильной ссылке)")
    func loadAuthorWebsite() {
        authorURL = nftArray[0].author
    }
    
    func authorLinkTapped() {
        if let url = URL(string: authorURL) {
            let safaryVC = SFSafariViewController(url: url)
            viewController?.configNavBackButton()
            viewController?.navigationController?.present(safaryVC, animated: true)
        }
    }
    
    func backButtonTapped() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func returnCollectionCell(for index: Int) -> CollectionCellModel {
        let nftForIndex = nftArray[index]
            return CollectionCellModel(image: nftForIndex.images[0],
                                                name: nftForIndex.name,
                                                rating: nftForIndex.rating,
                                                price: nftForIndex.price,
                                                isLiked: self.isLiked(nftForIndex.id),
                                                isAddedToCart: self.isAddedToCart(nftForIndex.id),
                                                id: nftForIndex.id
            )
    }
    
    //MARK: - Private funcs
    
    private func loadProfile(httpMethod: HttpMethod, id: String? = nil, completion: @escaping (Error?) -> Void) {
        var formData: String = ""
        if let profile {
            let profileDTO = Profile(
                name: profile.name,
                avatar: profile.avatar,
                description: profile.description,
                website: profile.website,
                nfts: profile.nfts,
                likes: Array(idLikesForRequests),
                id: profile.id
            )
            formData = profileDTO.toFormData()
        }
        
        profileService.loadProfile(httpMethod: httpMethod, model: formData) {[weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
                idLikes = Set(profile.likes)
                completion(nil)
            case .failure(let error):
                let errorModel = self.makeErrorModel(error, option: {
                    [weak self] in
                    guard let self else { return }
                    if let id {
                        likeTapped(id: id)
                    } else {
                        controllerDidLoad()
                    }
                })
                viewController?.showError(errorModel)
                completion(error)
            }
        }
        
    }
    
    private func loadCart(httpMethod: HttpMethod, id: String? = nil, completion: @escaping (Error?) -> Void ) {
        var formData: String = ""
        if let cart {
            let cartDTO = Cart(
                nfts: Array(idAddedToCartForRequests),
                id: cart.id)
            formData = cartDTO.toFormData()
        }
        
        cartService.loadCart(httpMethod: httpMethod, model: formData) {[weak self] result in
            guard let self else { return }
            switch result {
            case .success(let cart):
                self.cart = cart
                idAddedToCart = Set(cart.nfts)
                completion(nil)
            case .failure(let error):
                let errorModel = self.makeErrorModel(error, option: {
                    [weak self] in
                    guard let self else { return }
                    if let id {
                        cartTapped(id: id)
                    } else {
                        controllerDidLoad()
                    }
                })
                viewController?.showError(errorModel)
                completion(error)
            }
        }
    }
    
    private func processNFTsLoading() {
        for id in nftModel.nfts {
            loadNftById(id: id)
        }
    }
    
    private func loadNftById(id: String) {
        nftService.loadNft(id: id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let nft):
                nftArray.append(nft)
                loadAuthorWebsite()
                viewController?.reloadCollectionView()
            case .failure(let error):
                let errorModel = self.makeErrorModel(error, option: {self.loadNftById(id: id)})
                viewController?.showError(errorModel)
            }
        }
    }
    
    private func makeDataForCollectionCell(from nftArray: [Nft]) -> [CollectionCellModel] {
        var collectionCellModelArray: [CollectionCellModel] = []
        for nft in nftArray {
            let cellModel = CollectionCellModel(image: nft.images[0],
                                                name: nft.name,
                                                rating: nft.rating,
                                                price: nft.price,
                                                isLiked: self.isLiked(nft.id),
                                                isAddedToCart: self.isAddedToCart(nft.id),
                                                id: nft.id
            )
            collectionCellModelArray.append(cellModel)
        }
        return collectionCellModelArray
    }
}

//MARK: - NFTCollectionViewCellThreePerRowDelegate

extension CollectionViewControllerPresenter: NFTCollectionViewCellThreePerRowDelegate {
    func likeTapped(id: String) {
        
        idLikesForRequests = idLikes
        
        if idLikesForRequests.contains(id) {
            idLikesForRequests.remove(id)
        } else {
            idLikesForRequests.insert(id)
        }
        
        utilityQueue.async {[weak self] in
            self?.loadProfile(httpMethod: .put, id: id) { [weak self] _ in
                guard let self else { return }
                let collectionCellModel = makeDataForCollectionCell(from: nftArray)
                viewController?.reloadCollectionForLikesAndCard(with: collectionCellModel, id: id, isCart: false)
            }
        }
    }
    
    func cartTapped(id: String) {
        idAddedToCartForRequests = idAddedToCart
        
        if idAddedToCartForRequests.contains(id) {
            idAddedToCartForRequests.remove(id)
        } else {
            idAddedToCartForRequests.insert(id)
        }
        
        utilityQueue.async {[weak self] in
            self?.loadCart(httpMethod: .put, id: id){ [weak self] _ in
                guard let self else { return }
                let collectionCellModel = makeDataForCollectionCell(from: nftArray)
                viewController?.reloadCollectionForLikesAndCard(with: collectionCellModel, id: id, isCart: true)
            }
        }
    }
}

//MARK: - error handling

extension CollectionViewControllerPresenter {
    
    private func makeErrorModel(_ error: Error, option: (()->Void)?) -> ErrorModel {
        return ErrorModel {
            if let option {
                option()
            }
        }
    }
    
    func showAlertController(alerts: [AlertModel]) {
        let alertController = UIAlertController(
            title: L10n.Catalog.sorting,
            message: nil,
            preferredStyle: .actionSheet)
        
        for alert in alerts {
            let action = UIAlertAction(title: alert.title, style: alert.style) { _ in
                if let completion = alert.completion {
                    completion()
                }
            }
            alertController.addAction(action)
        }
        guard let viewController = viewController else { return }
        viewController.present(alertController, animated: true)
    }
}

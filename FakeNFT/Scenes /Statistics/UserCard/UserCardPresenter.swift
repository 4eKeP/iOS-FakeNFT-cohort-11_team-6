//
//  UserCardViewPresenter.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 31.03.2024.
//

import Foundation

protocol UserCardPresenter {
    func colletionNFTControlTapped()
    func websiteButtonTapped()
    func viewDidLoad()
    func backButtonPressed()
}

final class UserCardPresenterImpl: UserCardPresenter {

    private let router: StatisticsRouter
    private let userDetailed: UserDetailed
    
    weak var view: UserCardView?
    
    init(userDetailed: UserDetailed, router: StatisticsRouter) {
        self.userDetailed = userDetailed
        self.router = router
    }
    
    func viewDidLoad() {
        view?.updateData(with: userDetailed)
    }
    
    func colletionNFTControlTapped() {
        let userCollectionInput = StatisticsInput.nftIds(userDetailed.nfts)
        router.push(with: userCollectionInput)
    }
    
    func websiteButtonTapped() {
        router.presentSFViewController(urlStr: userDetailed.website)
    }
    
    func backButtonPressed() {
        router.pop()
    }
}

//
//  StatisticsPresenter.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 05.04.2024.
//

import Foundation

protocol StatisticsPresenter {
    func viewDidLoad()
    func nameSortActionTapped()
    func ratingSortActionTapped()
    func tableSelected(atRow: Int)
}

final class StatisticsPresenterImpl: StatisticsPresenter {
    private var users: [UserDetailed] = []
    
    private let usersService: UserDetailedService
    private let router: StatisticsRouter
    
    weak var view: StatisticsView?
    
    init(usersService: UserDetailedService, router: StatisticsRouter) {
        self.usersService = usersService
        self.router = router
    }
    
    func viewDidLoad() {
        loadUsers()
    }
    
    func nameSortActionTapped() {
        users = users.sorted(by: { $0.name < $1.name })
        view?.updateData(with: users)
    }
    
    func ratingSortActionTapped() {
        users = users.sorted(by: { $0.rating < $1.rating })
        view?.updateData(with: users)
    }
    
    func tableSelected(atRow index: Int) {
        let input = StatisticsInput.userDetailed(users[index])
        router.push(with: input)
    }
    
    private func loadUsers() {
        UIBlockingProgressHUD.show()
        usersService.loadUsers {[weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            switch result {
            case .success(let users):
                self.users = users.sorted(by: { $0.rating < $1.rating })
                view?.updateData(with: self.users)
            case .failure(_):
                view?.showError(ErrorModel {[weak self] in
                    self?.loadUsers()
                })
            }
        }
    }
}

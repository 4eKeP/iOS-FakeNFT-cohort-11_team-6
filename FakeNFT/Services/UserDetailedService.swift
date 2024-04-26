//
//  UserService.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 31.03.2024.
//

import Foundation

typealias UserDetailedCompletion = (Result<UserDetailed, Error>) -> Void
typealias UsersCompletion = (Result<[UserDetailed], Error>) -> Void

protocol UserDetailedService {
    func loadUserDetailed(id: String, completion: @escaping UserDetailedCompletion)
    func loadUsers(completion: @escaping UsersCompletion)
}

final class UserDetailedServiceImpl: UserDetailedService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadUserDetailed(id: String, completion: @escaping UserDetailedCompletion) {

        let request = UserDetailedBuildRequest(id: id)
        networkClient.send(request: request, type: UserDetailed.self) { result in
            switch result {
            case .success(let userDetailed):
                completion(.success(userDetailed))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadUsers(completion: @escaping UsersCompletion) {
        let request = UsersBuildRequest()
        networkClient.send(request: request, type: [UserDetailed].self) { result in
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

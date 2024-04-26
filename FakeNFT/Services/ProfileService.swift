//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 25.03.2024.
//

import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void

protocol ProfileService {
    func loadProfile(httpMethod: HttpMethod, model: (any Encodable)?, completion: @escaping ProfileCompletion)
}

final class ProfileServiceImpl: ProfileService {

    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadProfile(httpMethod: HttpMethod, model: (any Encodable)?, completion: @escaping ProfileCompletion) {
        let model = httpMethod == .get ? nil : model
        let request = ProfileRequest(method: httpMethod, model: model)
    
        networkClient.send(request: request, type: Profile.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
